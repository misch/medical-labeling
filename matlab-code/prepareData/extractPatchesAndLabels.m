function [patches, ground_truth] = extractPatchesAndLabels(image,ground_truth_image)
% EXTRACTPATCHESANDLABELS return all 128-128 patches of the input image with the correct labels according to a ground truth.
%
% Parameter:
%   - image: a MxN matrix containing a gray-scale image of size MxN
%   - ground_truth_image: a MxN binary image (ground truth)

height = size(image,1);
width = size(image,2);

boundary_top_left = 65;
boundary_bot_right = 63;

c = 1 - boundary_bot_right - boundary_top_left;
num_patches = (width + c ) * (height + c);

patches = zeros(32, 32, num_patches);
ground_truth = zeros(num_patches,1);

i = 1;
h2 = waitbar(0,'Extract patches...');
for y = boundary_top_left:width-boundary_bot_right
    for x = boundary_top_left:height-boundary_bot_right
        test_data = getPatchAtPosition(image, [x,y]);
        patches(:,:,i) = process_ROI(test_data);
        if (ground_truth_image ~= 0)
            ground_truth(i) = ground_truth_image(x,y);
        end
        i = i + 1;
        waitbar(i/(length(boundary_top_left:width-boundary_bot_right) * length(boundary_top_left:height-boundary_bot_right)));
    end
end
close(h2);