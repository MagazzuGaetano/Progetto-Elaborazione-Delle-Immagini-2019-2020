clc;
close all;
clear all;

classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];

% calculate features
[y_train, X_train] = calc_features('Data/Train/Chocolates/', classes);
[y_test, X_test] = calc_features('Data/Test/Chocolates/', classes);

% normalize data
train_mean = mean(X_train);
train_std = std(X_train);
X_train = (X_train - train_mean) ./ train_std;

save("Data/features.mat", "X_train");
save("Data/mean_std.mat", "train_mean", "train_std");

X_test = (X_test - train_mean) ./ train_std;

disp('train start');

% train classifier
chococlassifier = fitcecoc(X_train, y_train, ...
    'Learners', 'linear', ...
    'HyperparameterOptimizationOptions', struct('KFold', 10), ...
    'OptimizeHyperparameters', 'auto');

save("Data/choco-classifier.mat", "chococlassifier");

disp('train end');

% predictions
trPredicted = predict(chococlassifier, X_train);
tsPredicted = predict(chococlassifier, X_test);
train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);

% confusion matrix
train.labels = y_train;
test.labels = y_test;
classification.confchart(train, test);

show_mistakes(test, classes);

function [] = show_mistakes(test, classes)
    images = read_images('Data/Test/Chocolates/', classes);
    idx = test.labels ~= test.predicted;
    for j = 1:numel(idx)
        if idx(j) == 0
            continue
        end

        disp(convertStringsToChars(test.predicted(j)));

        im = images{j, 1};
        im = im2double(im);
        figure()
        imshow(im);
    end
end

function [images] = read_images(dataPath, classes)
    nClasses = size(classes, 2);
    
    images = {};
    k = 1;
    for c = 1 : nClasses
        images = utils.getfiles([dataPath convertStringsToChars(classes(c)) '/']);
        nImages = numel(images);
 
        for i = 1 : nImages
            im = imread(images{i});
            images{k, 1} = im;
            k = k + 1;
        end
    end
end

function [labels, features] = calc_features(dataPath, classes)
    labels = [];
    features = [];
    nClasses = size(classes, 2);
    
    for c = 1 : nClasses
        images = utils.getfiles([dataPath convertStringsToChars(classes(c)) '/']);
        nImages = numel(images);
 
        for i = 1 : nImages
            im = imread(images{i});
            im = im2double(im);
            im = imresize(im, [64, 64]);

            %rgb_hist = utils.computeColorHist(im, 32, [8, 8, 8]);
            hsv_hist = utils.computeColorHist(rgb2hsv(im), 32, [8, 8, 8]);
            %lab_hist = utils.computeColorHist(rgb2lab(im), 32, [8, 8, 8]);

            lbp = utils.computelbp(rgb2gray(im), [32, 32], 8, 1, true);
            %R = utils.computelbp(im(:,:,1));
            %G = utils.computelbp(im(:,:,2));
            %B = utils.computelbp(im(:,:,3));
            %lbpRGB = [R G B];
            %hog = utils.computehog(rgb2gray(im));

            texture = utils.computeLocalTextureDescriptors(im);

            features = [features; [hsv_hist texture lbp]];
            labels = [labels; classes(c)];
        end
    end
end
