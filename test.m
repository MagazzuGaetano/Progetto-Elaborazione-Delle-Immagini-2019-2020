addpath(genpath("src"));

[images, labels] = utils.readlabels("Data/lbl_conformità.csv", "Data/Acquisizioni/");
%[images, labels] = utils.readlabels("Data/test_labels(conforme).csv", "Data/Test/");

predicted = zeros(64, 1, 'single');
for i=1:numel(images)
    disp("Immagine " + i);
    im = imread(images{i});
    predicted(i) = pipeline.checkbox(im);
end

gt = single(labels == "conforme");
classes = [0, 1];
[~, f, rec, pre] = metrics.cmetrics(gt, predicted, classes);

disp("F1: " + f);
disp("Recall: " + rec);
disp("Precision: " + pre);

confusionchart(gt, predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');
