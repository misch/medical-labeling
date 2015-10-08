%% Define data paths and actions
addpath('../libsvm')

dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);
normalized_data = normalizeData(processed_ROIs);

processed_positives = normalized_data(labels == 1,:);

%% Randomly select train and test data
testPercent = 20;

test_indices = rand(1,size(normalized_data,1)) <= testPercent/100;
train_indices = ~test_indices;

% train_data = normalized_data(train_indices,:);
% train_labels = labels(train_indices);

train_data = processed_positives;
train_labels = labels(labels == 1);

test_data = normalized_data(test_indices,:);
test_labels = labels(test_indices);

%% Train SVM
% todo: use libsvm cross-validation
model = svmtrain(train_labels, train_data,'-s 2 -n 0.1 -t 2 -g 0.05');

%% Test SVM
[predicted_label, accuracy, decision_values] = svmpredict(test_labels, test_data, model);

%% Evaluation 

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