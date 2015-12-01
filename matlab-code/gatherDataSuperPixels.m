function gatherDataSuperPixels(dataset, store_video_frames,show_eye_tracking_data,create_video_with_dots)
% This function can be applied when the video and the eye-tracking data is
% available (see ReadMe for the exact assumed file structure)
%
% Parameters:
%   - dataset: 
%         a number that indicates the data set
%   - store_video_frames: 
%         true --> each frame of the input-video is stored to a frame.
%   - new_eye-tracking_positions: 
%         from an earlier stage, where eye-tracking
%         positions were simulated with the mouse - currently, this is
%         recommended to be set to false
%   - show_eye_tracking_data: 
%         boolean; whether or not to show the recorded gaze positions 
%         on an image. Just for visualization, no need to do it.
%   - create_video_with_dots: 
%        booldean; whether or not to create a video to
%        show the recorded gaze positions. Just for visualization, no need to do it.

% Define data paths and actions
[dataset_folder, frames_dir, file_names, frame_height, frame_width] = getDatasetDetails(dataset);
video_filename = [dataset_folder,'video.avi'];


% Store video frames to .png images
if (store_video_frames)
    videoToFrames(video_filename, frames_dir);
end

%% Get Eye-Tracking information
filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

%% Show images with recorded mouse positions
if (show_eye_tracking_data)
    showImagesAndEyeTrackingData(video_filename, framePositions);
end

%% Create video with recorded mouse positions
if (create_video_with_dots)
    makeVideoWithDots(frames_dir, framePositions, [dataset_folder, 'video_with_dots.avi']);
end

%% Get Regions of Interest (ROI's)
[positive_ROIs, negative_ROIs] = getPositiveAndNegativeSuperpixels(frames_dir,file_names,framePositions);


nPos = size(positive_ROIs,1);
nNeg = size(negative_ROIs,1);

processed_ROIs = cat(1,positive_ROIs, negative_ROIs);
labels = [ones(nPos,1); -ones(nNeg,1)];

save([dataset_folder,'superpixelFeatures.mat'],'processed_ROIs', 'labels');
disp(['Saved training data to: ', dataset_folder, 'superpixelFeatures.mat']);