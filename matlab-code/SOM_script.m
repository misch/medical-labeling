%% Define data paths and actions
addpath('../libsvm')

dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];

load([dataset_folder, 'processed_ROIs']);
normalized_data = normalizeData(processed_ROIs);


x = normalized_data;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = selforgmap();

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x);

% Test the Network
y = net(x);

% todo: Necessary with SOM?
    performance = perform(net,t,y)
    tind = vec2ind(t);
    yind = vec2ind(y);

    percentErrors = sum(tind ~= yind)/numel(tind);


% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, ploterrhist(e)
figure, plotconfusion(t,y)
figure, plotroc(t,y)

