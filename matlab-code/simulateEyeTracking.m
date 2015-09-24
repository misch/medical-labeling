function [mousePositions] =  simulateEyeTracking(video_filename)
% Collect mouse positions (simulating eye-tracking data)
% Follow the thing you wanna track and click to update the recorded mouse
% position.
%
% mousePositions: #frames x 2 matrix containing [X,Y] positions for each
% frame of the video.

%% install VideoUtils Toolbox
run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';
vp = VideoPlayer(video_filename);

%% Play video and collect the mouse positions.
mousePositions = [];
while ( true )
   plot( vp );
   newPos = mouseMove();
   mousePositions = [mousePositions; newPos];

   drawnow;  
   if ( ~vp.nextFrame )
       break;
   end   
end

%% Releasing the VideoPlayer Object
% After we have used the *VideoPlayer* object it is necessary to release it
% using this command:
clear vp;