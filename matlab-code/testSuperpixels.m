% first: drag the corresponding image to the workspace
lab_image = image;

if (size(image,3) == 3)
    lab_image = rgb2lab(image);
end

superpixel_size = round(min([size(image,1), size(image,2)]) / 11.5);
super_img = getSuperPixels(single(lab_image), superpixel_size, 300);

grad = imgradient(super_img);

imtool(image - repmat(grad,1,1,3));