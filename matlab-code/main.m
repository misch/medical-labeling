%% Add subfolders
addpath(genpath(pwd));


%%
run prepareData
%%
dataset = 8;
%%
%assembleTrainingDataSuperpixels(dataset,'trainingAutoencodedSuperpixels.mat');

observations = dir(['../data/Dataset',num2str(dataset),'/gaze-measurements/*.csv']);
for ii = 1:length(observations)
    assembleTrainingDataSuperpixels(dataset,['trainingSmallSuperpixelsCoocc',num2str(ii),'.mat'],observations(ii).name);
end
%%
assembleReferenceTrainingDataSuperpixels(dataset,'trainingSmallSuperpixelsCooccReference-0_5.mat','../data/Dataset8/ground_truth-frames/');
% for reference: key_pressed values of:
% - d2: gaze observation #2
% - d7: gaze observation #2
% - d8: gaze observation #7
% assembleTrainingDataPatches(dataset,'trainingPatchesTest.mat');
%%
classifier = 'grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSmallSuperpixelsCooccReference-0_5');

%%
testSuperpixelClassifier(model, dataset, find(~key_pressed)', classifier,'small-superpixels-coocc-descriptors/'); %find(~key_pressed2)'
% testPatchClassifier(model,dataset,[189], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: [9:30:279]
% Dataset7: [30:3:60]
% Dataset8: [139:10:229]