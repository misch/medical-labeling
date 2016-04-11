clear;

%%
%rng('default');

nbTrainSamples = 80;
nbRounds       = 50;

mu1a = [2 3];   Sigma1a = [.7 .2; .2 .5];
mu1b = [4.5 2]; Sigma1b = [.2 0; 0 .2];
r1a  = mvnrnd(mu1a, Sigma1a, nbTrainSamples/2);
r1b  = mvnrnd(mu1b, Sigma1b, nbTrainSamples/2);
r1   = [r1a;r1b];
mu2  = [2 1.5]; Sigma2 = [.6 .1; .1 .7];
r2   = mvnrnd(mu2, Sigma2, nbTrainSamples);

trainData  = [r1;r2];

pP         = 0.5*(mvnpdf(trainData,mu1a,Sigma1a) + mvnpdf(trainData,mu1b,Sigma1b));
pN         = mvnpdf(trainData,mu2,Sigma2);
ProbWeight = pP ./ (pP + pN);

rnP        = randperm(nbTrainSamples);
PIndex     = rnP(1:nbTrainSamples-79);

true_trainLabel = [ones(nbTrainSamples,1) ; -ones(nbTrainSamples,1)];

% Compute PU-labels: only a few are positive, everything else unlabeled
pu_trainLabel = [zeros(nbTrainSamples,1) ; zeros(nbTrainSamples,1) ];
pu_trainLabel(PIndex) = 1;

% Compute labels if we were to assume Prob value.
Uindex         = find(pu_trainLabel==0);
prob_trainLabel    = pu_trainLabel;
prob_trainLabel(Uindex) = 2*(ProbWeight(Uindex) > 0.5)-1; % set labels for U set.

% Compute labels as few positives and everything else negative
observed_vs_unobserved_trainLabel = pu_trainLabel;
observed_vs_unobserved_trainLabel(observed_vs_unobserved_trainLabel == 0) = -1;

%%

subplot(3,1,1);
plot(r1(:,1),r1(:,2),'o','MarkerSize',12);
hold on;
plot(r2(:,1),r2(:,2),'r+','MarkerSize',12);
axis([0,6,0,4.5]);
xlabel('feature1','FontSize',18,'FontWeight','bold');
ylabel('feature2','FontSize',18,'FontWeight','bold');
title('Train Data','FontSize',16,'FontWeight','bold');
grid on;
hold off;
set(gcf,'color','w');
%%
subplot(3,1,2);
plot(r1(PIndex,1),r1(PIndex,2),'o','MarkerSize',12,'MarkerFaceColor','b');
grid on;
axis([0,6,0,4.5]);
hold on;
for vv=1:nbTrainSamples*2   
    if ProbWeight(vv) >0.5
        plot(trainData(vv,1),trainData(vv,2),'go','MarkerSize',round(12*ProbWeight(vv)));
    else
        plot(trainData(vv,1),trainData(vv,2),'ro','MarkerSize',round(12*(1-ProbWeight(vv))));
    end
end
title('Probability Weights', 'FontSize',16,'FontWeight','bold');
xlabel('feature1','FontSize',18,'FontWeight','bold');
ylabel('feature2','FontSize',18,'FontWeight','bold');
hold off;

%%
[classif,sInfo]= learnPuboost(trainData,pu_trainLabel,ProbWeight,nbRounds);

%%
[classif_Trad,sInfo_Trad]= learnPuboost(trainData,prob_trainLabel,ProbWeight,nbRounds);

%%

if 1
plotClassifierBoundary(45,60,classif)
end

%%

if 1
nbTestSamples = 500;

figure(2);
mu1 = [2 3]; Sigma1 = [.7 .2; .2 .5];
r1a = mvnrnd(mu1, Sigma1, nbTestSamples/2);
mu1 = [4.5 2]; Sigma1 = [.2 0; 0 .2];
r1b = mvnrnd(mu1, Sigma1, nbTestSamples/2);
r1  = [r1a;r1b];
plot(r1(:,1),r1(:,2),'o','MarkerSize',12);
hold on;
mu2 = [2 1.5]; Sigma2 = [.6 .1; .1 .7];
r2 = mvnrnd(mu2, Sigma2, nbTestSamples);
plot(r2(:,1),r2(:,2),'r+','MarkerSize',12);
xlabel('feature1','FontSize',18,'FontWeight','bold');
ylabel('feature2','FontSize',18,'FontWeight','bold');
title('Test Data','FontSize',16,'FontWeight','bold');
grid on;
hold off;

testData  = [r1;r2];
testLabel = [ones(nbTestSamples,1) ; -1*ones(nbTestSamples,1) ];
set(gcf,'color','w');
%export_fig('figs/testData.pdf',gcf);

