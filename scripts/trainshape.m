% TRAIN SHAPE 
% Train a minimum distance classifier using eccentricity to predict the shape.

addpath(genpath("src"));

[images, labels] = utils.readlabels(fullfile("Data", "lbl_forma.csv"), fullfile("Data", "Acquisizioni"));
classes = ["quadrata", "rettangolare"];

nImages = numel(images);

eccentricity = zeros(nImages, 1);
for i = 1 : nImages
    im = imread(images{i});
    resized = imresize(im, 1/5);
    
    mask = pipeline.findbox(resized);
    props = regionprops(mask, 'eccentricity');
    eccentricity(i) = props.Eccentricity;
end

[train, test] = partdata(eccentricity, labels);

q = train.values(train.labels == classes(1));
r = train.values(train.labels == classes(2));

shapeClassifier.mq = mean(q);
shapeClassifier.mr = mean(r);

train.predicted = classification.shape.predictshape(train.values, shapeClassifier);
test.predicted = classification.shape.predictshape(test.values, shapeClassifier);

% plot confusion matrices
metrics.plotcm(train, classes, figure("Name", "Train"));
metrics.plotcm(test, classes, figure("Name", "Test"));

save(fullfile("Data", "shape-classifier.mat"), "shapeClassifier");


function [train, test] = partdata(values, labels)
% PARTDATA Split dataset in train and test sets (80% train, 20% test).

cv = cvpartition(labels, "Holdout", 0.2);

train.values = values(cv.training, :);
train.labels = labels(cv.training);
test.values  = values(cv.test,:);
test.labels  = labels(cv.test);

end
