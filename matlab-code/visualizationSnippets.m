%% Show images with recorded mouse positions

    showImagesAndEyeTrackingData(video_filename, framePositions);


%% Create video with recorded mouse positions
dataset = 5;
[dataset_folder, frames_dir, ~, frame_height, frame_width] = getDatasetDetails(dataset);

filename = [dataset_folder, 'framePositions6.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

    makeVideoWithDots(frames_dir, framePositions, [dataset_folder, 'with_dots6.avi'],20);

%% Show ROIs - in case of quadratic patches...
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