%%
figure(3);
nbRoundsTest = [nbRounds];
scores1      = zeros(size(testData,1),length(nbRoundsTest));
scores2      = zeros(size(testData,1),length(nbRoundsTest));

for nbR = 1:length(nbRoundsTest)
    
    nbRS = nbRoundsTest(nbR);
    for m=1:nbRS
        scores1(:,nbR)  = scores1(:,nbR) + classif{m}.alpha.*evalWL(classif{m}.wl,testData);
        scores2(:,nbR)  = scores2(:,nbR) + classif_Trad{m}.alpha.*evalWL(classif_Trad{m}.wl,testData);
    end
    
    [X1{nbR},Y1{nbR},T1,AUC1{nbR}] = perfcurve(testLabel, scores1(:,nbR),1);
    [X2{nbR},Y2{nbR},T2,AUC2{nbR}] = perfcurve(testLabel, scores2(:,nbR),1);
    stc{nbR} = num2str(nbRS);
    
end


thetaIX      = round([.25 .5 .75].*length(T1));
thetas       = T1(thetaIX);

hold on; plot(X1{1},Y1{1},'LineWidth',2);
% plot(X1{1}(thetaIX),Y1{1}(thetaIX),'ko','MarkerSize',15);
plot(X2{1},Y2{1},'r','LineWidth',2);
% plot(X2{1}(thetaIX),Y2{1}(thetaIX),'ro','MarkerSize',15);
legend(stc);
grid on;
hold off;
legend(sprintf('P-U Expected Exponential Loss = %f',AUC1{nbR}),...
       sprintf('Exponential Loss = %f',AUC2{nbR}),'Location','Southeast');

xlabel('False Positive Rate','FontSize',18,'FontWeight','bold');
ylabel('True Positive Rate','FontSize',18,'FontWeight','bold');
title('ROC curve','FontSize',18,'FontWeight','bold');
set(gcf,'color','w');
%export_fig('figs/ROC.pdf',gcf);


Ntest = size(scores1(:,nbR),1);
[~,idx] = sort(scores1(:,nbR),'descend');
sorted_test_labels = testLabel(idx);
positives = sorted_test_labels == 1;

% Precision-Recall-curve (PR)
% Precision: TP / (TP + FP) = TP/#{all predicted positives}
% What fraction of the predicted positives are actually positive?
precision = cumsum(positives)./(1:Ntest)'; % is less than 1 if the number of (actual) positives are found (hopefully, recall is 1 then)

% Recall = TPR (true positive rate) = TP / (TP + FN) = TP/#{positives} 
% How many of the positive test labels are actually found?
recall = cumsum(positives)/sum(positives); % is less than 1 if not yet all points are considered (hopefully, precision is 1 then)

figure(4);
plot(recall,precision,'LineWidth',2);
axis( [0 1 0 1] );
title('PR curve','FontSize',18,'FontWeight','bold');
xlabel('Recall','FontSize',18,'FontWeight','bold');
ylabel('Precision','FontSize',18,'FontWeight','bold');

%%

if 0
figure(50);
hist([scores(1:nbTestSamples,nbR),scores(nbTestSamples+1:end,nbR)]);
hleg = legend('Positive','Negative');
set(hleg,'FontSize',14,'FontWeight','bold');
title('Distribution of Test scores','FontSize',16,'FontWeight','bold');
xlabel('Classifier Response, f(x)','FontSize',16,'FontWeight','bold');
grid on;
set(gcf,'color','w');
%export_fig('figs/responseHist.pdf',gcf);
end

%%

if 0
for tt=1:length(thetas)
    CL  = (2*( scores(:,nbR) > thetas(tt) ) - 1);
    mis = abs(CL-testLabel) > 0;
    misP = mis(1:nbTestSamples);
    misN = mis(nbTestSamples+1:end);
    figure((50+tt));
    plot(r1(:,1),r1(:,2),'o','MarkerSize',12);hold on;
    plot(r2(:,1),r2(:,2),'rs','MarkerSize',12);
    plot(r1(misP,1),r1(misP,2),'o','MarkerFaceColor','b','MarkerSize',12);
    plot(r2(misN,1),r2(misN,2),'rs','MarkerFaceColor','r','MarkerSize',12);
    xlabel('Patch Intensity Average','FontSize',16,'FontWeight','bold');
    ylabel('Patch Intensity variance','FontSize',16,'FontWeight','bold');
    title(sprintf('Classification Results Theta = %f',thetas(tt)),'FontSize',16,'FontWeight','bold');
    grid on;
    set(gcf,'color','w');
    %export_fig(sprintf('figs/testError_%03d.pdf',tt),gcf);
end
end


end