function mask = findbox(im)
%FIND_BOX edge based segmentation of the box

im = rgb2gray(im);

highT = 0.137; % empirical threshold
sigma = 0.8; % estimated by N = (2.5 * sigma) * 2 - 1 with N = 5

bw = edge(im, 'canny', highT, sigma);

bw = imdilate(bw, strel('disk', 3));
bw = imfill(bw, 'holes');
bw = imopen(bw, strel('disk', 9));
bw = bwareafilt(bw, 1);

mask = bwconvhull(bw);
end

