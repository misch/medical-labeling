function [positives, negatives] = getPositiveAndNegativeSuperpixels(descriptors_dir, framePositions)
% From descriptors and gaze positions, extract positive and negative descriptors.

file_names = dir([descriptors_dir,'*.mat']);
key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

    
%     positives = zeros(length(interesting_frames),42); % without co-occurence
    positives = zeros(length(interesting_frames),105); % with co-occurence
%     negatives = zeros(0,42); % without co-occurence
negatives = zeros(0,105); % with co-occurence
    
    for i = 1:length(interesting_frames)
        idx = interesting_frames_indices(i);
        descriptor_file = [descriptors_dir, interesting_frames(i).name]; 
        
        load(descriptor_file);
        
        % idx of found superpixel + 1 (superpixel-idx starts at 0)
        positiveSuperPixel_idx = 1+frameDescriptor.superpixels(round(framePositions(idx,2)),round(framePositions(idx,1)));
        
        featureMat = frameDescriptor.features;
        
        positives(i,:) = featureMat(positiveSuperPixel_idx,:);
        featureMat(positiveSuperPixel_idx,:) = [];
        negatives = cat(1,negatives,featureMat);
    end