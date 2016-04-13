%% Show ground truth image with gaze dot and 128x128 window
% first: get the frame positions of the corresponding dataset that you wanna show!
frame_no = 46;
figure; imshow(im2double(imread(['../../data/Dataset2/ground_truth-frames/',sprintf('frame_%05d.png',frame_no)])),'Border','tight');
fp = framePositions;
hold on; plot(fp(frame_no,1),fp(frame_no,2),'Marker','.','Color',[1, 0, 0], 'MarkerSize',30);
hold on; rectangle('Position',[fp(frame_no,1)-(128/2) fp(frame_no,2)-(128/2) 128 128],'EdgeColor','r','LineWidth',3);