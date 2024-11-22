function [tracc, tsacc] = confchart(train, test)
%CONFCHART mostra le confusion matrix di train e test

trcm = confusionchart(train.labels, train.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

%tracc = sum(diag(trcm.NormalizedValues))/numel(train.labels);
classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];
% classes = [1,2,3,4];

[~, F, Recall, Precision, ~] = classification.metrics(train.labels, train.predicted, classes);
title("Train F1: " + F + " Recall: " + Recall + " Precision: " + Precision);

figure;

tscm = confusionchart(test.labels, test.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

%tsacc = sum(diag(tscm.NormalizedValues))/numel(test.labels);
[~, F, Recall, Precision, ~] = classification.metrics(test.labels, test.predicted, classes);
title("Test F1: " + F + " Recall: " + Recall + " Precision: " + Precision);
end
