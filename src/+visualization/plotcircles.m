function plotcircles(image, centers, radii, text)
%plotcircles Plot circles on image

if ~exist('title', 'var')
    text = "";
end

h = figure;

imshow(image); 
title(text);

hold on;
viscircles(centers, ...
    radii, ...
    'EdgeColor', 'b', ...
    'LineWidth', 3); axis image;

pause(10);

hold off;
close(h);

end