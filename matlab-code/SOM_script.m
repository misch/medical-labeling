%% Define data paths and actions
addpath('../libsvm')

dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);
normalized_data = normalizeData(processed_ROIs);