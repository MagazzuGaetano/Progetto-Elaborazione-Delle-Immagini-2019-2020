function [images] = readimages(dataPath, classes)
%READIMAGES Read images from a folder divided by classes.

nClasses = size(classes, 2);

images = {};
k = 1;
for c = 1 : nClasses
    images = utils.getfiles([dataPath convertStringsToChars(classes(c)) '/']);
    nImages = numel(images);

    for i = 1 : nImages
        im = imread(images{i});
        images{k, 1} = im;
        k = k + 1;
    end
end

end