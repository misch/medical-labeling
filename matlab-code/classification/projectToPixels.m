function [projected_scores, test_labels] = projectToPixels(classifier_results)
    projected_scores = [];
    test_labels = [];
    for current_frame = unique(classifier_results.frame_idx)'
        
        load([classifier_results.descriptor_dir,sprintf('frame_%05d',current_frame)]);
        
        current_scores = classifier_results.scores(classifier_results.frame_idx == current_frame);
        super_img = frameDescriptor.superpixels;

        projected_img = zeros(size(super_img));
        
        % make sure that current_scores has same size as
        % frameDescriptor.superpixel_idx
        if length(current_scores) ~= length(frameDescriptor.superpixel_idx)
           disp('What the hell...?');
           return;
        end
        
        for jj = frameDescriptor.superpixel_idx'
            projected_img(super_img == jj) = current_scores(frameDescriptor.superpixel_idx == jj);
        end
    
    
    projected_scores = cat(1,projected_scores,projected_img(:)); % add new scores to already existing thing
    
    current_frame_str = sprintf('%05d',current_frame);
    filename = [classifier_results.ground_truth_dir,'frame_',current_frame_str,'.png'];
    if exist(filename, 'file') == 2
        gt = getGrayScaleImage(filename);
    else
        gt = zeros(size(super_img));
    end
    

    threshold = 0.1;
    gt(gt > threshold) = 1;
    gt(gt < threshold) = -1;

    test_labels = cat(1,test_labels,gt(:)); % add new labels to already existing ones

    
    % Heat map
    f(1) = figure;
    colormap('hot');   % set colormap
    imagesc(projected_img); % draw image and scale colormap to values range
    axis 'off';
    colorbar;          % show color scale

    % Binary decisions
    f(2) = figure;
    imshow(projected_img>0,'Border','tight');

    % Ground truth
    f(3) = figure;
    imshow(gt,'Border','tight');
    
    savefig(f,['frame_',current_frame_str,'.fig']);
    close(f)
    end