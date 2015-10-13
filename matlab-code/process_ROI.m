function [ROI] = process_ROI(unprocessed_ROI)
% This function does the pre-processing of 128x128 RGB or gray-scale patches considered ROIs.
% Preprocessing contains
%   - convert RGB image to gray-scale
%   - resize the patch to 32x32 pixels
%   - shift the intensity values to a zero mean
%
% uncompressed_ROI: a 128x128x3 or 128x128 ROI 

    if size(unprocessed_ROI,3) == 3
        unprocessed_ROI = rgb2gray(unprocessed_ROI); % bicubic interpolation instead of bilinear that was used in the paper    
    end
    
    ROI = imresize(unprocessed_ROI, [32 32]);
    ROI = ROI - mean(ROI(:));