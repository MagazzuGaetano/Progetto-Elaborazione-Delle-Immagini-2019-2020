% TRAIN CHOCO 
% Train a SVM classifier to predict the chocolate type based on image features. 
% The model is optimized through hyperparameter tuning and cross-validation.

addpath(genpath("src"));
rng(42);

classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];

trainPath = fullfile(pwd, "Data", "Train", "Chocolates");
testPath = fullfile(pwd, "Data", "Test", "Chocolates");

% feature extraction
[yTrain, xTrain] = generatedataset(convertStringsToChars(trainPath), classes);
[yTest, xTest] = generatedataset(convertStringsToChars(testPath), classes);

% [yTrain, xTrain, ~, ~] = generatedeepdataset(trainPath, false, 0);
% [yTest, xTest, ~, ~] = generatedeepdataset(testPath, false, 0);

% standardize data
trainMean = mean(xTrain);
trainStd = std(xTrain);

xTrain = (xTrain - trainMean) ./ trainStd;
xTest = (xTest - trainMean) ./ trainStd;

% apply PCA
[coeff,xTrain,~,~,explained,mu] = pca(xTrain);
idx = find(cumsum(explained) > 95, 1);
xTrain = xTrain(:,1:idx);
xTest = (xTest-mu)*coeff(:,1:idx);

disp(size(xTrain));
disp('train start');

% train classifier
tSvm = templateSVM('Standardize', false, 'KernelFunction', 'linear');
model = fitcecoc(xTrain, yTrain, ...
    'Learners', tSvm, ...
    'Coding', 'onevsone', ...
    'HyperparameterOptimizationOptions', struct('KFold', 10), ...
    'OptimizeHyperparameters', 'BoxConstraint');

chocoClassifier.model = model;
chocoClassifier.mean = trainMean;
chocoClassifier.std = trainStd;
chocoClassifier.pcaMu = mu;
chocoClassifier.pcaCoeff = coeff(:,1:idx);

save(fullfile("Data", "choco-classifier.mat"), "chocoClassifier");
disp('train end');

% predictions
trPredicted = {};
trPredicted.predicted = string(predict(model, xTrain));
trPredicted.labels = string(yTrain);

tsPredicted = {};
tsPredicted.predicted = string(predict(model, xTest));
tsPredicted.labels = string(yTest);

% plot confusion matrices
classes = unique(trPredicted.labels);
metrics.plotcm(trPredicted, classes, figure("Name", "Train"));
metrics.plotcm(tsPredicted, classes, figure("Name", "Test"));


function [labels, features] = generatedataset(dataPath, classes)
% GENERATEDATASET Generates a dataset by extracting handcrafted features 
% from images in specified class folders and assigning corresponding labels.

labels = [];
features = [];
nClasses = size(classes, 2);

for c = 1 : nClasses
    folderPath = fullfile(dataPath, convertStringsToChars(classes(c)));
    images = utils.getfiles(folderPath);

    for i = 1 : numel(images)
        im = imread(images{i});
        imfeatures = classification.choco.computechocofeatures(im);
        features = [features; imfeatures];
        labels = [labels; classes(c)];
    end
end

end


function [yTrain, xTrain, yVal, xVal] = generatedeepdataset(dataPath, splitData, splitP)
% GENERATEDEEPDATASET Generates a dataset by extracting deep features 
% from images in specified class folders and assigning corresponding labels.

yVal = [];
xVal = [];

net = resnet18;
inputSize = net.Layers(1).InputSize;

imds = imageDatastore(dataPath, "IncludeSubfolders", true, ...
    "FileExtensions", ".jpg", "LabelSource", "foldernames");

if splitData
    [imdsTrain, imdsVal] = splitEachLabel(imds, splitP, 'Exclude', 'Rejection');

    imdsAbnormal = subset(imds, imds.Labels == 'Rejection');

    auimdsTrain = augmentedImageDatastore(inputSize, imdsTrain);
    auimdsVal = augmentedImageDatastore(inputSize, imdsVal);
    auimdsAbnormal = augmentedImageDatastore(inputSize, imdsAbnormal);

    xTrain = activations(net, auimdsTrain, 'pool5', 'OutputAs', 'rows');
    yTrain = imdsTrain.Labels;

    xValNormal = activations(net, auimdsVal, 'pool5', 'OutputAs', 'rows'); 
    xValAbnormal = activations(net, auimdsAbnormal, 'pool5', 'OutputAs', 'rows');
    
    xVal = [xValNormal; xValAbnormal]; 
    yVal = [imdsVal.Labels; imdsAbnormal.Labels];

else
    auimdsTrain = augmentedImageDatastore(inputSize, imds);

    xTrain = activations(net, auimdsTrain, 'pool5', 'OutputAs', 'rows');
    yTrain = imds.Labels;
end

end

