function cropped = cropcircle(image, x, y, radius, keepCorners)
%CROPCIRCLE Crop an image around a circle centered in (x,y).
%
% keepCorners: keep the corners of the image, if true.

radius = floor(radius);

if keepCorners
    rect = round([x - radius, y - radius, 2 * radius, 2 * radius]);
    cropped = imcrop(image, rect);
else
    rect = round([x, y, 2 * radius, 2 * radius]);
    image = padarray(image, [radius radius], 0);
    cropped = imcrop(image, rect);

    mask = fspecial('disk', radius) ~= 0;
    cropped = im2double(cropped) .* im2double(mask);
    cropped = im2uint8(cropped);
end

end