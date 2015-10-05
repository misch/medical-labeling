%% Define data paths and actions
addpath('../libsvm')

dataset = 1;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);

normalized_data = normalizeData(processed_ROIs);

%% Randomly select train and test data
testPercent = 30;

test_indices = rand(1,size(normalized_data,1)) <= testPercent/100;
train_indices = ~test_indices;

train_data = normalized_data(train_indices,:);
train_labels = labels(train_indices);

test_data = normalized_data(test_indices,:);
test_labels = labels(test_indices);

%% Train SVM

model = svmtrain(train_labels, train_data);

%% Test SVM
[predicted_label, accuracy, decision_values] = svmpredict(test_labels, test_data, model);

%% Evaluation 

Ntest = size(test_data,1);
[sorted_scores,idx] = sort(decision_values,'descend');
sorted_test_labels = test_labels(idx);
positives = sorted_test_labels == 1;

% Precision-Recall-curve (PR)

% Precision: TP / (TP + FP)
% What fraction of the predicted positives are actually positive?
precision = cumsum(positives)./(1:Ntest)'; % is less than 1 if the number of (actual) positives are found (hopefully, recall is 1 then)

% Recall: TP / (TP + FN)
% How many of the positive test labels are actually found?
recall = cumsum(positives)/sum(positives); % is less than 1 if not yet all points are considered (hopefully, precision is 1 then)

figure;
plot(recall,precision);
axis( [0 1 0 1] );
title('precision-recall curve');
xlabel('Recall');
ylabel('Precision');