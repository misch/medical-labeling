function [negatives] = extractNegativeROIs(frames_dir, file_names, framePositions, frame_height, frame_width, ROI_type)
% This function returns 128x128x3 image patches representing a negative Regions of Interest.
% Parameters:
%   - framePositions: the position of the positive ROI in the frame (to avoid
%   overlaps with negative ones)

key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);


if (strcmp(ROI_type,'patch'))
    disp('Returning patches...');
    
    num_negatives = length(interesting_frames)*round(frame_width/64)*round(frame_height/64); % just a rough upper bound for number of negatives
    negatives = zeros(128, 128, 3, num_negatives);

    neg_idx = 1;
    for i = 1:length(interesting_frames)
       image_file = [frames_dir, interesting_frames(i).name] ;
       image = im2double(imread(image_file));
       
       [negative_patches_from_frame, nPatches] = getNonOverlappingPatches(image, flip(framePositions(i,1:2)));
       
       negatives(:,:,:,neg_idx:neg_idx+nPatches-1) = negative_patches_from_frame;
       neg_idx = neg_idx + nPatches;
    end
    negatives = negatives(:,:,:,any(any(any(negatives))));
else
    disp('patch is the only implemented ROI_type');
    negatives = 0;
end






