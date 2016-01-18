function [] = clusterSuperpixels()

% This script will collect positive superpixels and cluster them.
close all;
dataset = 7;
[dataset_folder,frames_dir, ~, frame_height, frame_width, ~] = getDatasetDetails(dataset);
%% get some positive superpixels:

ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
file_names = dir([ground_truth_dir, '*.png']);

num_frames = length(file_names);

frame_percentage = 101;
frame_indices = find(rand(1,num_frames) <= frame_percentage/100);

superpixel_dir = [dataset_folder,'small-superpixel-coocc-descriptors/'];

kept_record = struct();

positive_descriptors = [];

for idx = frame_indices
    
   % get positive points
    gt = getGrayScaleImage([ground_truth_dir,sprintf('frame_%05d.png',idx)]);

    % get the superpixels of those ground-truth locations
    descriptor_file = [superpixel_dir,sprintf('frame_%05d.mat',idx)];
    load(descriptor_file);
    superpixel_list = unique(frameDescriptor.superpixels(find(gt>0.1)));
   
    keepsup = logical(zeros(size(superpixel_list)));
    sup_img = frameDescriptor.superpixels;
    j = 1;
    for i = 1:length(superpixel_list)
        n_positives = sum(gt(sup_img == superpixel_list(i)) > 0.1);
        n_total = length(gt(sup_img == superpixel_list(i)));
        keepsup(j) = and(n_positives >  n_total/2, n_total > 0);
                        
        j=j+1;
    end
    
    superpixel_list = superpixel_list(keepsup);
    
    if ~isempty(superpixel_list)
        kept_record = appendToStruct(kept_record,idx,superpixel_list);
    end
    positive_descriptors = cat(1,positive_descriptors,frameDescriptor.features(superpixel_list+1,:));
end

%% Cluster them
[idx, centers] = kmeans(positive_descriptors,3);

% Project back the clusters to the superpixels
offset = 1;
for i = 1:length(kept_record)
    n_superpixels_in_frame = length(kept_record(i).kept_superpixels);
    
    kept_record(i).superpixel_clusters = idx(offset:offset+n_superpixels_in_frame-1);
    offset = offset + n_superpixels_in_frame;
end

% Set color depending on clusters
cols = [(idx ==1), (idx==2), (idx==3)];

[pc,score] = pca(positive_descriptors,'NumComponents',2);

f(1) = figure; 
scatter(score(:,1), score(:,2), [], cols);
title('clusters in feature space (76-dim), visualized using PCA'); 

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

f(2) = figure; 
bar([hist_values_gaze/sum(hist_values_gaze), hist_values_gt/sum(hist_values_gt)]);
legend('gaze-positions closest cluster','positive ground truth superpixels belonging to cluster', 'Location','northoutside');
title(sprintf('Positive samples found by gaze positions (Dataset %d)',dataset));
Labels = {'red', 'green', 'blue'};
set(gca, 'XTick', 1:3, 'XTickLabel', Labels);

%% get the fraction of gaze positions that actually were positive superpixels...
f(3) = figure;
[pos_fract] = getFractionOfPositiveAndNegativeSuperpixels(superpixel_dir, ground_truth_dir, framePositions);
plot(pos_fract,'*'); 

ylim([-0.1, 1.1]);
posline = refline(0,0.5); posline.Color = 'r'; posline.LineStyle = '--';
xlabel('observed frame [key pressed by user]');
ylabel('positive pixels (%) in stared-at superpixels');
legend('fraction of positive pixels','fraction > 0.5 means: staring at a true positive superpixel', 'Location','northoutside');
title('Fraction of positive pixels in the observed superpixels');

f(4) = figure;
labelvec = {'pos (>50% positive pixels)','neg (<=50% positive pixels)'};
bar([sum(pos_fract > 0.5) sum(pos_fract <= 0.5)]);
title('Observed superpixels')
set(gca, 'XTick', 1:2, 'XTickLabel',labelvec);

%% save it all 
savefig(f,sprintf('dataset%d-smallsuperpixels.fig',dataset));

%% Show clusters in image space
figure;
plot_idx = 1;
for i = 1:3:length(kept_record)
%     subplot(3,6,i); % dataset 7
    subplot(5,13,plot_idx); % dataset 8
    frame_no = kept_record(i).frame;
    descriptor_file = [superpixel_dir,sprintf('frame_%05d.mat',frame_no)];
    img_file = [frames_dir,sprintf('frame_%05d.png',frame_no)];
    load(descriptor_file);
    img = im2double(imread(img_file));
    mask = zeros([size(img,1), size(img,2), 3]);   
    for j = 1:length(kept_record(i).kept_superpixels)
        tmp_mask = (frameDescriptor.superpixels == kept_record(i).kept_superpixels(j));
        
        mask(:,:,1) = mask(:,:,1) + tmp_mask .* (kept_record(i).superpixel_clusters(j)==1);
        mask(:,:,2) = mask(:,:,2) + tmp_mask .* (kept_record(i).superpixel_clusters(j)==2);
        mask(:,:,3) = mask(:,:,3) + tmp_mask .* (kept_record(i).superpixel_clusters(j)==3);
    end
    imshow(img); hold on;
    him = imshow(mask);
    set(him,'AlphaData',max(mask,[],3)-0.5);
    title(him.Parent, sprintf('frame %d',frame_no));
    plot_idx = plot_idx + 1;
end

end 

function [kept_record] = appendToStruct(kept_record,idx,superpixel_list)
    if and(length(kept_record) == 1, isempty(fieldnames(kept_record)))
            kept_record(1).frame = idx;
            kept_record(1).kept_superpixels = superpixel_list;
        else
            kept_record(end+1).frame = idx;
            kept_record(end).kept_superpixels = superpixel_list;
    end
end