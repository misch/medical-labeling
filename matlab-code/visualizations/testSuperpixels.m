% first: drag the corresponding image to the workspace
% [filename, impath] = uigetfile('../../data/*.png');
% image = im2double(imread([impath,filename]));
image = im2double(imread('../../data/Dataset2/input-frames/frame_00207.png'));

lab_image = image;

if (size(image,3) == 3)
    lab_image = rgb2lab(image);
    
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 16.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 300);

grad = imgradient(super_img)>0;
%%
boundary_color = [0 0.2 0.7];

show_grad = zeros(size(grad,1),size(grad,2),size(image,3));
show_grad(:,:,1) = boundary_color(1) * grad;
show_grad(:,:,2) = boundary_color(2) * grad;
show_grad(:,:,3) = boundary_color(3) * grad;

image_segmented = image.*repmat(~grad,1,1,size(image,3));

figure;
imshow(image_segmented + show_grad,'Border','tight');

% used regularizer values:
% Dataset2: 300, big size: 11.5; small size = 16.5
% Dataset5: 40
% Dataset7: 0.05, big size: 11.5, small size= 16.5
% Dataset8: 0.03, big size: 11.5, small size: 19.5

%%
% lab_img = rgb2lab(image); 
% lum = lab_img(:,:,1);
% filtered_lum = medfilt2(lum,[20 20]);
% imtool([lum, filtered_lum], [min(lum(:)), max(lum(:))]); 
% 
% filtered_lum_img = lab_img;
% filtered_lum_img(:,:,1) = filtered_lum;
% imtool([image, lab2rgb(filtered_lum_img)]);









