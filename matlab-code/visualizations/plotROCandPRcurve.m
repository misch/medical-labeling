% 1st, load ROC.mat and PR.mat

%% Plot ROC curve
f_pr = figure(1);
hold on; plot(recall,precision,'LineWidth',2);
axis( [0 1 0 1] );
xlabel('Recall','FontSize',16);
ylabel('Precision','FontSize',16);
% le = legend('grad-boost','pu-grad-boost','svm','Location','south');
% le.FontSize = 16;
%% Plot PR curve
f_roc = figure(2);
hold on;
plot(false_positive_rate,recall,'LineWidth',2);
axis( [0 1 0 1] );
xlabel('False Positive Rate','FontSize',16);
ylabel('True Positive Rate','FontSize',16);
% le = legend('grad-boost','pu-grad-boost','svm','Location','south');
% le.FontSize = 16;