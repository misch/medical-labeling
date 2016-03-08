%% Show images with recorded mouse positions

    showImagesAndEyeTrackingData(video_filename, framePositions);


%% Create video with recorded mouse positions
dataset = 2;
[dataset_folder, frames_dir, ~, frame_height, frame_width] = getDatasetDetails(dataset);

filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

    makeVideoWithDots(frames_dir, framePositions, [dataset_folder, 'with_dots6.avi'],20);

%% Show ROIs - in case of quadratic patches...
if (show_ROIs)
    figure(1);
    for i = 1:55
        subplot(8,8,i);
        if size(positive_ROIs,4) == 1
            imshow(positive_ROIs(:,:,i));
        else
            imshow(positive_ROIs(:,:,:,i));
        end
    end

    figure(2);
    for i = 1:64
        subplot(8,8,i);
        if size(negative_ROIs,4) == 1
            imshow(negative_ROIs(:,:,i));
        else
            imshow(negative_ROIs(:,:,:,i));
        end
    end
end

%% Show patches
addpath('../subtightplot/');
subplottight = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.01 0.01], [0.01 0.01]);
figure;
for ii = 1:72
   subplottight(8,9,ii);
   imshow(neg_frame207(:,:,:,ii));
end

%% Show image with gaze dot on it
frame_no = 207;
figure; imshow(im2double(imread(['../../data/Dataset2/input-frames/',sprintf('frame_%05d.png',frame_no)])),'Border','tight');
hold on; plot(framePositions(frame_no,1),framePositions(frame_no,2),'Marker','.','Color',[1, 0, 0], 'MarkerSize',30);

%%
load('../../data/Dataset2/simple-color-descriptors/frame_00207');
super = frameDescriptor.superpixels;
image = im2double(imread('../../data/Dataset2/input-frames/frame_00207.png'));

labels_f = training_set.labels(training_set.frame_numbers == 207);
super_idx_f = training_set.superpixel_idx(training_set.frame_numbers == 207);

patch_size = 80;
d = patch_size/2;

super_img = repmat(super,1,1,size(image,3));

unique_superpixels = unique(super_img);
n_superpixels = length(unique_superpixels);
superpixel_idx = zeros(n_superpixels,1);

super_img = padarray(super_img, [d d],-Inf);
image = padarray(image, [d d]);

padded_superpixels = cell(1,n_superpixels);
cell_idx = 1;
for ii = super_idx_f(labels_f == -1)'
    masked = image .* (super_img == ii);
    masked(super_img ~= ii) = 1;
    [X, Y] = find(super_img(:,:,1) == ii);
    c = round(median([X,Y]));
    patch = masked(c(1)-d:c(1)+d, c(2)-d:c(2)+d,:);
    negative_superpixels{cell_idx} = patch;
    superpixel_idx(cell_idx) = ii;
    cell_idx = cell_idx + 1;
end

% negative_superpixels{1} = negative_superpixels{2};
% negative_superpixels{355} = negative_superpixels{338};
% negative_superpixels{355} = negative_superpixels{314};
% negative_superpixels{352} = negative_superpixels{315};
% negative_superpixels{221} = negative_superpixels{222};

%%
addpath('subtightplot/');
subplottight = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
figure;
plot_idx = 1;
for ii = [1:5:355,355]
   subplottight(8,9,plot_idx);
   imshow(negative_superpixels{ii});
   plot_idx = plot_idx + 1;
end