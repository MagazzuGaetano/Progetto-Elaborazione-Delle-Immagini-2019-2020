% MAIN
% This script checks the compliance of chocolate boxes and visualizes errors.

addpath(genpath("src"));

load(fullfile("Data", "shape-classifier.mat"), "shapeClassifier");
load(fullfile("Data", "choco-classifier.mat"), "chocoClassifier");

%[images, labels] = utils.readlabels(fullfile("Data", "lbl_conformità.csv"), fullfile("Data", "Acquisizioni"));
[images, labels] = utils.readlabels(fullfile("Data", "test.csv"), fullfile("Data", "Acquisizioni"));

classes = ["non_conforme", "conforme"];

predicted = strings(numel(images), 1);
for i = 1:numel(images)

    im = imread(images{i});

    [isCompliant, errors] = pipeline.checkbox(im, shapeClassifier, chocoClassifier);

    if isCompliant
        predicted(i) = "conforme";
    else
        predicted(i) = "non_conforme";
    end

    disp("Immagine " + i + " pred: " + predicted(i) + " gt: " + labels(i));

    if ~double(isCompliant)
        figure('Name', "Immagine " + i + " pred: " + predicted(i) + " gt: " + labels(i));
        visualization.showresults(im, errors, false);
        pause(3);
        close;
    end
end

[~, f, rec, pre] = metrics.cmetrics(labels, predicted, classes);

disp("\nF1: " + f);
disp("Recall: " + rec);
disp("Precision: " + pre);

figure('Name', 'Classification Results');
confusionchart(labels, predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');
