function [ROI] = getPositiveROI(image, position)
% This function returns a 128x128x3 image patch around the given position.

y_pos = round(position(1));
x_pos = round(position(2));

if (x_pos > 64 & size(image,1) >= x_pos+63 & y_pos > 64 & size(image,2) >= y_pos+63)
    ROI = image(x_pos-64:x_pos+63,y_pos-64:y_pos+63,:);
else
    ROI = zeros(128,128,3);
end