% SPLIT DATASET
% Script to split image dataset into training and testing sets.

images = utils.getfiles(fullfile('Data', 'Acquisizioni'));

% Hold out partitioning (train: 80%, test: 20%)
cv = cvpartition(size(images,1), 'HoldOut', 0.2);
idx = cv.test;

% Separate to training and test data
dataTrain = images(~idx,:);
dataTest  = images(idx,:);

% Save train set
for i = 1 : numel(dataTrain)
    im = imread(dataTrain{i});
    imwrite(im, fullfile('Data', 'Train', [num2str(i) '.jpg']));
end

% Save test set
for i = 1 : numel(dataTest)
    im = imread(dataTest{i});
    imwrite(im, fullfile('Data', 'Test', [num2str(i) '.jpg']));
end