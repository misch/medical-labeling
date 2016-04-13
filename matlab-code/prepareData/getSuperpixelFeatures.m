function [features] = getSuperpixelFeatures(image, super)
% GETSUPERPIXELFEATURES get descriptors for the superpixels of an image
% 
% input:
%   - image: a gray-scale or RGB image
%   - super: the pre-segmented superpixels as returned by the SLIC
%   algorithm
%
% *************************************************
% for other (more or less experimental) features, see also
% getSuperpixelFeaturesBeta.m
% *************************************************
histogram_bins = 10;
n_superpixels = max(super(:))+1; % indexing starts at 0

if (size(image,3) == 3)
    image = rgb2gray(image);
end

featureMat = zeros(n_superpixels,76);
superpixel_idx = zeros(n_superpixels,1);



for i = 0:n_superpixels-1
    mask = super == i;
    glcm = reshape(graycomatrix(image.*mask),1,[]);
    values = image(mask);
    
    if (~isempty(values))
        featureMat(i+1,:) = [histcounts(values,histogram_bins), mean(values), var(values), glcm(:)'];
        superpixel_idx(i+1) = i;
    else
        superpixel_idx(i+1) = NaN;
    end
end

featureMat =  featureMat(~isnan(superpixel_idx),:);
superpixel_idx = superpixel_idx(~isnan(superpixel_idx));


features = struct('features',featureMat,'superpixel_idx',superpixel_idx,'superpixels',super);