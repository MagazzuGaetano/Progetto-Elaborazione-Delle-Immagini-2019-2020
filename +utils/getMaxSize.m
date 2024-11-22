data = utils.getfiles('Data/Cioccolatini-All');
sizes = zeros(numel(data), 2);
for i = 1 : numel(data)
    im = imread(data{i});
    [r, c, ~] = size(im);
    sizes(i, :) = [r c];
end
m = max(sizes);
