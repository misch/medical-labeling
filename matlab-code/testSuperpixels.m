% first: drag the corresponding image to the workspace
% [filename, impath] = uigetfile('../data/*.png');
% image = im2double(imread([impath,filename]));

lab_image = image;

if (size(image,3) == 3)
    lab_image = rgb2lab(image);
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 16.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 0.05);

grad = imgradient(super_img);

imshow(image + repmat(grad,1,1,size(image,3)));

% used regularizer values:
% Dataset2: 300, big size: 11.5; small size = 16.5
% Dataset5: 40
% Dataset7: 0.05, big size: 11.5, small size= 16.5
% Dataset8: 0.03, big size: 11.5, small size: 19.5