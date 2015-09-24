
%% Define dataset and folders where to find them.
dataset = 2;

dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

video_filename = [dataset_folder,'Video.avi'];
frames_dir = [dataset_folder,'input-frames/']

%% Store video frames to .png images
videoToFrame(video_filename, frames_dir);


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