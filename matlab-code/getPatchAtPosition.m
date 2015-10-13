function [ROI] = getPatchAtPosition(image, position)
% This function returns a 128x128x3 image patch around the given position.

y_pos = round(position(1));
x_pos = round(position(2));

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