%% Show images with recorded mouse positions

    showImagesAndEyeTrackingData(video_filename, framePositions);


%% Create video with recorded mouse positions

    makeVideoWithDots(frames_dir, framePositions, [dataset_folder, 'video_with_dots.avi']);

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