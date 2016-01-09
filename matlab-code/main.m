%% new main structure:

% run prepareData

dataset = 2;
	
% assembleTrainingDataSuperpixels(dataset,'trainingSmallSuperpixelsCoocc.mat');
% assembleTrainingDataPatches(dataset,'trainingPatches.mat');

classifier = 'grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSmallSuperpixelsCoocc');

%%
testSuperpixelClassifier(model, dataset, [105:50:655], classifier);
% testPatchClassifier(model,dataset,[139:10:229], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: ???
% Dataset7: [20:5:55]
% Dataset8: [139:10:229]