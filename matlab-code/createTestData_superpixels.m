function [featureMat, super_img] = createTestData_superpixels(frames_dir,frame_percentage)
% test_data contains superpixel-features
% super_img is needed to back-project predicted labels to the pixels later!
    
    file_names = dir([frames_dir, '*.png']);
    
    num_frames = length(file_names);

%     frame_indices = find(rand(1,num_frames) <= frame_percentage/100);
    frame_indices = [189];

    for idx = frame_indices 
        image_file = [frames_dir, file_names(idx).name];
        image = im2double(imread(image_file));
        
        lab_image = image;
        
        if (size(image,3) == 3)
            lab_image = rgb2lab(image);
        end
        
        superpixel_size = round(min([size(image,1), size(image,2)]) / 11.5);
        super_img = getSuperPixels(single(lab_image), superpixel_size, 0.05);
        
        featureMat = getSuperpixelFeatures(image, super_img);
    end