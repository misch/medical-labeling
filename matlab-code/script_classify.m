%% Define data paths and actions
addpath('..\libsvm')

dataset = 2;
dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);

normalized_data = normalizeData(processed_ROIs);

model = svmtrain(labels, normalized_data);

%%
testing_label_vector = labels(end-5:end);
testing_instance_matrix = normalized_data(end-5:end,:);

[predicted_label, accuracy, decision_values] = svmpredict(testing_label_vector, testing_instance_matrix, model)

% todo: separation of training and test data, check options for svmtrain,
% plot ROC- and PR-curves, ...