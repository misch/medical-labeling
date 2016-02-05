%% new main structure:

run prepareData

dataset = 2;
	
assembleTrainingDataSuperpixels(dataset,'trainingSuperpixelsCoocc.mat');
% assembleTrainingDataPatches(dataset,'trainingPatches.mat');

classifier = 'pu_grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixelsCoocc');

%%
testSuperpixelClassifier(model, dataset, [105:50:655], classifier,'superpixel-coocc-descriptors/');
% testPatchClassifier(model,dataset,[139:10:229], classifier);

% frames to test:
% Dataset2: [105:50:655]
% Dataset5: ???
% Dataset7: [30:3:60]
% Dataset8: [139:10:229]