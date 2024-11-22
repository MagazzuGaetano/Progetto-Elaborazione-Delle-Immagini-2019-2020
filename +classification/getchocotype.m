function chocoType = getchocotype(im)
%GETCHOCOTYPE 

load("Data/mean_std.mat", "train_mean", "train_std");
load("Data/choco-classifier.mat", "chococlassifier");

im = im2double(im);
im = imresize(im, [64 64]);
hsv_hist = utils.computeColorHist(rgb2hsv(im), 32, [8, 8, 8]);
lbp = utils.computelbp(rgb2gray(im), [32, 32], 8, 1, true);
texture = utils.computeLocalTextureDescriptors(im);

X = [hsv_hist texture lbp];
normalized = (X - train_mean) ./ train_std;
predicted = predict(chococlassifier, normalized);
chocoType = convertCharsToStrings(predicted);

end
