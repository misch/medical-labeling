%% new main structure:

% run prepareData

dataset = 2;
	
% assembleTrainingDataSuperpixels(dataset);
% assembleTrainingDataPatches(dataset);

classifier = 'grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixels');

testSuperpixelClassifier(model, dataset, [105:50:655], classifier);
% testPatchClassifier(model,dataset,[105:50:655], classifier);