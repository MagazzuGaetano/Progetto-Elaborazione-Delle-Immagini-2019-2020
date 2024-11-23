function [images, labels] = readlabels(path, folder)
%READLABELS Read labels from a csv file, returning images path and the corresponding labels

rows = readmatrix(path, 'OutputType', 'string', 'NumHeaderLines', 1, 'Delimiter', ',');
images = folder + rows(:, 1);
labels = rows(:, 2);
end