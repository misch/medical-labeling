[dataset_folder, ~, ~, frame_height, frame_width] = getDatasetDetails(7);
ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
gt_files = dir([ground_truth_dir, '*.png']);

% Get Eye-Tracking information
filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

if (length(gt_files)~=length(framePositions))
    disp('#gaze observations ~= #gt-frames');
end


%% Make colors depending on whether gaze position is on object (green) or not (red)
gt_vals = zeros(length(gt_files),1);
for i = 1:length(gt_files)
    gt_file = [ground_truth_dir, gt_files(i).name];
    
    current_gt = getGrayScaleImage(gt_file);
    threshold = 0.1;
    try
        gt_vals(i) = current_gt(round(framePositions(i,2)), round(framePositions(i,1))) > threshold; % ?? todo: check order!  
    catch
        disp(sprintf('At frame %d, the position (%d,%d) was not in the image.',i,round(framePositions(i,2)),round(framePositions(i,1))));
    end
end

cols = [zeros(size(framePositions(:,3),1),1), gt_vals*0.6, zeros(size(framePositions(:,3),1),1)];
key_pressed = framePositions(:,3) > 0;
%%
figure;
subplot(2,2,1);
frameax = [1:length(framePositions(:,1))]';
scatter(frameax(key_pressed), framePositions(key_pressed,1), [],cols(key_pressed,:,:), 'o'); hold on;
scatter(frameax(~key_pressed), framePositions(~key_pressed,1), [],cols(~key_pressed,:,:), '+');
axis([0 length(frameax) 0 frame_width]);
title('horizontal movements (y axis)');

% legend
legendies(1) = plot(NaN,NaN,'ok'); % 'o' --> key pressed
legendies(2) = plot(NaN,NaN,'+k'); % '+' --> key not pressed
legendies(3) = plot(NaN,NaN,'s','MarkerFaceColor',[0,0.6,0]); % green --> on object
legendies(4) = plot(NaN,NaN,'sk','MarkerFaceColor','k'); % black --> not on object
legend(legendies,'key pressed','key not pressed','gaze on object','gaze not on object');




subplot(2,2,3);
plot(gradient(framePositions(:,1)));
title('horizontal gradient (y axis)');


subplot(2,2,2);
frameax = [1:length(framePositions(:,2))]';
scatter(frameax(key_pressed), framePositions(key_pressed,2), [],cols(key_pressed,:,:), 'o'); hold on;
scatter(frameax(~key_pressed), framePositions(~key_pressed,2), [],cols(~key_pressed,:,:), '+');
axis([0 length(frameax) 0 frame_height]);
title('vertical movements (x axis)');

legend(legendies,'key pressed','key not pressed','gaze on object','gaze not on object');

subplot(2,2,4);
plot(gradient(framePositions(:,2)));
title('vertical gradient (x axis)');

h = gcf;
set(h,'PaperOrientation','landscape');
%% 
key_pressed = framePositions(:,3) > 0;
figure; hold on;
scatter(framePositions(key_pressed,1), framePositions(key_pressed,2), [],cols(key_pressed,:,:), 'o'); hold on;
scatter(framePositions(~key_pressed,1), framePositions(~key_pressed,2),[],cols(~key_pressed,:,:),'+'); axis([0 frame_width 0 frame_height]);
title('Dataset 7');

% create plot legend
legendies(1) = plot(NaN,NaN,'ok'); % 'o' --> key pressed
legendies(2) = plot(NaN,NaN,'+k'); % '+' --> key not pressed
legendies(3) = plot(NaN,NaN,'s','MarkerFaceColor',[0,0.6,0]); % green --> on object
legendies(4) = plot(NaN,NaN,'sk','MarkerFaceColor','k'); % black --> not on object
legend(legendies,'key pressed','key not pressed','gaze on object','gaze not on object');