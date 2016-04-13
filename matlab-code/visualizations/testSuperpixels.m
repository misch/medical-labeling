%% Try here the different parameters for the SLIC algorithm!

image = im2double(imread('../../data/Dataset8/input-frames/frame_00189.png'));

lab_image = image;

if (size(image,3) == 3)
    lab_image = rgb2lab(image);
    
end

% *****************************************************************
% Set here different parameters!
% *****************************************************************
superpixel_size = round(min([size(image,1), size(image,2)]) / 19.5);
regularizer = 0.02;
% *****************************************************************

super_img = getSuperPixels(single(lab_image), superpixel_size, regularizer);
grad = imgradient(super_img)>0;

boundary_color = [1 1 1]; % in gray-scale images, only the first number will be used

show_grad = zeros(size(grad,1),size(grad,2),size(image,3));
for component = 1:size(image,3)
    show_grad(:,:,component) = boundary_color(component) * grad;
end

image_segmented = image.*repmat(~grad,1,1,size(image,3));

figure;
imshow(image_segmented + show_grad,'Border','tight');
