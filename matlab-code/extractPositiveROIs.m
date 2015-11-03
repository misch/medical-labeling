function [positives, nROIs] = extractPositiveROIs(frames_dir, file_names,framePositions, ROI_type)
% positives = patch / superpixel / whatev around the frame position, if key pressed.


key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);

frame_dimensions = size(im2double(imread([frames_dir, file_names(1).name])),3);


if (strcmp(ROI_type,'patch'))
    disp('Returning patches...');
    positives = zeros(128, 128, frame_dimensions, length(interesting_frames));

    for i = 1:length(interesting_frames)
       image_file = [frames_dir, interesting_frames(i).name]; 
       image = im2double(imread(image_file));
       positives(:,:,:,i) = getPatchAtPosition(image, flip(framePositions(i,1:2)));
    end
   
    if size(positives,3) == 1 % if gray-scale patches
        positives = squeeze(positives);
        positives = positives(:,:,any(any(positives)));
        nROIs = size(positives,3);
    elseif size(positives,3) == 3
        positives = positives(:,:,:,any(any(any(positives))));
        nROIs = size(positives,4);
    else
        disp('Weird frame dimensions...');
    end
        
else
    disp('patch is the only implemented ROI_type');
    positives = 0;
end