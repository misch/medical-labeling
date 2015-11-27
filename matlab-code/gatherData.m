function gatherData(dataset, store_video_frames,new_eye_tracking_positions,show_eye_tracking_data,create_video_with_dots,extract_new_ROIs,show_ROIs,preprocessing_ROIs)
% This function can be applied when the video and the eye-tracking data is
% available (see ReadMe for the exact assumed file structure)
%
% Parameters:
%   - dataset: a number that indicates the data set
%   - store_video_frames: true --> each frame of the input-video is stored to
%   a frame.
%   - new_eye-tracking_positions: from an earlier stage, where eye-tracking
%   positions were simulated with the mouse - currently, this is
%   recommended to be set to false
%   - show_eye_tracking_data: boolean; whether or not to show the recorded
%   gaze positions on an image. Just for visualization, no need to do it.
%   - create_video_with_dots: booldean; whether or not to create a video to
%   show the recorded gaze positions. Just for visualization, no need to do
%   it.
%   - show_ROIs: whether or not to show an excerpt of the positive and
%   negative Regions of interest. Just for visualization, no need to do it.
%   - preprocessing_ROIs: whether or not to preprocess the gathered data;
%   that is, filtering, converting to gray scale, and shifting to zero mean

% Define data paths and actions
[dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(dataset);
video_filename = [dataset_folder,'video.avi'];


% Store video frames to .png images
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

%% Create video with recorded mouse positions
if (create_video_with_dots)
    makeVideoWithDots(frames_dir, framePositions, [dataset_folder, 'video_with_dots.avi']);
end
%% Get Regions of Interest (ROI's)
if (extract_new_ROIs)
    
%     [positive_ROIs, nPos] = extractPositivePatches(frames_dir, file_names, framePositions);
%     [negative_ROIs, nNeg] = extractNegativePatches(frames_dir, file_names, framePositions, frame_height, frame_width, ROI_type);
%  
%     save([dataset_folder,'raw_positiveROIs.mat'],'positive_ROIs','nPos');
%     save([dataset_folder,'raw_negativeROIs.mat'], 'negative_ROIs','nNeg','-v7.3');
    [positives, negatives] = getPositiveAndNegativeSuperpixels(frames_dir,file_names,framePositions);
else
    if (and(exist([dataset_folder,'raw_positiveROIs.mat'],'file') > 0,exist([dataset_folder,'raw_negativeROIs.mat'],'file') > 0))
            load([dataset_folder,'raw_positiveROIs.mat']);
            load([dataset_folder,'raw_negativeROIs.mat']);
    else
        disp('No ROI-files found...');
    end
end

%% Show ROIs
if (show_ROIs)
    figure(1);
    for i = 1:55
        subplot(8,8,i);
        if size(positive_ROIs,4) == 1
            imshow(positive_ROIs(:,:,i));
        else
            imshow(positive_ROIs(:,:,:,i));
        end
    end

    figure(2);
    for i = 1:64
        subplot(8,8,i);
        if size(negative_ROIs,4) == 1
            imshow(negative_ROIs(:,:,i));
        else
            imshow(negative_ROIs(:,:,:,i));
        end
    end
end

%% Preprocessing 
% each ROI is
%   - transformed into gray-scale
%   - resized to 32x32 pixels
%   - normalized in intensity (zero mean)

% each row represents a data point / ROI (1024 pixels)
if (preprocessing_ROIs)
    processed_ROIs = zeros(nPos+nNeg,32*32);
       
    h = waitbar(0,'Processing positive ROIs...');
    for i = 1:nPos
        if size(positive_ROIs,4) == 1
            ROI = process_ROI(positive_ROIs(:,:,i));
        else
            ROI = process_ROI(positive_ROIs(:,:,:,i));
        end
        processed_ROIs(i,:) = ROI(:);
        waitbar(i/nPos);
    end
    close(h)

    h = waitbar(0,'Processing negative ROIs...');
    for i = 1:nNeg
        if size(negative_ROIs,4) == 1
            ROI = process_ROI(negative_ROIs(:,:,i));
        else
            ROI = process_ROI(negative_ROIs(:,:,:,i));
        end
        processed_ROIs(i+nPos,:) = ROI(:);
        waitbar(i/nNeg);
    end
    close(h)
    
    labels = [ones(nPos,1); -ones(nNeg,1)];
    save([dataset_folder,'processed_ROIs.mat'],'processed_ROIs', 'labels');
end