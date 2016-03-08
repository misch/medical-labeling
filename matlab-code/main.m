%% Add subfolders
addpath(genpath('./'));

%% new main structure:
run prepareData

dataset = 5;
	
%assembleTrainingDataSuperpixels(dataset,'trainingAutoencodedSuperpixels.mat');
% assembleTrainingDataSuperpixels(dataset,'trainingSuperpixelsColor.mat');
% assembleReferenceTrainingDataSuperpixels(dataset,'trainingSuperpixelsColorReference.mat','../../data/Dataset2/ground_truth-frames/');
assembleTrainingDataPatches(dataset,'trainingPatchesTest.mat');

classifier = 'grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixelsColor');

%%
testSuperpixelClassifier(model, dataset, [189], classifier,'color-superpixel-descriptors/');
% testPatchClassifier(model,dataset,[189], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: [9:30:279]
% Dataset7: [30:3:60]
% Dataset8: [139:10:229]