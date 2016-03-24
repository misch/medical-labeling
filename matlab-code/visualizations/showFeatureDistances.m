% image_file = [frames_dir, file_names(idx).name];
image_file = '../../data/Dataset7/input-frames/frame_00048.png';
image = im2double(imread(image_file));

lab_image = image;

if (size(image,3) == 3)
lab_image = rgb2lab(image);
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 16.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 0.05);

% Choose a point on the image
imshow(image);
[x,y] = ginput(1);

positiveSuperpixel_idx = super_img(round(y),round(x));
features = getSuperpixelFeaturesBeta(image, super_img,2);
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

% figure; imshow(distances, [min(distances(:)), max(distances(:))]);
% hold on; plot(x,y,'r*');
figure; imshow(cos_distances, [min(cos_distances(:)), max(cos_distances(:))]);
hold on; plot(x,y,'r*');

