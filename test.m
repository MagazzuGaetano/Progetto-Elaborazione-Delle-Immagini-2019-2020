function test()
addpath(genpath("src"));

load("Data/shape-classifier.mat", "shapeClassifier");
load("Data/choco-classifier.mat", "chocoClassifier");

[images, labels] = utils.readlabels("Data/lbl_conformità.csv", "Data/Acquisizioni/");
%[images, labels] = utils.readlabels("Data/test_labels(conforme).csv", "Data/Test/"); WHY???

predicted = zeros(numel(images), 1, 'single');

for i=1:numel(images)
    disp("Immagine " + i);
    im = imread(images{i});

    [isCompliant, errors] = pipeline.checkbox(im, shapeClassifier, chocoClassifier);
    predicted(i) = isCompliant;

    if isCompliant == false
        figure();

        visualization.showresults(im, errors);

        pause(3);
        close;
    end

end

gt = single(labels == "conforme");
classes = [0, 1];
[~, f, rec, pre] = metrics.cmetrics(gt, predicted, classes);

disp("\nF1: " + f);
disp("Recall: " + rec);
disp("Precision: " + pre);

figure;
confusionchart(gt, predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');

end
