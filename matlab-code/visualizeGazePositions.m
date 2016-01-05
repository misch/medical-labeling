[dataset_folder, ~, ~, frame_height, frame_width] = getDatasetDetails(2);


% Get Eye-Tracking information
filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

cols = [framePositions(:,3), zeros(size(framePositions(:,3),1),1), zeros(size(framePositions(:,3),1),1)];

figure;
subplot(2,2,1);
frameax = [1:length(framePositions(:,1))]';
scatter(frameax, framePositions(:,1),[],cols);
title('horizontal movements (y axis)');

subplot(2,2,3);
plot(gradient(framePositions(:,1)));
title('horizontal gradient (y axis)');

subplot(2,2,2);
frameax = [1:length(framePositions(:,2))]';
scatter(frameax, framePositions(:,2),[],cols);
title('vertical movements (x axis)');

subplot(2,2,4);
plot(gradient(framePositions(:,2)));
title('vertical gradient (x axis)');


%%
figure;
scatter(framePositions(:,1), framePositions(:,2), [], cols); axis([0 frame_width 0 frame_height]);