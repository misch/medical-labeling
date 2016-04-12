function [data, labels] = getFiftyFiftySamples(train_data, train_labels)
% GETFIFTYFIFTYSAMPLES get an equal amount of positive and negative training
% 
% Given many negatives and only a few positives, this function returns all
% the positives and an equal amount of random negatives.
%
% The function would be used mostly for cross-validation, as otherwise a
% high cross-validation accuracy might not be meaningful (assigning only
% negative labels yields the highest accuracy)
    positive_train_data = train_data(train_labels==1,:);
    negative_train_data = train_data(train_labels==-1,:);

    shuffle_idx = randperm(size(negative_train_data,1));
    rand_neg = negative_train_data(shuffle_idx,:);
    negative_train_data = rand_neg(1:size(positive_train_data,1),:);

    train_data = cat(1,positive_train_data,negative_train_data);
    train_labels = [ones(size(positive_train_data,1),1) ; -1 *ones(size(negative_train_data,1),1)];

    shuffle_idx = randperm(size(train_data,1));
    data = train_data(shuffle_idx,:);
    labels = train_labels(shuffle_idx);