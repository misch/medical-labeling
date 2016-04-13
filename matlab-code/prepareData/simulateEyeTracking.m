function [mousePositions] =  simulateEyeTracking(video_filename)
% SIMULATEEYETRACKING Collect mouse positions (simulating eye-tracking data)
% Follow the thing you wanna track and click to update the recorded mouse
% position.
%
% input:
%   - video_filename: the filename of the video for which eye-tracking data
%   should be simulated
% output:
%   -mousePositions: #frames x 2 matrix containing [X,Y] positions for each
% frame of the video.

matlab_version = version('-release')
if str2num(matlab_version(1:4)) <= 2010
    % install VideoUtils Toolbox
    run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';
    vp = VideoPlayer(video_filename);

    % Play video and collect the mouse positions.
    num_frames = vp.NumFrames;
    mousePositions = zeros(num_frames,2);
    for i = 1:num_frames
       plot( vp );
       newPos = mouseMove();
       mousePositions(i,:) = newPos;

       drawnow;  
       if ( ~vp.nextFrame )
           break;
       end   
    end

    % Release the VideoPlayer Object
    clear vp;
else
    video = VideoReader(video_filename);
    
    num_frames = video.NumberOfFrames;
    mousePositions = zeros(num_frames,2);
    video = VideoReader(video_filename);
    for i = 1:num_frames
        frame = readFrame(video);
        imshow(frame);
        newPos = mouseMove();
        mousePositions(i,:) = newPos;
        
        drawnow;
    end
end