function trainchoco()
%TRAINCHOCO Train a SVM classifier to predict the chocolate type.

addpath(genpath("src"));

classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];

% calculate features
[yTrain, xTrain] = computefeatures('Data/Train/Chocolates/', classes);
[yTest, xTest] = computefeatures('Data/Test/Chocolates/', classes);

% standardize data
trainMean = mean(xTrain);
trainStd = std(xTrain);
xTrain = (xTrain - trainMean) ./ trainStd;
xTest = (xTest - trainMean) ./ trainStd;

disp('train start');

% train classifier
model = fitcecoc(xTrain, yTrain, ...
    'Learners', templateSVM('Standardize', false, 'KernelFunction', 'linear'), ...
    'HyperparameterOptimizationOptions', struct('KFold', 10), ...
    'OptimizeHyperparameters', 'auto');

chocoClassifier.model = model;
chocoClassifier.mean = trainMean;
chocoClassifier.std = trainStd;

save("Data/choco-classifier.mat", "chocoClassifier");

disp('train end');

% predictions
trPredicted = predict(model, xTrain);
train.predicted = convertCharsToStrings(trPredicted);
train.labels = yTrain;

tsPredicted = predict(model, xTest);
test.predicted = convertCharsToStrings(tsPredicted);
test.labels = yTest;

% plot confusion matrices
metrics.plotcm(train, classes, figure("Name", "Train"));
metrics.plotcm(test, classes, figure("Name", "Test"));

%showmistakes(test, classes);

end


function [labels, features] = computefeatures(dataPath, classes)
%COMPUTEFEATURES Compute features from a folder divided by classes.

labels = [];
features = [];
nClasses = size(classes, 2);

for c = 1 : nClasses
    images = utils.getfiles([dataPath convertStringsToChars(classes(c)) '/']);
    nImages = numel(images);

    for i = 1 : nImages
        im = imread(images{i});
        imfeatures = classification.choco.computechocofeatures(im);

        features = [features; imfeatures];
        labels = [labels; classes(c)];
    end
end

end

function showmistakes(test, classes)
%SHOWMISTAKES Show images with wrong predictions.

images = utils.readimages('Data/Test/Chocolates/', classes);
idx = test.labels ~= test.predicted;
for j = 1:numel(idx)
    if idx(j) == 0
        continue
    end

    disp(convertStringsToChars(test.predicted(j)));

    im = images{j, 1};
    im = im2double(im);
    figure();
    imshow(im);
end

end