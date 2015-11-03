%% Define data paths and actions
dataset = 8;

[dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(dataset);
video_filename = [dataset_folder,'video_uncompressed.avi'];

store_video_frames          =   false;
new_eye_tracking_positions  =   false;
show_eye_tracking_data      =   false;
extract_new_ROIs            =   false;
show_ROIs                   =   false;
preprocessing_ROIs          =   true;

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

    [positive_ROIs, nPos] = extractPositiveROIs(frames_dir, file_names, framePositions, 'patch');
    [negative_ROIs, nNeg] = extractNegativeROIs(frames_dir, file_names, framePositions, frame_height, frame_width, 'patch');

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