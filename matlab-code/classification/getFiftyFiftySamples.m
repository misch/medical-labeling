function [data, labels] = getFiftyFiftySamples(train_data, train_labels)

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