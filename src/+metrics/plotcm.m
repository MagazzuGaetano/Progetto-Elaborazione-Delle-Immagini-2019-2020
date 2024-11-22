function [] = plotcm(train, test)
%PLOTCM mostra le confusion matrix di train e test

figure;

confusionchart(train.labels, train.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];


[~, F, Recall, Precision] = metrics.cmetrics(train.labels, train.predicted, classes);
title("Train F1: " + F + " Recall: " + Recall + " Precision: " + Precision);

figure;

confusionchart(test.labels, test.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

[~, F, Recall, Precision] = metrics.cmetrics(test.labels, test.predicted, classes);
title("Test F1: " + F + " Recall: " + Recall + " Precision: " + Precision);
end
