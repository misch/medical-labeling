function writeFramesToVideo(frames_dir, output_filename, frame_rate)
% WRITEFRAMESTOVIDEO write a sequence of input frames to a video.
%
% input:
%   - frames_dir: path to folder containing the .png images (files should
%   be named such that alphabetical order corresponds to frame order)
%   - output_filename: file name of the output video
%   - frame_rate: number indicating the frame_rate (usually frame_rate =
%   30)

    v = VideoWriter(output_filename);

    v.FrameRate = frame_rate;

    file_names = dir([frames_dir, '*.png']);
    open(v)
    for file = file_names'
        frame = im2double(imread([frames_dir,file.name]));
        frame = imresize(frame,0.8,'nearest');
        writeVideo(v, frame);
    end

    close(v)