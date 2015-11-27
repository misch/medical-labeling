function [positives, negatives] = getPositiveAndNegativeSuperpixels(frames_dir, file_names, framePositions)

key_pressed = (framePositions(:,3) > 0);
interesting_frames = file_names(key_pressed);
interesting_frames_indices = find(key_pressed);

regularizer = 0.05;

    positives = zeros(42,length(interesting_frames));
    negatives = zeros(42,0);
    
    for i = 1:length(interesting_frames)
        idx = interesting_frames_indices(i);
        image_file = [frames_dir, interesting_frames(i).name]; 
        image = im2double(imread(image_file));
        
        lab_image = image;
        
        if (size(image,3) == 3)
            lab_image = rgb2lab(image);
        end
        
        superpixel_size = round(min([size(image,1), size(image,2)]) / 11.5);
        super_img = getSuperPixels(single(lab_image), superpixel_size, regularizer);
        
        featureMat = getSuperpixelFeatures(image, super_img);
        
        positiveSuperPixel = super_img(round(framePositions(idx,2)),round(framePositions(idx,1)));
        
        positives(:,i) = featureMat(:,positiveSuperPixel);
        featureMat(:,positiveSuperPixel) = [];
        negatives = cat(2,negatives,featureMat);
    end