function [smoothedLabels] = smoothFrameLabels (data, labels, mu)
% This function performs label propagation ("smoothing") according to Zhou
% et al.

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


