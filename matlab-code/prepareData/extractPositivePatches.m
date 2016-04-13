function [positives, nROIs, interesting_frames_indices] = extractPositivePatches(frames_dir, file_names,framePositions)
% EXTRACTPOSIIVEPATCHES return the positive 128x128-patches from the
% frames where the user pressed the key. The positive patch of a frame is the one
% centered at the recorded gaze position.
%
% input:
%   - frames_dir: path to directory that contains the input frames
%   - file_names: list of files contained in the folder (as gained with the
%   dir() function)
%   - framePositions: the recorded gaze positions (in pixel coordinates) and key_pressed-values
%

key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

frame_dimensions = size(im2double(imread([frames_dir, file_names(1).name])),3);

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