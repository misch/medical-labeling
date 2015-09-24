
%% Define dataset and folders where to find them.
dataset = 2;

dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

video_filename = [dataset_folder,'Video.avi'];
frames_dir = [dataset_folder,'input-frames/'];

%% Store video frames to .png images
% videoToFrames(video_filename, frames_dir);

%% Get Eye-Tracking information
new_eye_tracking_positions = true;

if (new_eye_tracking_positions)
    framePositions = simulateEyeTracking(video_filename);
    save([dataset_folder,'new_framePositions.mat'],'framePositions');
else
    filename = [dataset_folder, 'framePositions.mat'];
    load(filename); % framePositions.mat contains a variable 'framePositions'
end

%% Show images with recorded mouse positions
showImagesAndEyeTrackingData(video_filename, framePositions);

%% Extract Regions of Interest (ROI's)
file_names = dir([frames_dir, '\*.png']);
num_frames = length(file_names);
positive_ROIs = zeros(128,128,3,num_frames);

for i = 1:num_frames
    image_file = [frames_dir, file_names(i).name];
    image = imread(image_file);
    positive_ROIs(:,:,:,i) = getPositiveROI(image, framePositions(i,:));
end
