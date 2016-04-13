function [ROI] = getPatchAtPosition(image, position)
% GETPATCHATPOSITION return a 128x128 patch around the given position.
%
% input:
%   image - an MxNxQ matrix containing Q MxN images
%   position - a two-dimensional vector containing x and y positions
%           position(1): x-coordinate: vertical, starting from top left
%           position(2): y-coordinate: horizontal, starting from top left
%%
x_pos = round(position(1));
y_pos = round(position(2));

patch_is_inside_image = (x_pos > 64 & size(image,1) >= x_pos+63 & y_pos > 64 & size(image,2) >= y_pos+63);

if (patch_is_inside_image)
    x_min = x_pos-64;
    x_max = x_pos+63;
    y_min = y_pos-64;
    y_max = y_pos+63;
    
    ROI = image(x_min:x_max,y_min:y_max,:);
else
    ROI = zeros(128,128,size(image,3));
end