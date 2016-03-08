res_fold = '../../results/comparisons/Dataset2/';
    figure;
    load([res_fold,'PRpu400']);
    plot(recall, precision);
    
    load([res_fold,'PR_probSpatialColor_featureSuperpixelCoocc']);
    hold on; plot(recall,precision);
    
    load([res_fold,'PRclassicalRS']);
    hold on; plot(recall,precision);
    
    load([res_fold,'PRclassicalCBexploss']);
    hold on; plot(recall,precision);
    
    load([res_fold,'PRclassicalCBsquaredloss']);
    hold on; plot(recall,precision);
    
    axis( [0 1 0 1] );
    title('precision-recall curve');
    xlabel('Recall');
    ylabel('Precision');
%     legend('p = exp^{-dist/15} (--> tolerance = 10.4)','p = exp^{-dist/28} (--> tolerance = 19.4)','p = exp^{-dist/72} (--> tolerance = 49.9)');
    legend( 'PU prob. based on spatial & feature distance, feat. = color-relations',...
            'PU prob. based on spatial and color-relation distance, feat. = [hist10,mean,var,co-occ.]',...
            'classical (RS implementation - exploss)',...
            'classical (CB implementation exploss)',...
            'classical (CB implementation squaredloss)');

    %%
    

% Receiver Operating Characteristic curve (ROC)
% FPR = FP / (FP + TN) = FP/#{negatives}

    figure;
%     load('ROC300');
%     hold on; plot(false_positive_rate,recall);

    load([res_fold,'ROCpu400']);
    plot(false_positive_rate,recall);
    
    load([res_fold,'ROC_probSpatialColor_featureSuperpixelCoocc']);
    hold on; plot(false_positive_rate,recall);
    
    load([res_fold,'ROCclassicalRS']);
    hold on; plot(false_positive_rate,recall);
    
    load([res_fold,'ROCclassicalCBexploss']);
    hold on; plot(false_positive_rate,recall);
    
    load([res_fold,'ROCclassicalCBsquaredloss']);
    hold on; plot(false_positive_rate,recall);

    axis( [0 1 0 1] );
    title('ROC curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate (Recall)');
%     legend('p = exp^{-dist/15} (--> tolerance = 10.4)','p = exp^{-dist/28} (--> tolerance = 19.4)','p = exp^{-dist/72} (--> tolerance = 49.9)');
    legend( 'PU prob. based on spatial & feature distance, feat. = color-relations',...
            'PU prob. based on spatial and color-relation distance, feat. = [hist10,mean,var,co-occ.]',...
            'classical (RS implementation - exploss)',...
            'classical (CB implementation exploss)',...
            'classical (CB implementation squaredloss)');