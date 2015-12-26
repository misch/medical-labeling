% This script will collect positive superpixels and cluster them.
%
% Todo: somehow visualize WHICH superpixels have not been seen
dataset = 2;
[dataset_folder, ~, ~, frame_height, frame_width, ~] = getDatasetDetails(dataset);
%% get some positive superpixels:

ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
file_names = dir([ground_truth_dir, '*.png']);

num_frames = length(file_names);

frame_percentage = 101;
frame_indices = find(rand(1,num_frames) <= frame_percentage/100);

% frames_dir = '../data/Dataset2/input-frames/';
superpixel_dir = [dataset_folder,'superpixel-coocc-descriptors/'];


positive_descriptors = [];
for idx = frame_indices
    
   % get some random positive points
    gt = getGrayScaleImage([ground_truth_dir,sprintf('frame_%05d.png',idx)]);

    % get the superpixels of those gronud-truth locations
    
    descriptor_file = [superpixel_dir,sprintf('frame_%05d.mat',idx)];
    load(descriptor_file);
    superpixel_list = unique(frameDescriptor.superpixels(find(gt>0.1)));
   
    keepsup = logical(zeros(size(superpixel_list)));
    j = 1;
    for i = 1:length(superpixel_list)
        sup_img = frameDescriptor.superpixels;
        n_positives = sum(gt(sup_img == superpixel_list(i)) > 0.1);
        n_total = length(gt(sup_img == superpixel_list(i)));
        keepsup(j) = and(n_positives >  n_total/2, n_total > 0);
                        
        j=j+1;
    end
    
    superpixel_list = superpixel_list(keepsup);
    
    positive_descriptors = cat(1,positive_descriptors,frameDescriptor.features(superpixel_list+1,:));
end

%% Cluster them
[pc,score] = pca(positive_descriptors,'NumComponents',3);

[idx, centers] = kmeans(positive_descriptors,3);
cols = [(idx ==1), (idx==2), (idx==3)];
figure; scatter3(score(:,1),score(:,2),score(:,3),[],cols);
title('3 clusters, visualized using 3 principal components');

figure; scatter(score(:,1), score(:,2), [], cols);
title('3 clusters, visualized using 2 principal components'); 

%% Get the gaze-superpixels

% Get Eye-Tracking information
filename = [dataset_folder, 'framePositions.csv'];
framePositions = readCSVFile(filename);
framePositions(:,1) = framePositions(:,1) * frame_width;
framePositions(:,2) = framePositions(:,2) * frame_height;

[positives,~] = getPositiveAndNegativeSuperpixels(superpixel_dir, framePositions);

dist1 = sqrt(sum( (positives-repmat(centers(1,:),size(positives,1),1)).^2 ,2));
dist2 = sqrt(sum( (positives-repmat(centers(2,:),size(positives,1),1)).^2 ,2));
dist3 = sqrt(sum( (positives-repmat(centers(3,:),size(positives,1),1)).^2 ,2));

% for each gaze point:
% M = distance to closest cluster center
% I = cluster id
[M,I] = min([dist1,dist2,dist3],[],2);

hist_values_gaze = histc(I,1:3);

hist_values_gt = histc(idx,1:3);

figure; bar([hist_values_gaze/sum(hist_values_gaze), hist_values_gt/sum(hist_values_gt)]);
legend('gaze-positions superpixels belonging to cluster','positive ground truth superpixels belonging to cluster', 'Location','northoutside');
% hold on; bar(hist_values_gt,'r');

%% get the fraction of gaze positions that actually were positive superpixels...
figure;
[pos_fract] = getFractionOfPositiveAndNegativeSuperpixels(superpixel_dir, ground_truth_dir, framePositions);
plot(pos_fract,'*'); 
% axis([-0.1 1.1 -0.1 1.1]);
posline = refline(0,0.5); posline.Color = 'r'; posline.LineStyle = '--';
xlabel('(interesting) frame [key pressed]');
ylabel('fraction of positive pixels in the stared-at superpixels');
legend('fraction of positive pixels','fraction > 0.5 means: staring at a true positive superpixel');

figure;
labelvec = {'pos (>50%)','neg (<=50%)'};
bar([sum(pos_fract > 0.5) sum(pos_fract <= 0.5)]);
title('Observed superpixels')
set(gca, 'XTick', 1:2, 'XTickLabel',labelvec);
