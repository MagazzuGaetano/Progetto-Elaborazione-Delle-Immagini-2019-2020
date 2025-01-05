function [accuracy, f1, tpr, ppv] = cmetrics(gt, predicted, classes)
%CMETRICS Compute classification metrics (accuracy, f1, recall, precision)

cm = confusionmat(gt, predicted, 'order', classes);

num_labels = length(unique(gt));

f1 = zeros(1, num_labels);   % Preallocate F1 for each class
tpr = zeros(1, num_labels);  % Preallocate TPR for each class
ppv = zeros(1, num_labels);  % Preallocate PPV for each class
acc = zeros(1, num_labels);  % Preallocate Accuracy for each class

for i = 1:num_labels
    tp = cm(i, i);
    fp = sum(cm(:, i), 1) - tp;
    fn = sum(cm(i, :), 2) - tp;
    tn = sum(cm(:)) - tp - fp - fn;

    acc(i) = (tp + tn) ./ (tp + fp + tn + fn);

    % true positive value (recall)
    tpr(i) = tp ./ (tp + fn);
    if isnan(tpr(i))
        tpr(i) = 0;
    end

    % predicted positive value (precision)
    ppv(i) = tp ./ (tp + fp);
    if isnan(ppv(i))
        ppv(i) = 0;
    end

    % F1 score
    f1(i) = (2*(ppv(i) * tpr(i))) / (ppv(i)+tpr(i));
    if isnan(f1(i))
        f1(i) = 0;
    end
end

accuracy = mean(acc);
f1 = mean(f1);
tpr = mean(tpr);
ppv = mean(ppv);

end
