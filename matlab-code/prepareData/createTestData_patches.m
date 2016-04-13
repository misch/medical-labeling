function [test_data, test_labels] = createTestData_patches(frames_dir,descriptor_dir,frame_percentage,ground_truth_dir)
% CREATETESTDATA_PATCHES create test data to later measure the
% performance. The returned patches have the correct labels according to
% the manually labeled ground truth. The function stores the gathered
% descriptors for each frame in a single file.
%
% input:
%   - frames_dir: path to the directory that contains the input-frames 
%   - descriptor_dir: path to the directory where the descriptors for each
%   frame will be stored
%   - frame_percentage: int between 0-100, giving the approximate amount of frames for which the
%   descriptors should be collected (if specific frames should be
%   generated, the variable frame_indices inside the function should be
%   manipulated)
%   - gorund_truth-dir: path to the directory containing manually labeled
%   ground truth to get the correct labels

    ground_truth_dir_exists = (ground_truth_dir ~= 0);
    
    file_names = dir([frames_dir, '*.png']);
    
    if (ground_truth_dir_exists)
        ground_truth_names = dir([ground_truth_dir, '*.png']);
    end

    num_frames = length(file_names);
    frame_indices = find(rand(1,num_frames) <= frame_percentage/100);
    % Collect the descriptors for only the frames 2 and 3.
    % frame_indices = [2,3];

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
            gt = 0;
            [test_data, test_labels] = extractPatchesAndLabels(test_frames(:,:,frame),gt);
        else
            [test_data, test_labels] = extractPatchesAndLabels(test_frames(:,:,frame),ground_truth_frames(:,:,frame));
        end
        
        disp('reshaping...');
        test_data = reshape(test_data,size(test_data,1)*size(test_data,2),[])';
        disp('reshaped.');
    
        % to get the 32x32-images back (e.g. to display it):
        % reshape(test_data',32,32,[])
        
        disp('Creating frame descriptor...');
        frameDescriptor = struct('features',test_data,'groundTruthLabels', test_labels);
        disp('created frameDescriptor');
        save([descriptor_dir,'frame_',sprintf('%05d', frame_indices(frame)),'.mat'], 'frameDescriptor','-v7.3')
        
        disp(sprintf('%02d/%02d',frame,size(test_frames,3)));
    end