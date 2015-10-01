%% Define data paths and actions
addpath('..\libsvm')

dataset = 2;
dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);

normalized_data = normalizeData(processed_ROIs);

model = svmtrain(labels, normalized_data);

% todo: separation of training and test data, check options for svmtrain,
% plot ROC- and PR-curves, ...