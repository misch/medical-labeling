function assembleTrainingDataPatches(dataset, output_filename)
% ASSEMBLETRAININGDATAPATCHES assemble a training set with the gaze
% positions as center of the positive image patches and everything else as negatives. The
% patches are preprocessed as suggested in Vilarino et al.
% (http://link.springer.com/chapter/10.1007%2F978-3-540-72847-4_38).
%
% This function needs the following things to be available: 
%   - an available recording of the eye-tracking data to find the positives
%   - the input frames as png images in the folder input-frames (see also
%   README.md)
%
% Input:
%   - dataset: a int number that indicates the data set
%   - output_filename: the name of the file where the training data should
%   be stored. e.g. 'trainingDataPatches.mat'


% Define data paths and actions
[dataset_folder, frames_dir, file_names, frame_height, frame_width] = getDatasetDetails(dataset);

%% Get Eye-Tracking information
    filename = [dataset_folder, 'gaze-measurements/video2.csv'];
    framePositions = readCSVFile(filename);
    framePositions(:,1) = framePositions(:,1) * frame_width;
    framePositions(:,2) = framePositions(:,2) * frame_height;

%% Get Regions of Interest (ROI's)
extract_new_ROIs = true; % can be changed if, for some reason, only the preprocess-steps are changed
if (extract_new_ROIs)
    
    [positive_ROIs, nPos, pos_frame_numbers] = extractPositivePatches(frames_dir, file_names, framePositions);
    [negative_ROIs, nNeg, neg_frame_numbers] = extractNegativePatches(frames_dir, file_names, framePositions, frame_height, frame_width);
 
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


pos_gaze_positions = flip(round(framePositions(pos_frame_numbers,:),2));
neg_gaze_positions = flip(round(framePositions(neg_frame_numbers,:),2));

training_set = struct(  'data',processed_ROIs,...
                        'labels',labels,...
                        'frame_numbers',[pos_frame_numbers;neg_frame_numbers],...
                        'superpixel_idx',NaN,...
                        'gaze_position',[pos_gaze_positions; neg_gaze_positions],...
                        'median_superpixel_pos',NaN);

save([dataset_folder,output_filename],'training_set','-v7.3');
disp(['Saved training data to: ', dataset_folder, output_filename]);