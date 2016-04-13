%% Add subfolders
addpath(genpath(pwd));


%%
run prepareData
%%
dataset = 2;
%%
%assembleTrainingDataSuperpixels(dataset,'trainingAutoencodedSuperpixels.mat');

observations = dir(['../data/Dataset',num2str(dataset),'/gaze-measurements/*.csv']);
for ii = 1:length(observations)
    assembleTrainingDataSuperpixels(dataset,['trainingSmallSuperpixelsCoocc_new',num2str(ii),'.mat'],observations(ii).name);
end
%%
assembleReferenceTrainingDataSuperpixels(dataset,'trainingSmallSuperpixelsCOOCCnew_onePositivePerFrame-0_5.mat','../data/Dataset8/ground_truth-frames/',true);
% for reference: key_pressed values of:
% - d2: gaze observation #2
% - d7: gaze observation #2
% - d8: gaze observation #2
%%
assembleTrainingDataPatches(dataset,'trainingPatches1.mat');
%%
classifier = 'pu_grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixelsColorReference-0_5');

%%
testSuperpixelClassifier(model, dataset, [139:10:229], classifier,'small-superpixels-coocc-descriptors_new/'); %find(~key_pressed)'
% testPatchClassifier(model,dataset,[105:50:655], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: [9:30:279]
% Dataset7: [30:3:60]
% Dataset8: [139:10:229] (100-230)