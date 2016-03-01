function testSuperpixelClassifier(model, dataset, test_frames, classifier,descriptor_dir)
% model: a trained classifier model
% test_frames: a Nx1 array containing the frames for which the pixels
% should be classified
% classifier: either 'svm' or 'grad_boost'
% descriptor_dir: the directory where the descriptors are stored
        

%% Test Classifier
disp('Test Classifier...');

[dataset_folder] = getDatasetDetails(dataset);
ground_truth_dir = [dataset_folder,'ground_truth-frames/'];

projected_scores = [];
test_labels = [];
classifier_results = struct('scores',[],'frame_idx',[],'input',[],'classifier',classifier,'dataset',dataset,'descriptor_dir',[dataset_folder,descriptor_dir],'ground_truth_dir',ground_truth_dir);

for frame = test_frames
    frame_no = sprintf('%05d', frame); 
    
    load([dataset_folder,descriptor_dir,'frame_',frame_no]);
    test_data = frameDescriptor.features;
    classifier_results.input = cat(1,classifier_results.input,test_data);
    classifier_results.frame_idx = cat(1,classifier_results.frame_idx,frame*ones(size(test_data,1),1));

    if strcmp(classifier,'svm')
        [~,~, scores] = libsvmpredict(ones(size(test_data,1),1), test_data, model);
%         [~,scores] = predict(model,test_data);
    elseif strcmp(classifier,'grad_boost')
        scores = SQBMatrixPredict(model, single(test_data)); 
    elseif strcmp(classifier,'pu_grad_boost')
        scores = zeros(size(test_data,1),1);
        for m=1:length(model)
            scores = scores + model{m}.alpha.*evalWL(model{m}.wl,test_data);
        end
    end

    classifier_results.scores = cat(1,classifier_results.scores,scores);
end

% classifier_results.scores = smoothFrameLabels(classifier_results.input, classifier_results.scores>0,0.56);

[projected_scores, test_labels] = projectToPixels(classifier_results);


% At the very end, only once per bunch of frames                            
% disp('Show performance measures...');
    Ntest = size(projected_scores,1);
    [~,idx] = sort(projected_scores,'descend');
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
    ylabel('True Positive Rate (Recall)');
    save('ROC.mat','false_positive_rate','recall','-v7.3');
