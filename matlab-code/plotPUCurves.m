    figure;
    load('PR15');
    plot(recall,precision);
    load('PR28');
    hold on; plot(recall,precision);
    load('PR72');
    hold on; plot(recall, precision);
    axis( [0 1 0 1] );
    title('precision-recall curve');
    xlabel('Recall');
    ylabel('Precision');
    legend('p = exp^{-dist/15} (--> tolerance = 10.4)','p = exp^{-dist/28} (--> tolerance = 19.4)','p = exp^{-dist/72} (--> tolerance = 49.9)');

    %%
    

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}

    figure;
    load('ROC15');
    plot(false_positive_rate,recall);
    load('ROC28');
    hold on; plot(false_positive_rate,recall);
    load('ROC72');
    hold on; plot(false_positive_rate,recall);
    axis( [0 1 0 1] );
    title('ROC curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate (Recall)');
    legend('p = exp^{-dist/15} (--> tolerance = 10.4)','p = exp^{-dist/28} (--> tolerance = 19.4)','p = exp^{-dist/72} (--> tolerance = 49.9)');