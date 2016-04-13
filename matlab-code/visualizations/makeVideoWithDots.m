function makeVideoWithDots(frames_dir,framePositions, output_filename,frame_rate)
% MAKEVIDEOWITHDOTS make a video with dots representing the gaze positions
%
% input:
%   - frames_dir: path to the directory that contains the single frames as
%   .png images
%   - framePositions: the gaze positions in pixel coordinates
%   - output_filename: name of the output video file
%   - frame_rate: frame rate of the output video
    v = VideoWriter(output_filename);
    v.FrameRate = frame_rate;
    files = dir([frames_dir,'*.png']);
        
    figure('Visible','off');
    imhandle = imshow(im2double(imread(([frames_dir,files(1).name]))));
    
    i = 1;
    open(v);
    num_files = length(files);
    h = waitbar(0,'writing video with dots...');
    for file = files'
        frame = im2double(imread(([frames_dir,file.name])));
        imhandle.CData = frame;
        hold on;
        plot(framePositions(i,1),framePositions(i,2),'Marker','.','Color',[1, framePositions(i,3)*1, 0], 'MarkerSize',20);
        frame = getframe;
        writeVideo(v, frame.cdata);
        waitbar(i/num_files);
        i = i + 1;
    end

    close(v);
    close(h);