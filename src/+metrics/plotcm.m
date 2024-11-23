function plotcm(data, classes, fig)
%PLOTCM Plot confusion matrix of train and test.

if ~exist('fig', 'var')
    fig = figure();
end

confusionchart(data.labels, data.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

[~, F, Recall, Precision] = metrics.cmetrics(data.labels, data.predicted, classes);

title("F1: " + round(F, 2) + " Recall: " + round(Recall, 2) + " Precision: " + round(Precision, 2));

end
