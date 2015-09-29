function videoToFrames(video_filename, frames_dir)
% This script writes the single frames of a video to .png files.
% You have to set the variables 'video_filename' and 'frames_dir'
% correctly.

%% install VideoUtils Toolbox
run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';

%% load video
vp = VideoPlayer(video_filename);
% Todo: for a MATLAB newer than R2010a, use VideoReader!
% vidObj = VideoReader(video_filename);

%% Store frames as images

num_frames = vp.NumFrames;
start_frame = 1;
h = waitbar(0,'Initializing waitbar...');
for i = 1:num_frames
    frameNr = sprintf('%05d',i+start_frame-1)
    filename = [frames_dir,'frame_',frameNr,'.png'];
    frame = vp.Frame;
    imwrite(frame,filename);
    vp.nextFrame;
    waitbar(i/num_frames,h,sprintf('%d / %d...',i, num_frames));
end
close(h);

%% Releasing the VideoPlayer Object
% After we have used the *VideoPlayer* object it is necessary to release it
% using this command:
clear vp;