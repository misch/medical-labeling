function [positives, nROIs] = extractPositiveROIs(frames_dir, file_names,framePositions, ROI_type)
% positives = patch / superpixel / whatev around the frame position, if key pressed.

% Usage:
% extractPositiveROIs(frames_dir, file_names,framePositions, 'superpixel')
%

key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

frame_dimensions = size(im2double(imread([frames_dir, file_names(1).name])),3);


if (strcmp(ROI_type,'patch'))
    disp('Returning patches...');
    positives = zeros(128, 128, frame_dimensions, length(interesting_frames));

    for i = 1:length(interesting_frames)
       idx = interesting_frames_indices(i);
       image_file = [frames_dir, interesting_frames(i).name]; 
       image = im2double(imread(image_file));
       positives(:,:,:,i) = getPatchAtPosition(image, flip(framePositions(idx,1:2))); 
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
        
elseif(strcmp(ROI_type,'superpixel'))
    regularizer = 0.05;

    positives = zeros(42,length(interesting_frames));
    for i = 1:length(interesting_frames)
        idx = interesting_frames_indices(i);
        image_file = [frames_dir, interesting_frames(i).name]; 
        image = im2double(imread(image_file));
        
        lab_image = image;
        
        if (size(image,3) == 3)
            lab_image = rgb2lab(image);
        end
        
        superpixel_size = round(min([size(image,1), size(image,2)]) / 11.5);
        super_img = getSuperPixels(single(lab_image), superpixel_size, regularizer);
        mask = (super_img == super_img(round(framePositions(idx,2)),round(framePositions(idx,1))));
        positives(:,i) = getSuperpixelFeatures(image, mask);
    end
else
    disp('patch and superpixel are the only implemented possibilities for ROI_type');
    positives = 0;
end