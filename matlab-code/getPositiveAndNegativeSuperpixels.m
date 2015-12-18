function [positives, negatives] = getPositiveAndNegativeSuperpixels(descriptors_dir, framePositions)
% From descriptors and gaze positions, extract positive and negative descriptors.

file_names = dir([descriptors_dir,'*.mat']);
key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

    feature_dim = 42 % without co-occurrence
%     feature_dim = 106 % with co-occurrence
    
    positives = zeros(length(interesting_frames),feature_dim);
    negatives = zeros(0,feature_dim);
    
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
    
    negatives = negatives(find(~sum(isnan(negatives),2)),:);
    positives = negatives(find(~sum(isnan(positives),2)),:);