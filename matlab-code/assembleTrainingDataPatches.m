function assembleTrainingDataPatches(dataset)
% This function can be applied when the input- and ground-truth-frames and
% the eye-tracking data are available (use script "prepareData" to make
% everything ready).
%
% Parameters:
%   - dataset: a number that indicates the data set


% Define data paths and actions
[dataset_folder, frames_dir, file_names, frame_height, frame_width] = getDatasetDetails(dataset);

%% Get Eye-Tracking information
    filename = [dataset_folder, 'framePositions.csv'];
    framePositions = readCSVFile(filename);
    framePositions(:,1) = framePositions(:,1) * frame_width;
    framePositions(:,2) = framePositions(:,2) * frame_height;

%% Get Regions of Interest (ROI's)
extract_new_ROIs = true; % can be changed if, for some reason, only the preprocess-steps are changed
if (extract_new_ROIs)
    
    [positive_ROIs, nPos] = extractPositivePatches(frames_dir, file_names, framePositions);
    [negative_ROIs, nNeg] = extractNegativePatches(frames_dir, file_names, framePositions, frame_height, frame_width, ROI_type);
 
    save([dataset_folder,'raw_positiveROIs.mat'],'positive_ROIs','nPos');
    save([dataset_folder,'raw_negativeROIs.mat'], 'negative_ROIs','nNeg','-v7.3');
else
    if (and(exist([dataset_folder,'raw_positiveROIs.mat'],'file') > 0,exist([dataset_folder,'raw_negativeROIs.mat'],'file') > 0))
            load([dataset_folder,'raw_positiveROIs.mat']);
            load([dataset_folder,'raw_negativeROIs.mat']);
    else
        disp('No ROI-files found...');
    end
end


%% Preprocessing 
% each ROI is
%   - transformed into gray-scale
%   - resized to 32x32 pixels
%   - normalized in intensity (zero mean)

% each row represents a data point / ROI (1024 pixels)
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
save([dataset_folder,'trainingPatches.mat'],'processed_ROIs', 'labels');
disp(['Saved training data to: ', dataset_folder, 'trainingPatches.mat']);