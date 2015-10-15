function [patches, ground_truth] = extractPatchesAndLabels(image,ground_truth_image)
% This functions returns all 128-128 patches of the image.
%
% Parameter:
%   - image: a MxNxQ matrix containing Q different gray-scale images of size
%   MxN
%   - patchSize: a 2x1 vector containing x- and y- size of the rectangular
%   patches

height = size(image,1);
width = size(image,2);

boundary_top_left = 65;
boundary_bot_right = 63;

c = 1 - boundary_bot_right - boundary_top_left;
num_patches = (width + c ) * (height + c);

patches = zeros(32, 32, num_patches);
ground_truth = zeros(num_patches,1);

i = 1;
for y = boundary_top_left:width-boundary_bot_right
    for x = boundary_top_left:height-boundary_bot_right
        test_data = getPatchAtPosition(image, [x,y]);
        patches(:,:,i) = process_ROI(test_data);
        ground_truth(i) = ground_truth_image(x,y);
        i = i + 1;
    end
end




% fclose(fileID);


% massive_test = repmat(test,1,1,100000);