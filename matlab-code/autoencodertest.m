% Autoencoder test

% rng(0,'twister'); % For reproducibility
% n = 1000;
% r = linspace(-10,10,n)';
% x = 1 + r*5e-2 + sin(r)./r + 0.2*randn(n,1);

hiddenSize = 1;

img = imresize(img,[50 63]);

test{1} = img(:,:,1);
test{2} = img(:,:,2);
test{3} = img(:,:,3);

autoenc = trainAutoencoder(test,hiddenSize,...
        'EncoderTransferFunction','satlin',...
        'DecoderTransferFunction','purelin',...
        'L2WeightRegularization',0.01,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.10);
    

%     n = 1000;
% r = sort(-10 + 20*rand(n,1));
% xtest = 1 + r*5e-2 + sin(r)./r + 0.4*randn(n,1);

features = encode(autoenc,img(:,:,1));
% 
% xReconstructed = predict(autoenc,xtest');
% 
% figure;
% plot(xtest,'r.');
% hold on
% plot(xReconstructed,'go');