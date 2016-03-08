
% Visualize median/mean distance to all the "positives" (observed positives)

% first:
%   - load training set
%   - load a frameDescriptor
%   - load corresponding frame-descriptor 
positive_idx = training_set.labels == 1;

positives = training_set.data(positive_idx,:);

% med_positives = median(positives);
% min_positives = min(positives);
% max_positives = max(positives);
% mean_positives = mean(positives);
% show_frame_number = 2;

% if frameDescriptor.frame_no ~= show_frame_number
%     disp('Wrong frameDescriptor loaded!');
%     return;
% end

%%
% for each superpixel, get the median distance to the positive set
heat_map_img_med = zeros(size(frameDescriptor.superpixels));
heat_map_img_min = zeros(size(frameDescriptor.superpixels));
heat_map_img_max = zeros(size(frameDescriptor.superpixels));
heat_map_img_mean = zeros(size(frameDescriptor.superpixels));

for ii = 1:length(frameDescriptor.superpixel_idx)
   idx = frameDescriptor.superpixel_idx(ii);
   feature_vec = frameDescriptor.features(frameDescriptor.superpixel_idx == idx,:);
   
   % median distance to positives
   distance = sqrt(sum((repmat(feature_vec,size(positives,1),1) - positives).^2,2));
   med_distance = median(distance);
   min_distance = min(distance);
   max_distance = max(distance);
   mean_distance = mean(distance);

    % distance to the median of the positives
%     med_distance = sqrt(sum((feature_vec - med_positives).^2,2));
%     min_distance = sqrt(sum((feature_vec - min_positives).^2,2));
%     max_distance = sqrt(sum((feature_vec - max_positives).^2,2));
%     mean_distance = sqrt(sum((feature_vec - mean_positives).^2,2));
   
   heat_map_img_med(frameDescriptor.superpixels == idx) = med_distance;
   heat_map_img_min(frameDescriptor.superpixels == idx) = min_distance;
   heat_map_img_max(frameDescriptor.superpixels == idx) = max_distance;
   heat_map_img_mean(frameDescriptor.superpixels == idx) = mean_distance;
end
heat_map_img_med = (heat_map_img_med - min(heat_map_img_med(:))) / (max(heat_map_img_med(:)) - min(heat_map_img_med(:)));
heat_map_img_min = (heat_map_img_min - min(heat_map_img_min(:))) / (max(heat_map_img_min(:)) - min(heat_map_img_min(:)));
heat_map_img_max = (heat_map_img_max - min(heat_map_img_max(:))) / (max(heat_map_img_max(:)) - min(heat_map_img_max(:)));
heat_map_img_mean = (heat_map_img_mean - min(heat_map_img_mean(:))) / (max(heat_map_img_mean(:)) - min(heat_map_img_mean(:)));

    imtool([heat_map_img_med, heat_map_img_mean; heat_map_img_min, heat_map_img_max]);
    imtool([imgradient(heat_map_img_med), imgradient(heat_map_img_mean); imgradient(heat_map_img_min), imgradient(heat_map_img_max)]);

    %%
%     positiveSuperpixel_idx = super_img(round(y),round(x));
% features = getSuperpixelFeaturesBeta(image, super_img);
% ref_feat = features.features(features.superpixel_idx == positiveSuperpixel_idx,:);
% 
% distances = zeros(size(image,1),size(image,2));
% 
% for ii = 1:size(distances,1)
%     for jj = 1:size(distances,2)
%         current_s_idx = features.superpixel_idx == super_img(round(ii),round(jj));
%         distances(ii,jj) = sqrt(sum((ref_feat - features.features(current_s_idx,:)).^2));
%     end
% end