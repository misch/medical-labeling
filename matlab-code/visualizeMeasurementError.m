testimg = im2double(imread('testimg.png'));

frame_height = size(testimg,1);
frame_width = size(testimg,2);

framePositions1 = readCSVFile('dotInMiddle1.csv');
framePositions2 = readCSVFile('dotInMiddle2.csv');


framePositions1(:,1) = framePositions1(:,1) * frame_width;
framePositions1(:,2) = framePositions1(:,2) * frame_height;

framePositions2(:,1) = framePositions2(:,1) * frame_width;
framePositions2(:,2) = framePositions2(:,2) * frame_height;

pixel_radius_on_image = 18.6187; % get exact pixel_radius_on_image from calculate1degradius script...


center = [frame_width frame_height]/2;
h = figure;
imshow(img,'Border','tight');
hold on; legend_text(1) = plot(framePositions1(:,1),framePositions1(:,2),'-','Color',[0 0.7 0]);
axis([0 frame_width 0 frame_height]);
axis off;
hold on; legend_text(2) = plot(framePositions2(:,1), framePositions2(:,2),'-','Color',[0 0 0.7]);
legend_text(3) = plot(center(1),center(2),'+r','LineWidth',2);
legend_text(4) = viscircles(middle, pixel_radius_on_image,'EnhanceVisibility',false); 
le = legend(legend_text,'1st measurement', '2nd measurement','center','1 degree visual angle');
le.FontSize = 14;
saveToPDFWithoutMargins(h,'untitled2.pdf');


n_frames = size(framePositions1,1);
distances1 = sqrt(sum((framePositions1(:,1:2) - repmat([center(1), center(2)],n_frames,1)).^2,2));
distances2 = sqrt(sum((framePositions2(:,1:2) - repmat([center(1), center(2)],n_frames,1)).^2,2));

h = figure;
plot(distances1,'Color',[0 0.7 0]);
hold on;
plot(distances2,'Color',[0 0 0.7]);
xlabel('time (frames)','FontSize',14);
ylabel('euclidean distance to center [px]','FontSize',14);
hold on; plot(1:1000,pixel_radius_on_image*ones(1,1000),'-r','LineWidth',2);
le= legend('1st measurement','2nd measurement','1 degree visual angle');
le.FontSize = 14;
hold on; plot(1:1000, mean(distances1)*ones(1,1000),'--','Color',[0 0.7 0]);
hold on; plot(1:1000, mean(distances2)*ones(1,1000),'--','Color',[0 0 0.7]);
saveToPDFWithoutMargins(h,'untitled.pdf');


