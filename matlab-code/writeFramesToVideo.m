function writeFramesToVideo(frames_dir, output_filename, frame_rate)
    % Write a sequence of input frames to a video.

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