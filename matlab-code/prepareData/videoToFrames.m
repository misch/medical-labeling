function videoToFrames(video_filename, frames_dir)
% VIDEOTOFRAMES write the single frames of a video to .png files.
%
% input:
%   - video_filename: filename of the video that should be split into the
%   single frames
%   - frames_dir: path to the existing folder where the .png images should be stored

%% install VideoUtils Toolbox
run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';
% The VideoUtils Toolbox seems to have some trouble running on Ubuntu 14.04
% LTS. It seems to look for libavcodec53 which is not available in this
% Ubuntu-version...

%% load video
vp = VideoPlayer(video_filename);
% todo: for a MATLAB newer than R2010a, use VideoReader!
% vidObj = VideoReader(video_filename);

%% Store frames as images
% todo: check if frames_dir exists already; otherwise, create it
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