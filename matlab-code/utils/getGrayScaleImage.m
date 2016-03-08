function [image] = getGrayScaleImage(filename)
% Returns the specified image as a gray-scale image.
% If it is already gray-scale, it just returns the image itself.

image = im2double(imread(filename));

if ndims(image) == 3
    image = rgb2gray(image);
end