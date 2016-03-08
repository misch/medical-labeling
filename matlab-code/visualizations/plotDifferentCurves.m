dataset = 2;

dataset_folder = ['../results/Dataset', num2str(dataset),'/'];

disp('Choose superpixel PR.mat');
[filename, data_path_super] = uigetfile([dataset_folder,'*.mat']);
load([data_path_super, filename]);

figure;
plot(recall,precision,'Color',[0 0 0]);


disp('Choose superpixel/coocc PR.mat');
[filename, data_path_supercoocc] = uigetfile([dataset_folder,'*.mat'])
load([data_path_supercoocc,filename]);

hold on; plot(recall,precision,'r');

disp('Choose small superpixel/coocc PR.mat');
[filename, data_path_smallsupercoocc] = uigetfile([dataset_folder,'*.mat'])
load([data_path_smallsupercoocc,filename]);

hold on; plot(recall,precision,'Color', [0 0.5 0]);

disp('Choose patch PR.mat');
[filename, data_path_patch] = uigetfile([dataset_folder,'*.mat'])
load([data_path_patch,filename]);

hold on; plot(recall,precision,'b--');
axis( [0 1 0 1] );
title('precision-recall curve');
xlabel('Recall');
ylabel('Precision');
legend('superpixels (hist40, mean, var)','superpixels (hist10, mean, var, co-occurrence)','small superpixels (hist10, mean, var, co-occ)','patches');

%%
filename = 'ROC.mat';
% [filename, data_path] = uigetfile([dataset_folder,'*.mat']);
if ~exist('data_path_super','var')
    disp('Choose superpixel ROC.mat');
    [~, data_path_super] = uigetfile([dataset_folder,'*.mat']);

end
load([data_path_super, filename]);
    
figure;
plot(false_positive_rate,recall,'Color',[0 0 0]);

if ~exist('data_path_supercoocc','var')
    disp('Choose superpixel/coocc ROC.mat');
    [filename, data_path_supercoocc] = uigetfile([dataset_folder,'*.mat']);
end

load([data_path_supercoocc, filename]);

hold on; plot(false_positive_rate,recall,'r');


if ~exist('data_path_smallsupercoocc','var')
    disp('Choose small superpixel/coocc ROC.mat');
    [filename, data_path_smallsupercoocc] = uigetfile([dataset_folder,'*.mat']);
end

load([data_path_smallsupercoocc, filename]);

hold on; plot(false_positive_rate,recall,'Color', [0 0.5 0]);


if ~exist('data_path_patch','var')
    disp('Choose patch ROC.mat');
    [filename, data_path_patch] = uigetfile([dataset_folder,'*.mat']);
end

load([data_path_patch, filename]);

hold on; plot(false_positive_rate,recall,'b--');

axis( [0 1 0 1] );
title('ROC curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
legend('superpixels (hist40, mean, var)','superpixels (hist10, mean, var, co-occurrence)','small superpixels (hist10, mean, var, co-occ)','patches');