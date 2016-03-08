% From a frame, get the positive and some negative patches, display them.
[dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(2);

i = 900;
image = im2double(imread([frames_dir,file_names(i).name]));

filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

figure;
imshow(image);
hold on;
plot(framePositions(i,1),framePositions(i,2),'Marker','.','Color', [1, 0, 0], 'MarkerSize',30);

positive = getPatchAtPosition(image, flip(framePositions(i,1:2)));


[negative] = getNonOverlappingPatches(image, flip(framePositions(i,1:2)), 3);

figure;
imtool(positive);

figure;
idx = [21 52 53 25 26 37 60 44 61];
for n = 1:9
   subplot(3,3,n);
   imshow(negative(:,:,:,idx(n)));
end