% Calculate and plot the area of an object throughout the whole dataset
% (all the frames)
clc;
dataset = 8;

[dataset_folder,~, ~, frame_height, frame_width] = getDatasetDetails(dataset);

gt_folder = [dataset_folder,'ground_truth-frames/'];

file_names = dir([gt_folder, '*.png']);
area = zeros(1,length(file_names));
%%
for ii = 1:length(file_names);
    filename = [gt_folder,file_names(ii).name];
    test = getGrayScaleImage(filename);
    area(ii) = sum(sum(test>0.1));
end

avg_area = mean(area(area>0))
relative_avg_area = avg_area / (frame_width*frame_height)
%%

f = figure; hold on;
plot(area,'b','LineWidth',3); xlim([1 length(file_names)]);
hold on; plot(1:length(file_names),avg_area*ones(1,length(file_names)),'b--','LineWidth',2);

xlabel('frame','FontSize',18,'FontWeight','bold');
ylabel('object size [#px]','FontSize',18,'FontWeight','bold');
box off;

hold on; plot(gradient(area),'LineWidth',1); xlim([1 length(file_names)]);
xlabel('frame','FontSize',18,'FontWeight','bold');
ylabel('object size [#px]','FontSize',18,'FontWeight','bold');
box off;
legend('object area','mean','gradient');
% saveToPDFWithoutMargins(f,'test.pdf');
