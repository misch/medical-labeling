function testSuperpixelClassifier(model, dataset, test_frames, classifier)
% model: a trained classifier model
% test_frames: a Nx1 array containing the frames for which the pixels
% should be classified
% classifier: either 'svm' or 'grad_boost'
        

%% Test Classifier
disp('Test Classifier...');

[dataset_folder,~,~,frame_height] = getDatasetDetails(dataset);

height = frame_height - 127;

all_scores = [];
test_labels = [];
for frame = test_frames
    frame_no = sprintf('%05d', frame); 
    
    load([dataset_folder,'patch-descriptors/','frame_',frame_no]);
    test_data = frameDescriptor.features;

    if strcmp(classifier,'svm')
        [~,~, scores] = libsvmpredict(ones(size(test_data,1),1), test_data, model);
    elseif strcmp(classifier,'grad_boost')
        scores = SQBMatrixPredict(model, single(test_data)); 
    end

    all_scores = cat(1,all_scores,scores);
    gt = frameDescriptor.groundTruthLabels;
    test_labels = cat(1,test_labels,gt);

    final_image_scores = reshape(scores, height, []);
    
    % Heat map
    f(1) = figure;
    colormap('hot');   % set colormap
    imagesc(final_image_scores); % draw image and scale colormap to values range
    colorbar;          % show color scale
    
    % Binary decisions
    f(2) = figure;
    imshow(final_image_scores>=0);

    % Ground truth
    f(3) = figure;
    imshow(reshape(gt,height,[]));
    
    savefig(f,['frame_',frame_no,'.fig']);
    close(f)
end
                            

% At the very end, only once per bunch of frames                            
disp('Show performance measures...');
    Ntest = size(all_scores,1);
    [~,idx] = sort(all_scores,'descend');
    sorted_test_labels = test_labels(idx);
    positives = sorted_test_labels == 1;

% Precision-Recall-curve (PR)
    % Precision: TP / (TP + FP) = TP/#{all predicted positives}
    % What fraction of the predicted positives are actually positive?
    precision = cumsum(positives)./(1:Ntest)'; % is less than 1 if the number of (actual) positives are found (hopefully, recall is 1 then)

    % Recall = TPR (true positive rate) = TP / (TP + FN) = TP/#{positives} 
    % How many of the positive test labels are actually found?
    recall = cumsum(positives)/sum(positives); % is less than 1 if not yet all points are considered (hopefully, precision is 1 then)

    figure;
    plot(recall,precision);
    axis( [0 1 0 1] );
    title('precision-recall curve');
    xlabel('Recall');
    ylabel('Precision');
    save('PR.mat','precision','recall','-v7.3');

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}
    false_positive_rate = cumsum(~positives) ./ sum(~positives)';

    figure;
    plot(false_positive_rate,recall);
    axis( [0 1 0 1] );
    title('ROC curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    save('ROC.mat','false_positive_rate','recall','-v7.3');