dataset = 4;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];
frames_dir = [dataset_folder,'input-frames/'];

v = VideoWriter([dataset_folder,'video_uncompressed.avi']);


files = dir([frames_dir,'*.png']);
open(v)
for file = files'
    frame = im2double(imread(([frames_dir,file.name])));  
    writeVideo(v, frame);
end

close(v)
