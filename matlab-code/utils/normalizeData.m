function [NormData, mu, sigma] = normalizeData(Data)
% NORMALIZEDATA normalize the input data to zero mean and 1 std

%
% input:
%     Data: the data matrix, each row represents a data point.
%
% output:
%     NormData: the normalized data matrix.
% 

X = Data;

%% Compute mean
mu = mean(Data(:));

%% Replace each x(i) with x(i) - mu
%  This moves the "center" of the data to the origin
X = X - mu;

%% Instead of manually compute the variance and then take the root of it,
%  just directly use the built in function std that computes the standard deviation
sigma = std(X(:));

%% Normalize 
%  This ensures that the data lies within a box of radius 1
NormData = (X./sigma);