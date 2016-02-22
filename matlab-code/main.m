%% new main structure:

run prepareData

dataset = 2;
	
%assembleTrainingDataSuperpixels(dataset,'trainingAutoencodedSuperpixels.mat');
% assembleTrainingDataSuperpixels(dataset,'trainingTest.mat');
assembleReferenceTrainingDataSuperpixels(dataset,'trainingSuperpixelsColorReference.mat','../data/Dataset2/ground_truth-frames/');
% assembleTrainingDataPatches(dataset,'trainingPatches.mat');

classifier = 'pu_grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixelsColorReference');

%%
testSuperpixelClassifier(model, dataset, [105:50:655], classifier,'simple-color-descriptors/');
% testPatchClassifier(model,dataset,[139:10:229], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: ???
% Dataset7: [30:3:60]
% Dataset8: [139:10:229]