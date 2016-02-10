% image_file = [frames_dir, file_names(idx).name];
image_file = '../data/Dataset2/input-frames/frame_00206.png';
image = im2double(imread(image_file));

lab_image = image;

if (size(image,3) == 3)
lab_image = rgb2lab(image);
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 16.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 300);

% Choose a point on the image
imshow(image);
[x,y] = ginput(1);

positiveSuperpixel_idx = super_img(round(y),round(x));
features = getSuperpixelFeaturesBeta(image, super_img,3);
ref_feat = features.features(features.superpixel_idx == positiveSuperpixel_idx,:);

distances = zeros(size(image,1),size(image,2));

for ii = 1:size(distances,1)
    for jj = 1:size(distances,2)
        current_s_idx = features.superpixel_idx == super_img(round(ii),round(jj));
        distances(ii,jj) = sqrt(sum((ref_feat - features.features(current_s_idx,:)).^2));
    end
end

imshow(distances, [min(distances(:)), max(distances(:))]);
hold on; plot(x,y,'r*');

