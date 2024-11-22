images = utils.getfiles('Data/Train/');
for i = 1 : numel(images)
    
    im = imread(images{i});
    
    resized = imresize(im, 1/5);

    mask = findbox(resized);
    box = im2double(resized) .* mask;

    shape = classification.getshape(mask);
    
    [centers, radius] = findchocolates(box, mask, shape);
    
    utils.generatedata(im, centers*5, radius*5, 'Chocolates', i);
end
