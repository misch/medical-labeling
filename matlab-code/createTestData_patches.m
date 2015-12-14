function [test_data, test_labels] = createTestData_patches(frames_dir,descriptor_dir,frame_percentage,ground_truth_dir)
% This function doesn't use the precomputed patch descriptors because for
% most datasets, not all of them are computed and therefore the positive
% and negative patches for the interesting frames are extracted here
% directly from the images.
    ground_truth_dir_exists = (ground_truth_dir ~= 0);
    
    file_names = dir([frames_dir, '*.png']);
    
    if (ground_truth_dir_exists)
        ground_truth_names = dir([ground_truth_dir, '*.png']);
    end

    num_frames = length(file_names);
    frame_indices = find(rand(1,num_frames) <= frame_percentage/100);
    frame_indices = [105:50:655];

    ref_frame = imread([frames_dir,file_names(1).name]);

    test_frames = zeros([size(ref_frame,1), size(ref_frame,2), length(frame_indices)]);    
    ground_truth_frames = zeros([size(ref_frame,1), size(ref_frame,2), length(frame_indices)]);
    
    i = 1;

    for idx = frame_indices 
        image_file = [frames_dir, file_names(idx).name];
        image = getGrayScaleImage(image_file);
        
        test_frames(:,:,i) = image;
        if (ground_truth_dir_exists)
            ground_truth_file = [ground_truth_dir, ground_truth_names(idx).name];
            ground_truth_frames(:,:,i) = getGrayScaleImage(ground_truth_file);
            % ground truth is +1 where the ground-truth video has a value higher than threshold
            threshold = 0.1;
            ground_truth_frames(ground_truth_frames > threshold) = 1;
            ground_truth_frames(ground_truth_frames < threshold) = -1;
        end
        i = i + 1;
    end

    for frame = 1:size(test_frames,3)
        if (~ground_truth_dir_exists)
            [FileName,PathName] = uigetfile('../data/*.png',['Select a ground truth file for ',file_names(frame_indices(frame))]);
            if FileName == 0
                gt = 0;
            else
                gt = getGrayScaleImage([PathName,FileName]);
            end
            [test_data, test_labels] = extractPatchesAndLabels(test_frames(:,:,frame),gt);
        else
            [test_data, test_labels] = extractPatchesAndLabels(test_frames(:,:,frame),ground_truth_frames(:,:,frame));
        end
        
        disp('reshaping...');
        test_data = reshape(test_data,size(test_data,1)*size(test_data,2),[])';
        disp('reshaped.');
    
        % to get the 32x32-images back:
        % reshape(test_data',32,32,[])
        
        disp('Creating frame descriptor...');
        frameDescriptor = struct('features',test_data,'groundTruthLabels', test_labels);
        disp('created frameDescriptor');
        save([descriptor_dir,'frame_',sprintf('%05d', frame_indices(frame)),'.mat'], 'frameDescriptor','-v7.3')
        
        disp(sprintf('%02d/%02d',frame,size(test_frames,3)));
    end