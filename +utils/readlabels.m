function [images, labels] = readlabels(path, folder)
    rows = readmatrix(path, 'OutputType', 'string', 'NumHeaderLines', 1, 'Delimiter', ',');
    images = folder + rows(:, 1);
    labels = rows(:, 2);
end