function [featureMat] = getSuperpixelFeatures(image, super)
% This function returns a 42xN-matrix, N being the number of superpixels
% in the image.
% 
% At the moment, an amount of 40 bins for the intensity historgram is
% fixed.
histogram_bins = 40;
n_superpixels = max(super(:))+1; % indexing starts at 0

if (size(image,3) == 3)
    image = rgb2gray(image);
end

featureMat = zeros(n_superpixels,105);



for i = 0:n_superpixels-1
    mask = super == i;
    glcm = reshape(graycomatrix(image.*mask),1,[]);
    values = image(mask);
    featureMat(i+1,:) = [histcounts(values,histogram_bins), mean(values), var(values), glcm(2:end)]; 
end