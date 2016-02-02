function [features] = getSuperpixelFeatures(image, super)
% This function returns a 42xN-matrix, N being the number of superpixels
% in the image.
% 
% At the moment, an amount of 40 bins for the intensity historgram is
% fixed.

betaFeature = 2;

if betaFeature == 1 % simple relative color features (Dataset 2)
    
    n_superpixels = max(super(:))+1;

    featureMat = zeros(n_superpixels,3);
    superpixel_idx = zeros(n_superpixels,1);

    for i = 0:n_superpixels-1
        mask = super == i;
        values = image(repmat(mask,1,1,size(image,3)));

        image_r = image(:,:,1);
        image_g = image(:,:,2);
        image_b = image(:,:,3);

        avg_r = median(image_r(mask));
        avg_g = median(image_g(mask));
        avg_b = median(image_b(mask));

        if (~isempty(values))
            featureMat(i+1,:) = [avg_r/(avg_g+avg_r+1e-5), avg_r/(avg_b+avg_r+1e-5), avg_g/(avg_b + avg_g+1e-5)];%, glcm(:)'];
            superpixel_idx(i+1) = i;
        else
            superpixel_idx(i+1) = NaN;
        end
    end
elseif betaFeature == 2 % median intensity
    n_superpixels = max(super(:))+1;

    featureMat = zeros(n_superpixels,227484);
    superpixel_idx = zeros(n_superpixels,1);
    
    for i = 0:n_superpixels-1
        mask = super == i;
        values = image(repmat(mask,1,1,size(image,3)));
        masked_img = image.*repmat(mask,1,1,size(image,3));

        if (~isempty(values))
            featureMat(i+1,:) = [extractHOGFeatures(masked_img)];%, glcm(:)'];
            superpixel_idx(i+1) = i;
        else
            superpixel_idx(i+1) = NaN;
        end
    end
end

    featureMat =  featureMat(~isnan(superpixel_idx),:);
    superpixel_idx = superpixel_idx(~isnan(superpixel_idx));


    features = struct('features',featureMat,'superpixel_idx',superpixel_idx,'superpixels',super);