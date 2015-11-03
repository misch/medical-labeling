function [positives] = extractPositiveROIs(frames_dir, file_names,framePositions, ROI_type)
% positives = patch / superpixel / whatev around the frame position, if key pressed.


key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);


if (strcmp(ROI_type,'patch'))
    disp('Returning patches...');
    positives = zeros(128, 128, 3, length(interesting_frames));

    for i = 1:length(interesting_frames)
       image_file = [frames_dir, interesting_frames(i).name] 
       image = im2double(imread(image_file));

       positives(:,:,:,i) = getPatchAtPosition(image, flip(framePositions(i,1:2)));
    end

    % discard zeros-ROIs
    positives = positives(:,:,:,any(any(any(positives))));
else
    disp('patch is the only implemented ROI_type');
    positives = 0;
end