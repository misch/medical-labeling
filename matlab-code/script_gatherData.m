%% Define data paths and actions
dataset = 6;

[dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(dataset);
video_filename = [dataset_folder,'video_uncompressed.avi'];

store_video_frames          =   false;
new_eye_tracking_positions  =   false;
show_eye_tracking_data      =   true;
extract_new_ROIs            =   false;
show_ROIs                   =   false;
preprocessing_ROIs          =   false;

%% Store video frames to .png images
if (store_video_frames)
    videoToFrames(video_filename, frames_dir);
end

%% Get Eye-Tracking information
if (new_eye_tracking_positions)
    framePositions = simulateEyeTracking(video_filename);
    save([dataset_folder,'framePositions.mat'],'framePositions');
else
%     filename = [dataset_folder, 'framePositions.mat'];
%     load(filename); % framePositions.mat contains a variable 'framePositions'
    filename = [dataset_folder, 'framePositions.csv'];
    framePositions = readCSVFile(filename);
    framePositions(:,1) = framePositions(:,1) * frame_width;
    framePositions(:,2) = framePositions(:,2) * frame_height;
end

%% Show images with recorded mouse positions
if (show_eye_tracking_data)
    showImagesAndEyeTrackingData(video_filename, framePositions);
end

%% Get Regions of Interest (ROI's)
if (extract_new_ROIs)
    positive_ROIs = zeros(128,128,3,num_frames);
    num_negatives = num_frames*round(frame_width/64)*round(frame_height/64); % just a rough upper bound for number of negatives
    matObj = matfile('tmpNeg.mat','Writable',true);
    
    matObj.negative_ROIs(128,128,3,num_negatives) = 0; % for each frame, define 2 negative ROIs
  
    h = waitbar(0,'Extracting ROIs...');
    neg_idx = 1;
    for i = 1:num_frames
        image_file = [frames_dir, file_names(i).name];
        image = im2double(imread(image_file));

        positive_ROIs(:,:,:,i) = getPatchAtPosition(image, flip(framePositions(i,:)));
        
        patches = getNegativeROIs(image,flip(framePositions(i,:)));
        patches = patches(:,:,:,any(any(any(patches))));
        nPatches = size(patches,4);
        
        matObj.negative_ROIs(:,:,:,neg_idx:neg_idx+nPatches-1) = patches;
        neg_idx = neg_idx + nPatches;
        
        waitbar(i/num_frames);
    end
    
    close(h);
    
    % discard zero-ROIs and save ROIs to variable
    positive_ROIs = positive_ROIs(:,:,:,any(any(any(positive_ROIs))));
    save([dataset_folder,'raw_positiveROIs.mat'],'positive_ROIs');
    
    % store only the necessary part of the variable
    negMatObj = matfile([dataset_folder,'raw_negativeROIs.mat'],'Writable',true);
    negMatObj.negative_ROIs(128,128,3,neg_idx-1) = 0;
    
    i = 0;
    max_idx = 0;
    while (max_idx < neg_idx-1)
        min_idx = i*10000+1;
        max_idx = min((i+1)*10000,neg_idx-1);
        negMatObj.negative_ROIs(:,:,:,min_idx:max_idx) = matObj.negative_ROIs(:,:,:,min_idx:max_idx);
        i = i + 1;
    end
    
    delete('tmpNeg.mat');

else
    if (and(exist([dataset_folder,'raw_positiveROIs.mat'],'file') > 0,exist([dataset_folder,'raw_negativeROIs.mat'],'file') > 0))
            load([dataset_folder,'raw_positiveROIs.mat']);
            negMatObj = matfile([dataset_folder,'raw_negativeROIs.mat']);
    else
        disp('No ROI-files found...');
    end
end

%% Show ROIs
if (show_ROIs)
    figure(1);
    for i = 201:300
        subplot(10,10,i-200);
        imshow(positive_ROIs(:,:,:,i));
    end

    figure(2);
    for i = 201:300
        subplot(10,10,i-200);
        imshow(negMatObj.negative_ROIs(:,:,:,i));
    end
end

%% Preprocessing 
% each ROI is
%   - transformed into gray-scale
%   - resized to 32x32 pixels
%   - normalized in intensity (zero mean)

% each row represents a data point / ROI (1024 pixels)
if (preprocessing_ROIs)
    num_pos_ROIs = size(positive_ROIs,4);
    num_neg_ROIs = size(negMatObj,'negative_ROIs',4);
    
    processed_ROIs = zeros(num_pos_ROIs+num_neg_ROIs,32*32);
    labels = [ones(num_pos_ROIs,1); -ones(num_neg_ROIs,1)];
    
    
    h = waitbar(0,'Processing positive ROIs...');
    for i = 1:num_pos_ROIs
        ROI = process_ROI(positive_ROIs(:,:,:,i));
        processed_ROIs(i,:) = ROI(:);
        waitbar(i/num_pos_ROIs);
    end
    close(h)

    h = waitbar(0,'Processing negative ROIs...');
    
    bunch = 0;
    max_idx = 0;
    while (max_idx < num_neg_ROIs)
        min_idx = bunch*1000+1;
        max_idx = min((bunch+1)*1000,num_neg_ROIs);
        ROI_bunch = negMatObj.negative_ROIs(:,:,:,min_idx:max_idx);
        for i = 1:size(ROI_bunch,4)
           ROI = process_ROI(ROI_bunch(:,:,:,i));
           neg_idx = num_pos_ROIs+min_idx+i-1;
           processed_ROIs(neg_idx,:) = ROI(:);
        end
        bunch = bunch + 1;
        waitbar(max_idx/num_neg_ROIs);
    end
    close(h);
    
    save([dataset_folder,'processed_ROIs.mat'],'processed_ROIs', 'labels');
    
    % accessing all the positive ROIs:
    % processed_ROIs(labels > 0,:)
end