function features = computechocofeatures(im)
%COMPUTECHOCOFEATURES Compute the features of a given chocolate image.

im = im2double(im);
im = imresize(im, [64 64]);
hsvHist = feature.computecolorhist(rgb2hsv(im), 32, [8, 8, 8]);
lbp = feature.computelbp(rgb2gray(im), [32, 32], 8, 1, true);
texture = feature.computelocaltexture(im);

features = [hsvHist texture lbp];

end
