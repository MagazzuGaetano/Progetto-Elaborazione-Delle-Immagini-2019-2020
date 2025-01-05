% CHECK STAMP
% This script finds stamps of Ferrero Rocher chocolates and computes
% area statistics to determine the optimal threshold for the train set to 
% detect chocolates with and without stamps.
% Chocolates with an area below the threshold are visualized in a plot.

addpath(genpath("src"));

threshold = 40;
path = fullfile("Data", "Train", "Chocolates", "Ferrero Rocher");

images = utils.getfiles(path);

sizes = [];
images_below_threshold = {};
areas_below_threshold = [];

for i = 1 : numel(images)
    im = imread(images{i});
    im = imresize(im, [64, 64]); %[293 293]
    stamp = getstamp(im);

    stampArea = getstamparea(stamp);
    sizes = [sizes; stampArea];
    
    masked = im .* uint8(stamp);

    % If the stamp area is below the threshold, store the image and its area
    if stampArea < threshold
        images_below_threshold{end+1} = masked;
        areas_below_threshold = [areas_below_threshold; stampArea];
    end
end

disp(['Minimum stamp area: ', num2str(min(sizes))]);
disp(['Mean stamp area: ', num2str(mean(sizes))]);
disp(['Max stamp area: ', num2str(max(sizes))]);    

below_threshold = sizes < threshold;
disp(['Number of images with stamp area smaller than threshold: ', num2str(sum(below_threshold))]);

% Plot the images with stamp area below the threshold
num_images = numel(images_below_threshold);

if num_images > 0
    figure;
    cols = 4;
    rows = ceil(num_images / cols);

    for i = 1:min(num_images, 32)
        subplot(rows, cols, i);
        imshow(images_below_threshold{i});
        title(['Stamp Area: ', num2str(areas_below_threshold(i))]);
    end
else
    disp('No images found with stamp area below the threshold.');
end


function [out] = getstamp(im)
% GETSTAMP Segment the stamp from the chocolate.

hsv = rgb2hsv(im);
lab = rgb2lab(im);

S = hsv(:,:,2);
b = lab(:,:,3);
B = im(:,:,3);

b = (b + 128) / 255;

S = S > graythresh(S);
b = b > graythresh(b);
B = B < graythresh(B);
I1 = ~(S | b | B);
I1 = imfill(I1, 'holes');

out = imopen(I1, strel('disk', 1));
out = imclose(out, strel('disk', 21));
out = imfill(out, 'holes');
if any(out(:))
    out = bwareafilt(out, 1);
end

end


function [stampArea] = getstamparea(stamp)
% GETSTAMPAREA Calculate the area of the stamp.

if any(stamp(:))
    stampArea = sum(stamp(:));
else
    stampArea = 0;
end

end
