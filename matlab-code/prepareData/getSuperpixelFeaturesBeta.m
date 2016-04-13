function [features] = getSuperpixelFeaturesBeta(image, super,betaFeature)
% GETSUPERPIXELFEATURESBETA get descriptors for the superpixels of an image
% 
% input:
%   - image: a gray-scale or RGB image
%   - super: the pre-segmented superpixels as returned by the SLIC
%   algorithm
%   - betaFeature: an int to indicate which feature version should be
%   chosen.
%       1: simple relative color features (useful for color videos)
%       2: HOG features
%       3: autoencoded features (need to have a trained autoencoder object
%       first (see matlab help on how to train an autoencoder))
%

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
elseif betaFeature == 2 % hogFeatures
    n_superpixels = max(super(:))+1;

    featureMat = zeros(n_superpixels,227484);
    superpixel_idx = zeros(n_superpixels,1);
    
    for i = 0:n_superpixels-1
        mask = super == i;
        values = image(repmat(mask,1,1,size(image,3)));
        masked_img = image.*repmat(mask,1,1,size(image,3));

        if (~isempty(values))
            featureMat(i+1,:) = [extractHOGFeatures(masked_img)];
            superpixel_idx(i+1) = i;
        else
            superpixel_idx(i+1) = NaN;
        end
    end
elseif betaFeature == 3 % auto-encoded feature
    load('encoder3Dataset2');

    patch_size = 80; % todo: can that be inferred from autoencoder or so?
    d = patch_size/2;
    
    super_img = repmat(super,1,1,size(image,3));
    
    unique_superpixels = unique(super_img);
    n_superpixels = length(unique_superpixels);
    superpixel_idx = zeros(n_superpixels,1);
    
    super_img = padarray(super_img, [d d],-Inf);
    image = padarray(image, [d d]);
    
    padded_superpixels = cell(1,n_superpixels);
    cell_idx = 1;
    for ii = unique_superpixels'
        [X, Y] = find(super_img(:,:,1) == ii);
        c = round(median([X,Y]));
        patch = image(c(1)-d:c(1)+d, c(2)-d:c(2)+d,:);
        padded_superpixels{cell_idx} = patch;
        superpixel_idx(cell_idx) = ii;
        cell_idx = cell_idx + 1;
    end
    
    featureMat = encode(autoenc,padded_superpixels)';
end

    featureMat =  featureMat(~isnan(superpixel_idx),:);
    superpixel_idx = superpixel_idx(~isnan(superpixel_idx));


    features = struct('features',featureMat,'superpixel_idx',superpixel_idx,'superpixels',super);