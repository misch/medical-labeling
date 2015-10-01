%% Define data paths and actions
addpath('..\libsvm')

dataset = 2;
dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

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

%% Plot ROC- and PR-curves
% todo