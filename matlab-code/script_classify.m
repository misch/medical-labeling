%% Define data paths and actions
dataset = 8;
[dataset_folder, frames_dir, ~ , frame_height, frame_width, num_frames] = getDatasetDetails(dataset);

if (exist([dataset_folder,'ground_truth-frames'],'dir') > 0)
    ground_truth_dir = [dataset_folder,'ground_truth-frames/'];
else
    ground_truth_dir = 0; 
end

load([dataset_folder, 'processed_ROIs']);


%% get or create test set
frame_percentage = 0.1; % rough percentage of #test-frames

create_new_test_set = false;

if create_new_test_set
    [test_data, test_labels] = createTestData(frames_dir,frame_percentage,ground_truth_dir);
else
%     frame_no = '00428'; % for dataset 5
%     frame_no = '00642'; % for dataset 2
    frame_no = '00189'; % for dataset 8
    data_id = fopen([dataset_folder,'test_data_frame_',frame_no,'.dat']);
    test_data = fread(data_id,'double');
    fclose(data_id);
    
    labels_id = fopen([dataset_folder,'test_labels_frame_',frame_no,'.dat']);
    test_labels = fread(labels_id,'double');
    fclose(labels_id);
    
    test_data = reshape(test_data,size(test_labels,1),[]);
end

%% normalize data (test and training set together!)
to_normalize = cat(1,processed_ROIs,test_data);
clear test_data;
normalized_data = normalizeData(to_normalize);
clear to_normalize;


%% Train Classifier
train_data = normalized_data(1:size(processed_ROIs,1),:);
train_labels = labels;

classifier = 'grad_boost' % 'svm' or 'grad_boost'

if strcmp(classifier,'svm')
    addpath('../libsvm-3.20/libsvm-3.20/matlab/')
    cross_validation = false;

    if (cross_validation) % Perform cross-validation
        disp('Start cross-validation...');
        [train_data, train_labels] = getFiftyFiftySamples(train_data,train_labels);

        bestacc = 0;
        for log2c = -3:3,
          for log2g = -4:2,
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
        model = libsvmtrain(train_labels,train_data,'-t 2 -g 0.0625 -c 8');
        % model = libsvmtrain(train_labels,train_data,'-s 2 -n 0.001 -c 0.2');
        % model = libsvmtrain(train_labels,train_data,'-s 2');
    end
elseif strcmp(classifier,'grad_boost')
   addpath('../sqb-0.1/build/');
   options = struct(   'loss', 'exploss',...
                    'shrinkageFactor', 0.1,...
                    'subsamplingFactor', 0.5,...
                    'maxTreeDepth', uint32(2),...
                    'disableLineSearch', uint32(0),...
                    'mtry', uint32(ceil(sqrt(size(train_data,2)))));
    disp('Train gradient boost classifier...');
    model = SQBMatrixTrain( single(train_data), train_labels, uint32(10000), options);
else
    disp('SVM and Gradient Boost are currently the only available classifiers.')
end

%% Test SVM
disp('Test Cassifier...');

test_data = normalized_data(size(processed_ROIs,1)+1:size(processed_ROIs,1)+size(test_labels,1),:);

if strcmp(classifier,'svm')
    [predicted_label, accuracy, scores] = libsvmpredict(test_labels, test_data, model);
elseif strcmp(classifier,'grad_boost')
    scores = SQBMatrixPredict(model, single(test_data)); 
    binary_decisions = ((scores >= 0) - 0.5) * 2;
    good = (binary_decisions == test_labels);
    accuracy = 100*sum(good)/length(good);
end


%% Evaluation 
disp('Show performance measures...');
Ntest = size(test_data,1);
[sorted_scores,idx] = sort(scores,'descend');
sorted_test_labels = test_labels(idx);
positives = sorted_test_labels == 1;

% Precision-Recall-curve (PR)

    % Precision: TP / (TP + FP) = TP/#{all predicted positives}
    % What fraction of the predicted positives are actually positive?
    precision = cumsum(positives)./(1:Ntest)'; % is less than 1 if the number of (actual) positives are found (hopefully, recall is 1 then)

    % Recall = TPR (true positive rate) = TP / (TP + FN) = TP/#{positives} 
    % How many of the positive test labels are actually found?
    recall = cumsum(positives)/sum(positives); % is less than 1 if not yet all points are considered (hopefully, precision is 1 then)

    figure;
    plot(recall,precision);
    axis( [0 1 0 1] );
    title('precision-recall curve');
    xlabel('Recall');
    ylabel('Precision');

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}
    false_positive_rate = cumsum(~positives) ./ sum(~positives)';

    figure;
    plot(false_positive_rate,recall);
    axis( [0 1 0 1] );
    title('ROC curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');

% visualize decision_values
file_names = dir([frames_dir, '*.png']);
ref_frame = imread([frames_dir,file_names(1).name]);

height = frame_height - 127;
width = frame_width - 127;

    % Heat map
    figure;
    colormap('hot');   % set colormap
    final_image_decisions = reshape(scores, height, []);
    imagesc(final_image_decisions);        % draw image and scale colormap to values range
    colorbar;          % show color scale

    % Binary decisions
    figure;
    imshow(final_image_decisions>=0);

    % Ground truth
    figure;
    imshow(reshape(test_labels,height,[]));
 
 
