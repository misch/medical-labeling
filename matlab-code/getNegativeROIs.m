function [ROI] = getNegativeROIs(image, position)
% This function returns 128x128x3 image patches representing a negative Regions of Interest.
% Parameters:
%   - image: an rgb image
%   - position: the position of the positive ROI in the frame (to avoid
%   overlaps with negative ones)
x_positions = (65:64:size(image,1));
y_positions = (65:64:size(image,2));

possible_centers = combvec(x_positions, y_positions);
possible_centers = possible_centers(:,or(abs(possible_centers(1,:) - position(1)) >= 128,abs(possible_centers(2,:) - position(2)) >= 128));

ROI = zeros(128,128,3,length(possible_centers));

for i = 1:length(possible_centers)
    ROI(:,:,:,i) = getPatchAtPosition(image,possible_centers(:,i));   
end