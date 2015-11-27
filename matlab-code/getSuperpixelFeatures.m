function [featureMat] = getSuperpixelFeatures(image, super)
% This function returns a 42xN-matrix, N being the number of superpixels
% in the image.
% 
% At the moment, an amount of 40 bins for the intensity historgram is
% fixed.
histogram_bins = 40;
n_superpixels = max(super(:));

if (size(image,3) == 3)
    image = rgb2gray(image);
end

featureMat = zeros(42, n_superpixels);

for i = 1:n_superpixels
    values = image(super==i);
    featureMat(:,i) = [histcounts(values,histogram_bins), mean(values), var(values)]; 
end