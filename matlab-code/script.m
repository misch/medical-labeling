
%% Define dataset and folders where to find them.
dataset = 2;

dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

video_filename = [dataset_folder,'Video.avi'];
frames_dir = [dataset_folder,'input-frames/'];

%% Store video frames to .png images
% videoToFrames(video_filename, frames_dir);

%% Get Eye-Tracking information
new_eye_tracking_positions = false;

if (new_eye_tracking_positions)
    framePositions = simulateEyeTracking(video_filename);
    save([dataset_folder,'new_framePositions.mat'],'framePositions');
else
    filename = [dataset_folder, 'framePositions.mat'];
    load(filename); % framePositions.mat contains a variable 'framePositions'
end

%% Show images with recorded mouse positions
showImagesAndEyeTrackingData(video_filename, framePositions);


