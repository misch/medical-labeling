dataset = 7;
[dataset_folder, frames_dir, ~, frame_height, frame_width] = getDatasetDetails(dataset);
ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
gt_files = dir([ground_truth_dir, '*.png']);

% Get Eye-Tracking information
video_filename = 'whole_video10fps6.csv';
filename = [dataset_folder,'gaze-measurements/',video_filename];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;
key_pressed = framePositions(:,3) > 0;
if (length(gt_files)~=length(framePositions))
    disp('#gaze observations ~= #gt-frames');
end

load([dataset_folder,'1degVisualAnglePixelRadius']); % if not available, get pixel_radius_on_image from calculate1degradius script...

plot_vals = zeros(length(gt_files),1);

for j = 1:length(plot_vals)
        gt_file = [ground_truth_dir, gt_files(j).name];

        current_gt = getGrayScaleImage(gt_file);

        threshold = 0.1;
        current_gt = current_gt > threshold;

        pos_x = round(framePositions(j,2));
        pos_y = round(framePositions(j,1));
        
        distances = bwdist(current_gt);
        try
            plot_vals(j) = distances(pos_x,pos_y);
        catch
            plot_vals(j) = NaN;
        end
end

plot_vals(isinf(plot_vals)) = NaN;

pressed_vals = and(key_pressed,~isnan(plot_vals));
notpressed_vals = and(~key_pressed,~isnan(plot_vals));

%%
h = figure;
plot(find(pressed_vals),plot_vals(pressed_vals),'.','Color',[0 0 0.6],'MarkerSize',18); axis([1 length(plot_vals) 0 210]); hold on; 
plot(find(notpressed_vals),plot_vals(notpressed_vals),'.','MarkerSize',18,'Color',[0 0.6 0]);

hold on; plot(1:length(plot_vals),pixel_radius_on_image*ones(1,length(plot_vals)),'-r','LineWidth',2);
hold on; plot(1:length(plot_vals),mean(plot_vals(pressed_vals))*ones(1,length(plot_vals)),'--','Color',[0 0 0.6]);
hold on; plot(1:length(plot_vals),mean(plot_vals(notpressed_vals))*ones(1,length(plot_vals)),'--','Color',[0 0.6 0]);
le = legend('key pressed','key not pressed','1 degree visual angle'); le.FontSize = 14;
xlabel('time (frame)','FontSize',14);
ylabel('distance to closest true positive','FontSize',14);

saveToPDFWithoutMargins(h,'closestPositiveDataset7vid6.pdf');