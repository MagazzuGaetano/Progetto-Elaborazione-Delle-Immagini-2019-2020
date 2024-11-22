function [Accuracy, FScore, TPR, PPV, recallRigetto] = metrics(gt, predicted, classes)
%METRICS calcola le metriche per il classificatore dei cioccolatini

cm = confusionmat(gt, predicted, 'order', classes);

num_labels = length(unique(gt));
for i = 1:num_labels
    tp_m = diag(cm);
    TP = tp_m(i);
    FP = sum(cm(:, i), 1) - TP;
    FN = sum(cm(i, :), 2) - TP;
    TN = sum(cm(:)) - TP - FP - FN;

    Accuracy = (TP+TN)./(TP+FP+TN+FN);

    TPR = TP./(TP + FN);%tp/actual positive  RECALL SENSITIVITY
    if isnan(TPR)
        TPR = 0;
    end
    PPV = TP./ (TP + FP); % tp / predicted positive PRECISION
    if isnan(PPV)
        PPV = 0;
    end
    TNR = TN./ (TN+FP); %tn/ actual negative  SPECIFICITY
    if isnan(TNR)
        TNR = 0;
    end
    FPR = FP./ (TN+FP);
    if isnan(FPR)
        FPR = 0;
    end
    FScore = (2*(PPV * TPR)) / (PPV+TPR);

    if isnan(FScore)
        FScore = 0;
    end
    
    recallRigetto = 0;
end

end
