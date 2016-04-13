function [interesting_frames_indices,positive_fraction] = getFractionOfPositiveAndNegativeSuperpixels(descriptors_dir, ground_truth_dir, framePositions)
% GETFRACTIONOFPOSITIVEANDNEGATIVESUPERPIXELS for the positive superpixels
% extracted by some gaze records, get the amount of true positive pixels
% inside the superpixels
%
% input:
%   - descriptors_dir: path to the descriptors
%   - ground_truth_dir: path to the ground truth directory
%   - framePositions: the collected gaze positions and key_pressed-values
%   of one gaze record
file_names = dir([descriptors_dir,'*.mat']);
key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

    
    positive_fraction = [];
    for i = 1:length(interesting_frames)
        idx = interesting_frames_indices(i);
        descriptor_file = [descriptors_dir, interesting_frames(i).name]; 
        
        load(descriptor_file);
        
        gazeSuperPixelID = frameDescriptor.superpixels(round(framePositions(idx,2)),round(framePositions(idx,1)));
        
        % get ground-truth values for the superpixel
        gt_name = interesting_frames(i).name;
        gt_name = [gt_name(1:end-3),'png'];
        gt = getGrayScaleImage([ground_truth_dir,gt_name]);
        mask = (frameDescriptor.superpixels == gazeSuperPixelID);
        values = gt(mask);
    

        threshold = 0.1;
        if (~isempty(values))
            positive_fraction = cat(1,positive_fraction, sum(values > threshold)/length(values));
        end
    end