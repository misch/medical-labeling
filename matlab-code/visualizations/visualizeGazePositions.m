% Show how much positive information could be gained by giving a certain
% tolerance. If many possible tolerances want to be seen, a simple plot
% over tolerances is outputted - if only one tolerance value is examined,
% then it can be seen more detailed, where the information was wrong or correct.
dataset = 8;
[dataset_folder, frames_dir, ~, frame_height, frame_width] = getDatasetDetails(dataset);
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

tolerance = [0:30, 32:2:50, 60:10:100, 150, 200];
% tolerance = [22];
tolerance_plot_vals = zeros(1,length(tolerance));
gt_vals = zeros(length(gt_files),1);
for j = 1:length(tolerance)
    t = tolerance(j);
    for i = 1:length(gt_files)
        gt_file = [ground_truth_dir, gt_files(i).name];

        current_gt = getGrayScaleImage(gt_file);
        threshold = 0.1;
        pos_x = round(framePositions(i,2));
        pos_y = round(framePositions(i,1));

        try
            tmp = current_gt(max(1,pos_x-t):min(frame_height,pos_x+t),max(1,pos_y-t):min(frame_width,pos_y+t));
            gt_vals(i) = any(tmp(:));
        catch
            disp(sprintf('At frame %d, the position (%d,%d) was not in the image.',i,pos_x,pos_y));
        end
    end
    tolerance_plot_vals(j) = sum(gt_vals);
end

if length(tolerance) > 1
   figure;
   plot(tolerance,tolerance_plot_vals); grid on; grid minor;
   title(sprintf('Postive gaze positions (Dataset %d)',dataset));
   xlabel({'tolerance','(pixels)'});
   ylabel({'#positive gaze-positions','(positive gt within tolerance window)'});
   ylim([0, max(tolerance_plot_vals)+1]);
   set(gca,'XTick',0:10:tolerance(end));
   
   % get an example to show the dimensions
   example_img = im2double(imread([frames_dir,gt_files(round(i/2)).name]));
   example_size = 10;
   rectangle_size = example_size*2 + 1;
   figure;
   imshow(example_img); hold on;
   rectangle('Position',[round(frame_width/2)-round(rectangle_size/2) round(frame_height/2)-round(rectangle_size/2) rectangle_size rectangle_size],'FaceColor','r');
   title(sprintf('illustration: %dpx tolerance',example_size));
end
cols = [zeros(size(framePositions(:,3),1),1), gt_vals*0.6, zeros(size(framePositions(:,3),1),1)];
key_pressed = framePositions(:,3) > 0;
%%
if (length(tolerance) ==1)
    f = figure;
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

    annotation('textbox', [0 0.9 1 0.1], ...
        'String', sprintf('Dataset %d, tolerance = %dpx', dataset, tolerance), ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center','FontSize',12);


    % h = gcf;
    % set(h,'PaperOrientation','landscape');
    %% 
    key_pressed = framePositions(:,3) > 0;
    figure; hold on;
    scatter(framePositions(key_pressed,1), framePositions(key_pressed,2), [],cols(key_pressed,:,:), 'o'); hold on;
    scatter(framePositions(~key_pressed,1), framePositions(~key_pressed,2),[],cols(~key_pressed,:,:),'+'); axis([0 frame_width 0 frame_height]);
    title(sprintf('Dataset %d, tolerance = %dpx',dataset,tolerance));

    % create plot legend
    legendies(1) = plot(NaN,NaN,'ok'); % 'o' --> key pressed
    legendies(2) = plot(NaN,NaN,'+k'); % '+' --> key not pressed
    legendies(3) = plot(NaN,NaN,'s','MarkerFaceColor',[0,0.6,0]); % green --> on object
    legendies(4) = plot(NaN,NaN,'sk','MarkerFaceColor','k'); % black --> not on object
    legend(legendies,'key pressed','key not pressed','gaze on object','gaze not on object');
end