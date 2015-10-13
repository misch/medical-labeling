function [ROI] = getNegativeROIs(image, position)
% This function returns a 128x128x3 image patch representing a negative Region of Interest.

x_positions = [130, size(image,2)-85];
y_positions = [130, size(image,1)-85];


ROI = zeros(128,128,3,length(x_positions));

for i = 1:length(x_positions)
    x_pos = x_positions(i) + round(rand()*30) - 15;
    y_pos = y_positions(i) + round(rand()*30) - 15;
    
    ROI(:,:,:,i) = getPatchAtPosition(image,[x_pos,y_pos]);   
end

