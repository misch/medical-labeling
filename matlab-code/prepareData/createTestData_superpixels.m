function [] = createTestData_superpixels(frames_dir,superpixel_dir,frame_percentage, regularizer, superpixel_scale)
% CREATETESTDATA_SUPERPIXELS create superpixel descriptors. The correct labels are not assigned here, but instead the performance will be measured pixelwise (instead of per superpixel) directly after the classifier was applied.
% The function stores the gathered descriptors for each frame in a single file.
%
% input:
%   - frames_dir: path to the directory that contains the input-frames 
%   - superpixel_dir: path to the directory where the descriptors for each
%   frame will be stored
%   - frame_percentage: int between 0-100, giving the approximate amount of frames for which the
%   descriptors should be collected (if specific frames should be
%   generated, the variable frame_indices inside the function should be
%   manipulated. Usually, frame_percentage = 100
%   - regularizer: the regularizer value that should be used for the SLIC
%   algorithm
%   - superpixel_scale: in how many parts the smaller image dimension
%   should roughly be devided. The superpixel_size for SLIC is then calculated
%   as min(width,height)/superpixel_scale
    
    file_names = dir([frames_dir, '*.png']);
    num_frames = length(file_names);

    frame_indices = find(rand(1,num_frames) <= frame_percentage/100);

    for idx = frame_indices 
        image_file = [frames_dir, file_names(idx).name];
        image = im2double(imread(image_file));
        
        lab_image = image;
        
        if (size(image,3) == 3)
            lab_image = rgb2lab(image);
        end
        
        superpixel_size = round(min([size(image,1), size(image,2)]) / superpixel_scale);
        super_img = getSuperPixels(single(lab_image), superpixel_size, regularizer);
        
        frameDescriptor = getSuperpixelFeatures(image, super_img);
        frameDescriptor.frame_no = idx;
        
        save([superpixel_dir,'frame_',sprintf('%05d', idx),'.mat'], 'frameDescriptor','-v7.3')
    end
    disp(['Saved descriptors to ',superpixel_dir]);