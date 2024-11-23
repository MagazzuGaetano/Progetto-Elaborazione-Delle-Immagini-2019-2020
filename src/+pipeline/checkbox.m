function [isCompliant, errors] = checkbox(im, shapeClassifier, chocoClassifier)

% Downscale the image
resized = imresize(im, 1/5);

% Find the box
mask = pipeline.findbox(resized);
box = im2double(resized) .* mask;

% Check the shape
shape = classification.shape.getshape(mask, shapeClassifier);

% Find the chocolates
[centers, radii] = pipeline.findchocolates(box, mask, shape);

% Look for errors
if shape == "rettangolare"
    grid = pipeline.creategrid(centers);
    errors = pipeline.checkerrors(im, grid, radii, chocoClassifier);
else
    errors = pipeline.checkerrors(im, centers, radii, chocoClassifier);
end

isCompliant = isempty(errors);

end
