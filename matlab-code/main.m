% This is the main script of the project to use eye-tracking for labeling
% in 3D. It performs the following steps:
%
% 1) add subfolders: this should always be executed, even if only other
% parts of the code are being used, as otherwise the necessary matlab
% functions might not be found.
%
% 2) prepare data: this part is used when a new dataset is being used; that
% is, a completely new video or 3D volume. It will write the data to image
% files and create some descriptors for them. Also, whenever new
% descriptors for already existing datasets should be generated (e.g. to
% try out new features), the prepareData-script should be executed.
%
% 3) fix dataset: as many functions will use the dataset to automatically
% determine where to find things (see file structure in README.md), this
% usually should be executed.
%
% 4) assemble training data: this part has to be executed, if the training
% data to be used does not yet exist (e.g. right after generating the
% descriptors in step 2), step 4) is necessary to collect from all the
% superpixels the positives and negatives using the gaze data
%
% 5) train classifier: train a classifier
%
% 6) test classifier: test the classifier on some chosen frames
% (performance curves will be calculated pixel-wise, even though all the
% pixels of one superpixel will get the same scores)
%% 1) add subfolders
addpath(genpath(pwd));


%% 2) prepare data
run prepareData

%% 3) fix dataset
dataset = 2;

%% 4) assemble training data

%assembleTrainingDataSuperpixels(dataset,'trainingAutoencodedSuperpixels.mat');

observations = dir(['../data/Dataset',num2str(dataset),'/gaze-measurements/*.csv']);
for ii = 1:length(observations)
    assembleTrainingDataSuperpixels(dataset,['trainingSmallSuperpixelsCoocc_new',num2str(ii),'.mat'],observations(ii).name);
end

% assembleReferenceTrainingDataSuperpixels(dataset,'trainingSmallSuperpixelsCOOCCnew_onePositivePerFrame-0_5.mat','../data/Dataset8/ground_truth-frames/',true);
% assembleTrainingDataPatches(dataset,'trainingPatches1.mat');

%% 5) train classifier
classifier = 'pu_grad_boost';
model = trainClassifier(dataset, classifier, 'trainingSuperpixelsColorReference-0_5');

%% 6) test classifier
test_frames = [139:10:229];
testSuperpixelClassifier(model, dataset, test_frames, classifier,'small-superpixels-coocc-descriptors_new/');
% testPatchClassifier(model,dataset,test_frames, classifier);