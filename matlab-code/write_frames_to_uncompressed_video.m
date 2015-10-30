% Write a sequence of input frames to a single uncompressed video
dataset = 6;
[dataset_folder, frames_dir, file_names] = getDatasetDetails(dataset)

v = VideoWriter([dataset_folder,'video_uncompressed.avi']);

open(v)
for file = file_names'
    frame = im2double(imread(([frames_dir,file.name])));  
    writeVideo(v, frame);
end

close(v)
