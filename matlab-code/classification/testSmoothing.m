% test smoothing
data = [    0.9 1; 1 1; 1 1.1;...
            2 2; 2 2.2; 2 2.12;...
            1.9 1.9];
        
labels = [1 0 NaN NaN 0 1 1]';

mu = 0.1;   

smoothedLabels = smoothFrameLabels(data,labels,mu);


subplot(1,2,1);
scatter(data(:,1),data(:,2),[],[labels <= 0, labels > 0, zeros(length(labels),1)],'filled'); axis([0 3 0 3]);
title('original labels');

subplot(1,2,2);
scatter(data(:,1),data(:,2),[],[smoothedLabels<=0, smoothedLabels>0, zeros(length(labels),1)],'filled'); axis([0 3 0 3]);
title(sprintf('smoothed labels (mu = %g)',mu));