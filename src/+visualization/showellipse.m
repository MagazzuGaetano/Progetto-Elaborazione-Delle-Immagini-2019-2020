function showellipse(image, mask, showImage)
%SHOWELLIPSE plot minimum enclosing ellipse, bounding box and axes of symmetry given an object binary mask

s = regionprops(mask, 'BoundingBox', 'Eccentricity', 'MajorAxisLength', ...
    'MinorAxisLength', 'Orientation', 'Centroid');

if (showImage)
    imshow(image);
    hold on;
end

rectangle('Position', s.BoundingBox, 'EdgeColor', 'r');

phi = linspace(0, 2 * pi, 50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xBar = s(k).Centroid(1);
    yBar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi * s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a * cosphi; b * sinphi];
    xy = R * xy;

    x = xy(1,:) + xBar;
    y = xy(2,:) + yBar;

    dist = vecnorm(xy)';

    x = x';
    y = y';

    [~, ii] = maxk(dist, 3);
    [~, jj] = mink(dist, 2);
    plot(x(ii), y(ii), 'LineWidth', 2);
    plot(x(jj), y(jj), 'LineWidth', 2);

    plot(x, y);
end

hold off

end
