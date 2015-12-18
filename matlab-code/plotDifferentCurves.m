dataset = 8;

dataset_folder = ['../results/Dataset', num2str(dataset),'/'];

disp('Choose superpixel PR.mat');
[filename, data_path] = uigetfile([dataset_folder,'*.mat']);
load([data_path, filename]);

figure;
plot(recall,precision);

disp('Choose patch PR.mat');
[filename, data_path] = uigetfile([dataset_folder,'*.mat'])
load([data_path,filename]);

hold on; plot(recall,precision);
axis( [0 1 0 1] );
title('precision-recall curve');
xlabel('Recall');
ylabel('Precision');
legend('superpixels','patches');

%%
disp('Choose superpixel ROC.mat');
[filename, data_path] = uigetfile([dataset_folder,'*.mat']);
load([data_path, filename]);
    
figure;
plot(false_positive_rate,recall);

disp('Choose patch ROC.mat');
[filename, data_path] = uigetfile([dataset_folder,'*.mat']);
load([data_path, filename]);

hold on; plot(false_positive_rate,recall);

axis( [0 1 0 1] );
title('ROC curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
legend('superpixels','patches','Position','south');