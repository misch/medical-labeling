function assembleTrainingDataSuperpixels(dataset)
% This function can be applied when the video and the eye-tracking data is
% available (see ReadMe for the exact assumed file structure)
%
% Parameters:
%   - dataset: 
%         a number that indicates the data set


% Define data paths and actions
[dataset_folder, ~, ~, frame_height, frame_width] = getDatasetDetails(dataset);


% Get Eye-Tracking information
filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;


%% Get Regions of Interest (ROI's)
disp('In which folder are the descriptors stored?');
descriptor_dir = [uigetdir(dataset_folder),'/'];
[positive_ROIs, negative_ROIs] = getPositiveAndNegativeSuperpixels(descriptor_dir,framePositions);


nPos = size(positive_ROIs,1);
nNeg = size(negative_ROIs,1);

processed_ROIs = cat(1,positive_ROIs, negative_ROIs);
labels = [ones(nPos,1); -ones(nNeg,1)];

save([dataset_folder,'trainingSuperpixels.mat'],'processed_ROIs', 'labels');
disp(['Saved training data to: ', dataset_folder, 'trainingSuperpixels.mat']);