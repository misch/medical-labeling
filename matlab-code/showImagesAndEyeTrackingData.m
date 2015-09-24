function showImagesAndEyeTrackingData(video_filename, framePositions)
% Parameters:
%   video_filename: a string with the filename of the video
%   framePositions: a #frames x 2 matrix containing [X,Y] positions for
%   each frame.
vp = VideoPlayer(video_filename);
figure(1)
hold on;
i = 1;
while (true)
   plot(vp)
   hold on;
   plot(framePositions(i,1),framePositions(i,2),'Marker','.','Color',[1 0 0], 'MarkerSize',20);
   drawnow; 
   i = i + 1;
    
   if ( ~vp.nextFrame )
       break;
   end  
end