% train an autoencoder for later usage as feature descriptor
frames_dir = '../../data/Dataset2/input-frames/';

% get/create some superpixels
file_names = dir([frames_dir, '*.png']);


num_frames = length(file_names);

frame_percentage = 5;
frame_indices = find(rand(1,num_frames) <= frame_percentage/100);
superpixel_scale = 16.5;
regularizer = 300;

patch_size = 80; % has to be an even number!

if mod(patch_size,2) ~= 0
   error('patch_size has to be even');
end

d = patch_size/2;

padded_superpixels = {};
total_idx = 1;
for idx = frame_indices 
    image_file = [frames_dir, file_names(idx).name];
	image = im2double(imread(image_file));
        
    lab_image = image;
        
    if (size(image,3) == 3)
        lab_image = rgb2lab(image);
    end

    superpixel_size = round(min([size(image,1), size(image,2)]) / superpixel_scale);
    super_img = repmat(getSuperPixels(single(lab_image), superpixel_size, regularizer),1,1,size(image,3));

    unique_superpixels = unique(super_img);
    n_superpixels = length(unique_superpixels);
    
    super_img = padarray(super_img, [d d],-Inf);
    image = padarray(image, [d d]);
    
    superpixel_indices = find(rand(1,n_superpixels) <= 8/100);
    for ii = superpixel_indices
        current_superpixel = unique_superpixels(ii);

        [X, Y] = find(super_img(:,:,1) == current_superpixel);
        c = round(median([X,Y]));
        patch = image(c(1)-d:c(1)+d, c(2)-d:c(2)+d,:);
        padded_superpixels{total_idx} = imresize(patch,0.5);
        total_idx = total_idx + 1;
    end
end

disp(sprintf('Collected %d superpixels',total_idx-1));

%%
hiddenSize = 500;
autoenc = trainAutoencoder(padded_superpixels,hiddenSize,...
        'MaxEpochs',10000,...
        'EncoderTransferFunction','satlin',...
        'DecoderTransferFunction','purelin',...
        'L2WeightRegularization',0.01,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.1);