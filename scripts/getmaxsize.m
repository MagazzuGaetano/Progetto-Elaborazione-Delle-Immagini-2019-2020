% GET MAX SIZE
% Computes the largest image size among the chocolate images.

addpath(genpath("src"));

path = fullfile('Data', 'Test', 'Chocolates');
classes = ["Ferrero Rocher", "Ferrero Noir", "Raffaello", "Rejection"];

for k = 1:length(classes)
    data = utils.getfiles(fullfile(path, classes(k)));
   
    sizes = zeros(numel(data), 2);
    for i = 1 : numel(data)
        im = imread(data{i});
        [r, c, ~] = size(im);
        sizes(i, :) = [r c];
    end
end

disp(max(sizes));
