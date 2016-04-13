%% From a frame, display the positive and some negative patches

[dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(2);

frame_no = 200;
image = im2double(imread([frames_dir,file_names(frame_no).name]));

filename = [dataset_folder, 'gaze-measurements/video1.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

figure;
imshow(image);
hold on;
plot(framePositions(frame_no,1),framePositions(frame_no,2),'Marker','.','Color', [1, 0, 0], 'MarkerSize',30);

positive = getPatchAtPosition(image, flip(framePositions(frame_no,1:2)));


[negative] = getNonOverlappingPatches(image, flip(framePositions(frame_no,1:2)), 3);

imtool(positive);

figure;
idx = [21 52 53 25 26 37 60 44 61];
for n = 1:9
   subplot(3,3,n);
   imshow(negative(:,:,:,idx(n)));
end