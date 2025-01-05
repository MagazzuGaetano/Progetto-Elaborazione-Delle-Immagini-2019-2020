function errors = checkerrors(im, centers, radius, classifier)
%CHECKERRORS Check errors in a box and return the errors with their type and position
%
% The type of error are:
% - reject: a reject is found
% - stamp_not_found: the stamp is not found
% - misplaced: the chocolate is in the wrong position
 
centers = centers * 5;
radius = radius * 5;

radius = floor(radius);
im_pad = padarray(im, [radius radius]);

[n, m, ~] = size(centers);
if n == 6 && m == 4
    errors = checkrectangle(im_pad, centers, radius, classifier);
else
    errors = checksquare(im_pad, centers, radius, classifier);
end

end

function errors = checksquare(im, centers, radius, classifier)
%CHECKSQUARE check square boxes and return the errors
%
% Classify each chocolate in the box and count the number of stamps.
% If there are less than 24 stamps, return the errors found.

nStamps = 0;
errors = struct('x', {}, 'y', {}, 'error_type', {});
for i = 1 : length(centers)
    if nStamps == 24
        break;
    end

    x = centers(i, 1);
    y = centers(i, 2);

    choco = utils.cropcircle(im, x, y, radius, false);
    chocoType = getcode(choco, classifier);

    if chocoType == 1
        nStamps = nStamps + 1;
    elseif chocoType == 4
        errors(end + 1) = struct('x', x, 'y', y, 'error_type', 'reject');
    elseif chocoType == 5
        errors(end + 1) = struct('x', x, 'y', y, 'error_type', 'stamp_not_found');
    end
end

if  nStamps == 24
    errors = {};
end

end

function errors = checkrectangle(im, centers, radius, classifier)
%CHECKRECTANGLE check rectangle boxes and return the errors
%
% Classify each chocolate in the box and check the position of the chocolates
% in the grid and the presence of the stamps.

errors = struct('x', {}, 'y', {}, 'error_type', {});

[n, m, ~] = size(centers);
grid = zeros(n, m);
for i = 1 : n
    for j = 1 : m
        x = centers(i, j, 1);
        y = centers(i, j, 2);
        choco = utils.cropcircle(im, x, y, radius, false);
        grid(i, j) = getcode(choco, classifier);

        if grid(i, j) == 4
            errors(end + 1) = struct('x', x, 'y', y, 'error_type', 'reject');
        end

        if grid(i, j) == 5
            errors(end + 1) = struct('x', x, 'y', y, 'error_type', 'stamp_not_found');
        end
    end
end

conf1 = [
    2, 2, 2, 2, 2, 2;
    1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1;
    3, 3, 3, 3, 3, 3;
    ];

conf2 = [
    3, 3, 3, 3, 3, 3;
    1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1;
    2, 2, 2, 2, 2, 2;
    ];

p1 = mod(grid, 4) == conf1';
p2 = mod(grid, 4) == conf2';

if sum(p1 == 0, 'all') <= sum(p2 == 0, 'all')
    isCorrectGrid = p1;
else
    isCorrectGrid = p2;
end

for i = 1 : n
    for j = 1 : m
        if isCorrectGrid(i, j) == false && grid(i, j) ~= 4
            x = centers(i, j, 1);
            y = centers(i, j, 2);
            errors(end + 1) = struct('x', x, 'y', y, 'error_type', 'misplaced');
        end
    end
end
end

function [out] = getcode(choco, classifier)
%GETCODE predicts the type of a chocolate given a classifier model
%
% Types:
% 1: Ferrero Rocher (with stamp)
% 2: Ferrero Noir
% 3: Raffaello
% 4: Rejection
% 5: Stamp not found

chocoType = classification.choco.getchocotype(choco, classifier);

if chocoType == "Ferrero Rocher"
    if checkstamp(choco)
        out = 1;
    else
        out = 5;
    end
elseif chocoType == "Ferrero Noir"
    out = 2;
elseif chocoType == "Raffaello"
    out = 3;
else
    out = 4;
end

end

function [out] = checkstamp(im)
%CHECKSTAMP check if the stamp is present in the chocolate image

im = imresize(im, [64, 64]); %[293 293]

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

I = imopen(I1, strel('disk', 1));
I = imclose(I, strel('disk', 21));
I = imfill(I, 'holes');

if any(I(:))
    I = bwareafilt(I, 1);
    out = sum(I(:)); % the min area is 41
    out = out > 40;
else
    out = false;
end

end
