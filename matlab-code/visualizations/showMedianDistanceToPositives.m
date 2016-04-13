% Visualize median/mean distance between the superpixels in one frame and
% all the "positives" (observed positives) of the dataset. In the best
% case, the distances are small (dark) for the positive parts of
% the image, and large (bright) for the negative parts.
%
% How to:
%   1) load a training set into the workspace
%   2) load the frameDescriptor for the frame where you want to see the
%   results

positive_idx = training_set.labels == 1;

positives = training_set.data(positive_idx,:);


%% for each superpixel, get the median distance to the positive set

heat_map = zeros(size(frameDescriptor.superpixels));


for ii = 1:length(frameDescriptor.superpixel_idx)
   idx = frameDescriptor.superpixel_idx(ii);
   feature_vec = frameDescriptor.features(frameDescriptor.superpixel_idx == idx,:);
   
   % distances to all positives
   distance = sqrt(sum((repmat(feature_vec,size(positives,1),1) - positives).^2,2));
   
   % aggregate to one value per superpixel of the current frame
   aggregated_distance = median(distance); % free to take min/max/mean/...
   
   heat_map(frameDescriptor.superpixels == idx) = aggregated_distance;
end
heat_map = (heat_map - min(heat_map(:))) / (max(heat_map(:)) - min(heat_map(:)));

imtool([heat_map]);