function [ROI] = getPositiveROI(image, position)

x_pos = position(1);
y_pos = position(2);


ROI = image(x_pos-64:x_pos+63,y_pos-64:y_pos+63,:);

imtool(image);
imtool(ROI);