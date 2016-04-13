% Can be useful to see how good the features are. 
% Click on a point in the image - the feature distance ("similarity") 
% of the corresponding superpixel to all the other superpixels in the frame is shown.
image_file = '../../data/Dataset2/input-frames/frame_00048.png';
image = im2double(imread(image_file));

lab_image = image;

if (size(image,3) == 3)
lab_image = rgb2lab(image);
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 16.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 0.05);

imshow(image);
[x,y] = ginput(1);

positiveSuperpixel_idx = super_img(round(y),round(x));
% *******************************************************
% ******** Choose here what features are used! **********
features = getSuperpixelFeaturesBeta(image, super_img,1);
% *******************************************************
ref_feat = features.features(features.superpixel_idx == positiveSuperpixel_idx,:);

distances = zeros(size(image,1),size(image,2));
cos_distances = zeros(size(image,1),size(image,2));

for ii = 1:size(distances,1)
    for jj = 1:size(distances,2)
        current_s_idx = features.superpixel_idx == super_img(round(ii),round(jj));
        current_f = features.features(current_s_idx,:);
        distances(ii,jj) = sqrt(sum((ref_feat - current_f ).^2));
        cos_distances(ii,jj) = 1 - (ref_feat*current_f')/sqrt((ref_feat*ref_feat')*(current_f *current_f'));
    end
end

figure(1); imshow(distances, [min(distances(:)), max(distances(:))]); title('euclidean distances');
hold on; plot(x,y,'r*');
figure(2); imshow(cos_distances, [min(cos_distances(:)), max(cos_distances(:))]); title('cosine distances');
hold on; plot(x,y,'r*');

