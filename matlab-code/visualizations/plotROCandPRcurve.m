% 1st, load ROC.mat and PR.mat
auc = sum(recall)/length(recall);

%% Plot PR curve
f_pr = figure(1);
hold on; plot(recall(1:10:end),precision(1:10:end),'LineWidth',2);
axis( [0 1 0 1] );
xlabel('Recall','FontSize',18,'FontWeight','bold');
ylabel('Precision','FontSize',18,'FontWeight','bold');
title('PR curve','FontSize',18,'FontWeight','bold');

%% Plot ROC curve
f_roc = figure(2);
hold on;
plot(false_positive_rate(1:10:end),recall(1:10:end),'LineWidth',2);
axis( [0 1 0 1] );
xlabel('False Positive Rate','FontSize',18,'FontWeight','bold');
ylabel('True Positive Rate','FontSize',18,'FontWeight','bold');

le = legend(sprintf('reference: exploss with ground truth labels (AUC = %f)',auc),...
            'Location','southeast');
le.FontSize = 18;

title('ROC curve','FontSize',18,'FontWeight','bold');