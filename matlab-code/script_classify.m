%% Define data paths and actions
addpath('../libsvm-3.20/libsvm-3.20/matlab/')

dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];
frames_dir = [dataset_folder,'input-frames/'];
ground_truth_dir = [dataset_folder,'ground_truth-frames/'];

load([dataset_folder, 'processed_ROIs']);
[normalized_data, mu, sigma] = normalizeData(processed_ROIs);

% processed_positives = normalized_data(labels == 1,:);

%% Randomly select train and test data
% testPercent = 20;
% 
% test_indices = rand(1,size(normalized_data,1)) <= testPercent/100;
% train_indices = ~test_indices;
% 
% train_data = processed_positives;
% train_labels = labels(labels == 1);

% test_data = normalized_data(test_indices,:);
% test_labels = labels(test_indices);

train_data = normalized_data;
train_labels = labels;


%% get or create test set
frame_percentage = 0.1; % rough amount of test-frames

create_new_test_set = false;

if create_new_test_set
    [test_data, test_labels] = createTestData(frames_dir,frame_percentage,ground_truth_dir,'test_data','test_labels');
else
    frame_no = '00642';
    data_id = fopen(['test_data_frame_',frame_no,'.dat']);
    test_data = fread(data_id,'double');
    fclose(data_id);
    
    labels_id = fopen(['test_labels_frame_',frame_no,'.dat']);
    test_labels = fread(labels_id,'double');
    fclose(labels_id);
    
    test_data = reshape(test_data,size(test_labels,1),[]);
end

test_data = normalizeData(test_data);

%% Train SVM
disp('Train SVM classifier...');
% model = libsvmtrain(train_labels, train_data,'-t 2 -g 0.0625 -c 0.05');

bestcv = 0;
for log2c = -3:3,
  for log2g = -4:4,
    cmd = ['-v 10 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(train_labels, train_data, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end



%% Show some positives
% positives = (test_labels == 1);
% positives = test_data(positives,:);
% 
% figure();
% for i = 1:25
%     subplot(5,5,i);
%     imshow(reshape(positives(i+10000,:),32,[])+0.5);
% end

%%
disp('Test SVM classifier...');
[predicted_label, accuracy, decision_values] = libsvmpredict(test_labels, test_data, model);


%% Evaluation 
disp('Show performance measures...');
Ntest = size(test_data,1);
[sorted_scores,idx] = sort(decision_values,'descend');
sorted_test_labels = test_labels(idx);
positives = sorted_test_labels == 1;

% Precision-Recall-curve (PR)

% Precision: TP / (TP + FP) = TP/#{all predicted positives}
% What fraction of the predicted positives are actually positive?
precision = cumsum(positives)./(1:Ntest)'; % is less than 1 if the number of (actual) positives are found (hopefully, recall is 1 then)

% Recall = TPR (true positive rate) = TP / (TP + FN) = TP/#{positives} 
% How many of the positive test labels are actually found?
recall = cumsum(positives)/sum(positives); % is less than 1 if not yet all points are considered (hopefully, precision is 1 then)

figure(4);
plot(recall,precision);
axis( [0 1 0 1] );
title('precision-recall curve');
xlabel('Recall');
ylabel('Precision');

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}
false_positive_rate = cumsum(~positives) ./ sum(~positives)';

figure(5);
plot(false_positive_rate,recall);
axis( [0 1 0 1] );
title('ROC curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');

% visualize decision_values
file_names = dir([frames_dir, '*.png']);
ref_frame = imread([frames_dir,file_names(1).name]);

height = size(ref_frame,1) - 127;
width = size(ref_frame,2) - 127;

figure(6);
imshow(reshape(decision_values, height, []), [min(decision_values), max(decision_values)]);
title(['max: ',num2str(max(decision_values)),' / min: ', num2str(min(decision_values))]);

