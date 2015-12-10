%% new main structure:

run prepareData

dataset = 2;
	
assembleTrainingDataSuperpixels(dataset);

classifier = 'svm'
model = trainClassifier(dataset, classifier);

testSuperpixelClassifier(model, dataset, [105:50:655], classifier);
% - run testing / evaluation