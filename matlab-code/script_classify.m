%% Define data paths and actions
addpath('../libsvm-3.20/libsvm-3.20/matlab/')

dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];
frames_dir = [dataset_folder,'input-frames/'];

if (exist([dataset_folder,'ground_truth-frames'],'dir') > 0)
    ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
else
   ground_truth_dir = 0; 
end

load([dataset_folder, 'processed_ROIs']);


%% get or create test set
frame_percentage = 0.1; % rough amount of test-frames

create_new_test_set = false;

if create_new_test_set
    [test_data, test_labels] = createTestData(frames_dir,frame_percentage,ground_truth_dir,'test_data','test_labels');
else
%     frame_no = '00428'; % for dataset 5
    frame_no = '00642';
    data_id = fopen([dataset_folder,'test_data_frame_',frame_no,'.dat']);
    test_data = fread(data_id,'double');
    fclose(data_id);
    
    labels_id = fopen([dataset_folder,'test_labels_frame_',frame_no,'.dat']);
    test_labels = fread(labels_id,'double');
    fclose(labels_id);
    
    test_data = reshape(test_data,size(test_labels,1),[]);
end

%% normalize data (test and training set together!)
to_normalize = cat(1,processed_ROIs,test_data);
normalized_data = normalizeData(to_normalize);


%% Train SVM

train_data = normalized_data(1:size(processed_ROIs,1),:); % only positives to train one-class svm
train_labels = labels;
% To shorten computation time...
% train_percentage = 20;
% train_indices = find(rand(1,size(train_data,1)) <= train_percentage/100);
% train_data = train_data(train_indices,:);
% train_labels = train_labels(train_indices);

train_data = train_data(find(train_labels==1),:);
train_labels = train_labels(train_labels==1);

disp('Train SVM classifier...');
% model = libsvmtrain(train_labels,train_data,'-t 2 -g 0.5 -c 5 -h 0');
model = libsvmtrain(train_labels,train_data,'-s 2 -n 0.4 -c 2');

% bestacc = 0;
% for log2c = -3:3,
%   for log2n = -8:0,
% %     cmd = ['-v 4 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%     cmd = ['-s 2 -n ', num2str(2^log2n),' -c ',num2str(2^log2c)];
%     model = libsvmtrain(train_labels, train_data, cmd);
%     [predicted_labels, accuracy, decision_values] = libsvmpredict(test_labels, test_data, model);
%     if (accuracy >= bestacc),
%       bestacc = accuracy; bestc = 2^log2c; bestn = 2^log2n;
%     end
% %     fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%     fprintf('c=%g n=%g acc=%g (best c=%g, n=%g, rate=%g)\n', 2^log2c, 2^log2n, accuracy, bestc, bestn, bestacc);
%   end
% end





%%
disp('Test SVM classifier...');

% To reduce computation time
% test_percentage = 1;
% test_indices = find(rand(1,size(test_data,1)) <= test_percentage/100);
% 
% test_data = test_data(test_indices,:);
% test_labels = test_labels(test_indices);

test_data = normalized_data(size(processed_ROIs,1)+1:size(processed_ROIs,1)+size(test_data,1),:);

[predicted_label, accuracy, decision_values] = libsvmpredict(test_labels, test_data, model);


%% Evaluation 
disp('Show performance measures...');
Ntest = size(test_data,1);
[sorted_scores,idx] = sort(decision_values,'descend');
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

% visualize decision_values
file_names = dir([frames_dir, '*.png']);
ref_frame = imread([frames_dir,file_names(1).name]);

height = size(ref_frame,1) - 127;
width = size(ref_frame,2) - 127;

    % Heat map
    figure;
    colormap('hot');   % set colormap
    final_image_decisions = reshape(decision_values, height, []);
    imagesc(final_image_decisions);        % draw image and scale colormap to values range
    colorbar;          % show color scale

    % Binary decisions
    figure;
    imshow(final_image_decisions>=0);

    % Ground truth
    figure;
    imshow(reshape(test_labels,height,[]));
 
 
