function showImagesAndEyeTrackingData(video_filename, framePositions)
% Parameters:
%   video_filename: a string with the filename of the video
%   framePositions: a #frames x 2 matrix containing [X,Y] positions for
%   each frame.

if str2num(matlab_version(1:4)) <= 2010
    % install VideoUtils Toolbox
    run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';


    vp = VideoPlayer(video_filename);
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
else
    video = VideoReader(video_filename);
    
    num_frames = video.NumberOfFrames;
    mousePositions = zeros(num_frames,2);
    video = VideoReader(video_filename);
    for i = 1:num_frames
        frame = readFrame(video);
        imshow(frame);
        plot(framePositions(i,1),framePositions(i,2),'Marker','.','Color',[1 0 0], 'MarkerSize',20);
        drawnow;
    end 
end