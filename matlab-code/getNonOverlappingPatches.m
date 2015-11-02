function [patches, nPatches] = getNonOverlappingPatches(image, position)
    x_positions = (65:64:size(image,1));
    y_positions = (65:64:size(image,2));

    possible_centers = combvec(x_positions, y_positions);
    possible_centers = possible_centers(:,or(abs(possible_centers(1,:) - position(1)) >= 128,abs(possible_centers(2,:) - position(2)) >= 128));

    ROI = zeros(128,128,3,length(possible_centers));

    for i = 1:length(possible_centers)
        ROI(:,:,:,i) = getPatchAtPosition(image,possible_centers(:,i));   
    end
    
    patches = ROI;
    nPatches = size(patches,4);