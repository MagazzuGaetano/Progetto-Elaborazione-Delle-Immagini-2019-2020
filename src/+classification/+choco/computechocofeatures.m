function features = computechocofeatures(im)
%COMPUTECHOCOFEATURES Compute the features of a given chocolate image.

im = im2double(im);

ycbcr = rgb2ycbcr(im);
Y = ycbcr(:, :, 1);
Cb = ycbcr(:, :, 2);
Cr = ycbcr(:, :, 3);
Y = imadjust(Y);
im = ycbcr2rgb(cat(3, Y, Cb, Cr));

im = imresize(im, [64 64]); % the min size is [207 207]
lbp = feature.computelbp(rgb2gray(im), [16, 16], 8, 1, false);
hsvHist = feature.computecolorhist(rgb2hsv(im), 16, [8, 8, 8]);
features = [hsvHist lbp];

end
