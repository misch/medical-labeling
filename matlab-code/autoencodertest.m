% Autoencoder test

hiddenSize = 1;


% test = cell array containing many padded superpixels

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