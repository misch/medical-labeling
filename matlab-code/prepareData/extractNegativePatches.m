function [negatives, nROIs, frame_numbers] = extractNegativePatches(frames_dir, file_names, framePositions, frame_height, frame_width)
% EXTRACTNEGATIVEPATCHES return 128x128x3 image patches representing negative Regions of Interest (patches that do not overlap with the patch around the gaze position).
%
% Parameters:
%   - frames_dir: path to the directory that contains the input frames
%   (usually '.../input-frames', see README.md)
%   - file_names: a list of the file names in the folder frames_dir
%   - framePositions: the positions and key_pressed-values of the positive ROI in the frame (to avoid
%   overlaps with negative ones), usually taken from a csv-file with gaze
%   records
%   - frame_height: frame height
%   - frame_width: frame width

key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

frame_dimensions = size(im2double(imread([frames_dir, file_names(1).name])),3);

disp('Returning patches...');

num_negatives = length(interesting_frames)*round(frame_width/64)*round(frame_height/64); % just a rough upper bound for number of negatives
negatives = zeros(128, 128, frame_dimensions, num_negatives);
frame_numbers = [];
neg_idx = 1;
for i = 1:length(interesting_frames)
   image_file = [frames_dir, interesting_frames(i).name] ;
   image = im2double(imread(image_file));
   idx = interesting_frames_indices(i);
   [negative_patches_from_frame, nPatches] = getNonOverlappingPatches(image, flip(framePositions(idx,1:2)), frame_dimensions);
   frame_numbers = cat(1,frame_numbers,idx*ones(nPatches,1));

   negatives(:,:,:,neg_idx:neg_idx+nPatches-1) = negative_patches_from_frame;
   neg_idx = neg_idx + nPatches;
end


% Discard zeros-ROIs
if size(negatives,3) == 1 % if gray-scale patches
    negatives = squeeze(negatives);
    negatives = negatives(:,:,any(any(negatives)));
    frame_numbers = frame_numbers(any(any(negatives)));
    nROIs = size(negatives,3);
elseif size(negatives,3) == 3
    negatives = negatives(:,:,:,any(any(any(negatives))));
    frame_numbers = frame_numbers(any(any(any(negatives))));
    nROIs = size(negatives,4);
else
    error('Weird frame dimensions...');
end