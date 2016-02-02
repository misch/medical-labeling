function [features] = getSuperpixelFeatures(image, super)
% This function returns a 42xN-matrix, N being the number of superpixels
% in the image.
% 
% At the moment, an amount of 40 bins for the intensity historgram is
% fixed.


histogram_bins = 20;
n_superpixels = max(super(:))+1; % indexing starts at 0

% if (size(image,3) == 3)
%     image = rgb2gray(image);
% end

featureMat = zeros(n_superpixels,3);
superpixel_idx = zeros(n_superpixels,1);



for i = 0:n_superpixels-1
    mask = super == i;
    values = image(repmat(mask,1,1,3));
%     glcm = reshape(graycomatrix(image.*mask),1,[]);
    
    image_r = image(:,:,1);
    image_g = image(:,:,2);
    image_b = image(:,:,3);
    
    
    avg_r = median(image_r(mask));
    avg_g = median(image_g(mask));
    avg_b = median(image_b(mask));
    
    if (~isempty(values))
        featureMat(i+1,:) = [avg_r/(avg_g+avg_r), avg_r/(avg_b+avg_r), avg_g/(avg_b + avg_g)];%, glcm(:)'];
        superpixel_idx(i+1) = i;
    else
        superpixel_idx(i+1) = NaN;
    end
end

featureMat =  featureMat(~isnan(superpixel_idx),:);
superpixel_idx = superpixel_idx(~isnan(superpixel_idx));


features = struct('features',featureMat,'superpixel_idx',superpixel_idx,'superpixels',super);