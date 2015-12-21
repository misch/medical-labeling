% This script will collect positive superpixels and cluster them.

%% get some positive superpixels:

ground_truth_dir = '../data/Dataset2/ground_truth-frames/';
file_names = dir([ground_truth_dir, '*.png']);

num_frames = length(file_names);

frame_percentage = 20;
frame_indices = find(rand(1,num_frames) <= frame_percentage/100);

frames_dir = '../data/Dataset2/input-frames/';
superpixel_dir = '../data/Dataset2/superpixel-coocc-descriptors/';


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
[pc,score] = p[pc,score] = princomp(positive_descriptors);rincomp(positive_descriptors);