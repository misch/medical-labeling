function [ROI] = getNegativeROIs(image, position)
% This function returns a 128x128x3 image patch representing a negative Region of Interest.

y_positions = [130, size(image,2)-85];
x_positions = [130, size(image,1)-85];



ROI = zeros(128,128,3,length(x_positions));

for i = 1:length(x_positions)
    random_shift = round(rand()*30) - 15;
    x_pos = x_positions(i) + random_shift;
    y_pos = y_positions(i) + random_shift;
    
    
    if (x_pos > 64 & size(image,1) >= x_pos+63 & y_pos > 64 & size(image,2) >= y_pos+63)
        ROI(:,:,:,i) = image(x_pos-64:x_pos+63,y_pos-64:y_pos+63,:);
    else
        disp('No negative ROI extracted!');
    end
end

