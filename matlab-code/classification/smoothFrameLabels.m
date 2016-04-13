function [smoothedLabels] = smoothFrameLabels (data, labels, mu)
% This function performs the regularized version of label ("smoothing") according to Zhou
% et al. (http://papers.nips.cc/paper/2506-learning-with-local-and-global-consistency.pdf)
%
% input:
% data: a MxN matrix containing M N-dimensional samples
% labels: binary labels for the input samples
% mu: regularization parameter
%
% can be used for example in testSuperpixelClassifier to smooth the obtained resulting labels: 
%   smoothed_labels = smoothFrameLabels(classifier_results.input, classifier_results.scores>0,0.56);
%
% testSmoothing.m shows an example of how to use the function

n = size(data,1);
c = size(data,2);

% build Y
Y = [labels <= 0, labels > 0];

% build W
sigma = 0.5;
W = exp(-dist(data')./(2*sigma^2)) .* (dist(data')>0);

% build D
D = diag(sum(W,2));
D_part = inv(sqrt(D));

% build S
S = D_part * W * D_part;

% Get F*
% alpha = 0.9;
alpha = 1/(1+mu);
beta = mu/(mu+1);
F_star = beta*inv(eye(n) - alpha * S) * Y;

[~, max_idx] = max(F_star');
smoothedLabels = (max_idx - 1)';


