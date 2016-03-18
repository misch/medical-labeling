function assembleReferenceTrainingDataSuperpixels(dataset,output_filename,ground_truth_dir)
    % This function can be applied when the video and the eye-tracking data is
    % available (see ReadMe for the exact assumed file structure)
    %
    % Parameters:
    %   - dataset: 
    %         a number that indicates the data set
    %   - output_filename:
    %         filename to store the final training set (will be stored in
    %         the dataset-folder)


    % Define data paths and actions
    [dataset_folder, ~, ~, frame_height, frame_width] = getDatasetDetails(dataset);


    % Get Eye-Tracking information
    filename = [dataset_folder, 'framePositions.csv'];
    framePositions = readCSVFile(filename);
    framePositions(:,1) = framePositions(:,1) * frame_width;
    framePositions(:,2) = framePositions(:,2) * frame_height;
    key_pressed = (framePositions(:,3) > 0);

    %% Get Regions of Interest (ROI's)
    disp('In which folder are the descriptors stored?');
    descriptors_dir = [uigetdir(dataset_folder),'/'];
    file_names = dir([descriptors_dir,'*.mat']);

    interesting_frames = file_names(key_pressed);
    interesting_frames_indices = find(key_pressed); % just for later verification of frame numbering

    training_set = struct(  'data',[],...
                            'labels',[],...
                            'frame_numbers',[],...
                            'superpixel_idx',[],...
                            'gaze_position',[],...
                            'median_superpixel_pos',[]);

    for i = 1:length(interesting_frames)
        idx = interesting_frames_indices(i);

        descriptor_file = [descriptors_dir, interesting_frames(i).name]; 
        tmp = load(descriptor_file);
        frameDescriptor = tmp.frameDescriptor;

        if (frameDescriptor.frame_no ~= idx)
            disp('Something went wrong with the frame numbering!');
            disp(sprintf('frameDescriptor.frame_no = %d, idx = %d',frameDescriptor.frame_no, idx));
            return;
        end

        n_samples = length(frameDescriptor.superpixel_idx);

        gaze_x = round(framePositions(idx,2));
        gaze_y = round(framePositions(idx,1));
        
        gt_name = interesting_frames(i).name;
        gt_name = [gt_name(1:end-3),'png'];
        gt = getGrayScaleImage([ground_truth_dir,gt_name]); 

        
        threshold = 0.1;
        positive_fraction = zeros(n_samples,1);
        running_idx = 1;
        for sup_idx = frameDescriptor.superpixel_idx'
            mask = (frameDescriptor.superpixels == sup_idx);
            values = gt(mask);
            
            if (~isempty(values))
                positive_fraction(running_idx) = sum(values > threshold)/length(values);
            else
                disp('Omg there has been an empty superpixel in a descriptor!');
            end
            running_idx = running_idx + 1;
        end

        positive_mask = ismember(frameDescriptor.superpixel_idx,frameDescriptor.superpixel_idx(positive_fraction >= 0.3));
        negative_mask = ~positive_mask;
        
        med_superpix_pos = zeros(n_samples,2);
        vec_idx = 1;
        
        for jj = frameDescriptor.superpixel_idx'
            [X,Y] = ind2sub([frame_height,frame_width],(find(frameDescriptor.superpixels == jj)));
            med_superpix_pos(vec_idx,:) = median([X,Y]);
            vec_idx = vec_idx + 1;
        end

        appendSamples(  frameDescriptor.features,... % data
                        positive_mask-negative_mask,... % labels
                        idx * ones(n_samples,1),... % originate frame_no for each sample
                        frameDescriptor.superpixel_idx,... % originate superpixel for each sample
                        repmat([gaze_x,gaze_y],n_samples,1),...
                        med_superpix_pos); % observed gaze-position when this sample was taken
    end
    
    function appendSamples(data,labels,frame_numbers,sup_idx,gaze,med_superpix_pos)
        training_set.data = cat(1,training_set.data,data);
        training_set.labels = cat(1,training_set.labels,labels);
        training_set.frame_numbers = cat(1,training_set.frame_numbers,frame_numbers);
        training_set.superpixel_idx = cat(1,training_set.superpixel_idx,sup_idx);
        training_set.gaze_position = cat(1,training_set.gaze_position,gaze);
        training_set.median_superpixel_pos = cat(1,training_set.median_superpixel_pos,med_superpix_pos);
    end

    save([dataset_folder,output_filename],'training_set');
    disp(['Saved training data to: ', dataset_folder, output_filename]);
    
    % Show, for a particular frame (frameDescriptor) what pixels are
    % positive according to ground truth
%     imshow(ismember(frameDescriptor.superpixels,training_set.superpixel_idx(and(training_set.frame_numbers == frameDescriptor.frame_no,training_set.labels == 1))))
end
