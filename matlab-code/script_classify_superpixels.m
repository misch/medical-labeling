%% Define data paths and actions
dataset = 8;
[dataset_folder, frames_dir, ~ , frame_height, frame_width, num_frames] = getDatasetDetails(dataset);

if (exist([dataset_folder,'ground_truth-frames'],'dir') > 0)
    ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
else
    ground_truth_dir = 0; 
end


load([dataset_folder, 'trainingSuperpixels']);


%% get or create test set

% ===============================================================================================
% Is that code still needed?
% ===============================================================================================
%{
    frame_no = '00189'; % for dataset 8
    data_id = fopen([dataset_folder,'test-data/superpixels/','test_data_frame_',frame_no,'.dat']);
    test_data = fread(data_id,'double');
    fclose(data_id);
    
    labels_id = fopen([dataset_folder,'test-data/','test_labels_frame_',frame_no,'.dat']);
    test_labels = fread(labels_id,'double');
    fclose(labels_id);
    
    test_data = reshape(test_data,size(test_labels,1),[]);

    % this code loads some particular test-data of one frame; this
    % test-data consists of descriptors and information about ground truth
    % (in case of superpixels, just information to backproject stuff back
    % to the single pixels)
%}
% ===============================================================================================    



%% Test SVM
disp('Test Classifier...');

% todo: get that from prepared descriptors!
test_data = normalized_data(size(processed_ROIs,1)+1:size(processed_ROIs,1)+size(test_labels,1),:);


if strcmp(classifier,'svm')
    [predicted_label, accuracy, scores] = libsvmpredict(test_labels, test_data, model);
elseif strcmp(classifier,'grad_boost')
    scores = SQBMatrixPredict(model, single(test_data)); 
    binary_decisions = ((scores >= 0) - 0.5) * 2;
    good = (binary_decisions == test_labels);
    accuracy = 100*sum(good)/length(good);
end


%% Evaluation 

% Project predictions back to pixels
projected_img = zeros(size(super_img));
for i = 1:(max(super_img(:)))
   projected_img(super_img == i) = scores(i);
end

projected_scores = projected_img(:);


gt = getGrayScaleImage([ground_truth_dir,'frame_',frame_no,'.png']);

threshold = 0.1;
gt(gt > threshold) = 1;
gt(gt < threshold) = -1;

test_labels = gt(:);

disp('Show performance measures...');
Ntest = size(test_labels,1);
[sorted_scores,idx] = sort(projected_scores,'descend');
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

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}
    false_positive_rate = cumsum(~positives) ./ sum(~positives)';

    figure;
    plot(false_positive_rate,recall);
    axis( [0 1 0 1] );
    title('ROC curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');


    % Heat map
    figure;
    colormap('hot');   % set colormap
    imagesc(projected_img); % draw image and scale colormap to values range
    colorbar;          % show color scale

    % Binary decisions
    figure;
    imshow(projected_img>=0);

    % Ground truth
    figure;
    imshow(gt);