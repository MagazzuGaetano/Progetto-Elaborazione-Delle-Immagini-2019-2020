function isCompliant = checkbox(im)

% Downscale the image
resized = imresize(im, 1/5);

% Find the box
mask = pipeline.findbox(resized);
box = im2double(resized) .* mask;

% Check the shape
shape = classification.shape.getshape(mask);

% Find the chocolates
[centers, radii] = pipeline.findchocolates(box, mask, shape);

% Look for errors
if shape == "rettangolare"
    grid = pipeline.creategrid(centers);
    errors = pipeline.checkerrors(im, grid, radii);
else
    errors = pipeline.checkerrors(im, centers, radii);
end

isCompliant = isempty(errors);

% Show results
showresults(im, errors);
end
