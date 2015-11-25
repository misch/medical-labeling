function [featureVec] = getSuperpixelFeatures(image, mask)
% At the moment, fixed amount of 40 bins for the intensity historgram.

% imtool(image)
% [X,Y] = ind2sub(size(mask),find(mask));

if (size(image,3) == 3)
    image = rgb2gray(image);
end

values = image(find(mask));

intensity_hist = histcounts(values,40);
intensity_mean = mean(values);
intensity_var = var(values);

featureVec = [intensity_hist, intensity_mean, intensity_var];


