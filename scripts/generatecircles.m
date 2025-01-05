% GENERATE CIRCLES
% This script detects and crops chocolates from images to create the chocolates dataset.
% The cropped chocolates are then saved as individual images.

addpath(genpath("src"));
load(fullfile('Data', 'shape-classifier.mat'), "shapeClassifier");

images = utils.getfiles(fullfile('Data', 'Train'));
for i = 1:numel(images)
    im = imread(images{i});
    resized = imresize(im, 1/5);

    mask = pipeline.findbox(resized);
    box = im2double(resized) .* mask;

    shape = classification.shape.getshape(mask, shapeClassifier);
    [centers, radius] = pipeline.findchocolates(box, mask, shape);
    chocolates = getchocolates(im, centers * 5, radius * 5, 'TestHoughCircles', i);

    for k = 1:length(chocolates)
        destPath = fullfile('Outputs', folder, ['choco_' num2str(i) '-' num2str(k) '.jpg']);
        imwrite(chocolates{k}, destPath);
    end
end

function [outputs] = getchocolates(im, centers, radius)
% GETCHOCOLATES crop each chocolate using centers and radius from the input image.

outputs = {};
for k = 1:length(centers)
    x = centers(k, 1);
    y = centers(k, 2);

    cropped = utils.cropcircle(im, x, y, radius, false);
    outputs{end + 1} = cropped;
end

end