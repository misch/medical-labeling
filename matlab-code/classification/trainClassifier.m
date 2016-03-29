function [model] = trainClassifier(dataset, classifier, training_file)
% dataset: a number that indicates what dataset should be considered
% classifier: 'svm' or 'grad_boost'

[dataset_folder] = getDatasetDetails(dataset);

load([dataset_folder, training_file]);

train_data = training_set.data;
train_labels = training_set.labels;

model = 0;

if strcmp(classifier,'svm')
    addpath('../libsvm-3.20/libsvm-3.20/matlab/')
    cross_validation = false;

    if (cross_validation) % Perform cross-validation
        disp('Start cross-validation...');
        [train_data, train_labels] = getFiftyFiftySamples(train_data,train_labels);

        bestacc = 0;
        for log2c = -3:3,
          for log2g = -4:4,
            cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
            cv = libsvmtrain(train_labels, train_data, cmd);
            if (cv >= bestacc),
              bestacc = cv; bestc = 2^log2c; bestg = 2^log2g;
            end
            fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestacc);
          end
        end
    else % Perform real training
        disp('Train SVM classifier...');
%         [train_data, train_labels] = getFiftyFiftySamples(train_data,train_labels);
%         save('matlab.mat','train_data','train_labels');
%         load('matlab.mat');
        model = libsvmtrain(train_labels,train_data,'-t 2 -g 0.0125 -c 0.5');
%         model = fitcsvm(train_data, train_labels,'KernelFunction','RBF','KernelScale','auto');
    end
elseif strcmp(classifier,'grad_boost')
   addpath('../sqb-0.1/build/');
%     [train_data, train_labels] = getFiftyFiftySamples(train_data,train_labels);
   options = struct(   'loss', 'exploss',...
                    'shrinkageFactor', 0.1,...
                    'subsamplingFactor', 0.2,...
                    'maxTreeDepth', uint32(2),...
                    'disableLineSearch', uint32(0),...
                     'mtry',uint32(ceil(sqrt(size(train_data,2)))));
    disp('Train gradient boost classifier...');
    model = SQBMatrixTrain( single(train_data), train_labels, uint32(5000), options);
elseif strcmp(classifier,'pu_grad_boost')
    
    
    s_distances = sqrt(sum((training_set.gaze_position - training_set.median_superpixel_pos).^2,2));
    
    
    positive_idx = training_set.labels == 1;
    positives = training_set.data(positive_idx,:);
    
    % distance to median
%     f_distances = sqrt(sum((training_set.data - repmat(median(positives),size(training_set.data,1),1)).^2,2));
    
    % median of distances
    f_distances = median(pdist2(training_set.data,positives,'cosine'),2);
    
    % minimum of distances
    min_f_distances = min(pdist2(training_set.data,positives,'cosine'),[],2);
    
%     prob = exp(-f_distances/0.15) .* exp(-s_distances/400); % dataset 2
%     prob = exp(-(f_distances)/0.35) .* exp(-s_distances/5); % dataset 7
    prob = exp(-(min_f_distances/max(min_f_distances(:)))/3).*exp(-s_distances/40); % dataset 8

%     train_labels(train_labels == -1) = 0;
%     train_labels(s_distances<30) = 1;

    [model,info] = learnPuboost(train_data,train_labels, prob,500);
    figure(); plot(1:length(info.LOSS),info.LOSS); title('loss');
    
else
    disp('SVM and Gradient Boost are currently the only available classifiers.')
end
