function [ROI] = process_ROI(unprocessed_ROI)
% PROCESS_ROI This function does the pre-processing of 128x128 RGB or gray-scale patches considered ROIs.
% If the input has dimensions MxNx3, it is interpreted as RGB image and
% will first be converted to gray-scale. Otherwise, the input is considered
% as one or many gray-scale images.
%
% Preprocessing contains
%   - convert RGB image to gray-scale
%   - resize the patch to 32x32 pixels
%   - shift the intensity values to a zero mean
%
% uncompressed_ROI: a MxNxQ matrix, where M and N are the width and height, and Q is the number of gray-scale images. 
% If Q = 3, then the input is considered an RGB image and will first be converted to gray-scale. 


    if size(unprocessed_ROI,3) == 3
        unprocessed_ROI = rgb2gray(unprocessed_ROI);
    end
    
    ROI = imresize(unprocessed_ROI, [32 32]); % bicubic interpolation instead of bilinear that was used in the paper    
    
    for i = 1:size(ROI,3)
       ROI(:,:,i) = medfilt2(ROI(:,:,i), [5 5]); 
    end
    
    mean_per_image = mean(mean(ROI,1),2); % Qx1-vector containing the means of every image.
    
    ROI = ROI - repmat(mean_per_image,size(ROI,1),size(ROI,2));