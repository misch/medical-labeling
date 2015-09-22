%% install VideoUtils Toolbox
run 'C:\Program Files\MATLAB\R2010a\VideoUtils_v1_2_4\install.m';

%% load video
dataset = 2;
video_filename = ['../data/Training/Dataset',num2str(dataset),'/Video.avi'];

vp = VideoPlayer(video_filename);
% Todo: for a MATLAB newer than R2010a, use VideoReader!
% vidObj = VideoReader(video_filename);

%% Store frames as images
% frames_dir = '../frames/';
% start_frame = 0;
% frames = read(vidObj);
% 
% for i = 1:size(frames,4)
%    frameNr = sprintf('%03d',i+start_frame-1);
%    filename = [frames_dir,'frame_',frameNr,'.png'];
%    imwrite(frames(:,:,:,i),filename);
% end

%% Collect mouse positions (simulating eye-tracking data)
% Follow the thing you wanna track and click to update recorded mouse
% position.
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

%% Show images with recorded mouse positions
vp = VideoPlayer(video_filename);
figure(1)
hold on;

for i = 1:100
   imshow(vp.Frame)
   hold on;
   title(num2str(i));
   plot(mousePositions(i,1),mousePositions(i,2),'Marker','p','Color',[1 0 0], 'MarkerSize',50);
    drawnow; 
   i = i + 1;
   
    
   if ( ~vp.nextFrame )
       break;
   end  
   
end




%%


%% Releaseing the VideoPlayer Object
% After we have used the *VideoPlayer* object it is necessary to release it
% using this command:

clear vp;