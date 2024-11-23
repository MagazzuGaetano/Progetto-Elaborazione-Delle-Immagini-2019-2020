function [out] = computelocaltexture(image)
%COMPUTELOCALTEXTURE Compute the local texture descriptors of an image.

fMean = @(x) mean(x);
%fStd = @(x) std(x);
%fKurt = @(x) kurtosis(x);
fSkew = @(x) skewness(x);
%fRange = @(x) max(x) - min(x);
fUniformity = @(x) sum((imhist(x) / 255) .^ 2, 'all');
%fEnergy = @(x) sqrt(fUniformity(x));
fEntropy = @(x) entropy(x);
fContrast = @(x) 1 - (1 / (1 + (var(x) ./ (255 * 255))));

gray = rgb2gray(image);

out = [
    localfeature(gray, 16, fMean), ...
    localfeature(gray, 16, fContrast), ...
    localfeature(gray, 16, fUniformity), ...
    localfeature(gray, 16, fEntropy), ...
    localfeature(gray, 16, fSkew), ...
    ];

end


function out = localfeature(image, N, func)
%LOCALFEATURE Compute the local texture descriptors of an image with N blocks.

S = size(image);
if S(2) > 2
    [r, c, ch] = size(image);
else
    [r, c] = size(image);
    ch = 1;
end

out = [];
for i=1:N:r
    for j=1:N:c
        if (((i + N - 1) > r) || ((j + N - 1) > c))
            continue
        end

        patch = image(i:(i + N - 1), j:(j + N - 1), :);
        patch = reshape(patch, [], ch);
        out = [out, func(patch)];
    end
end

end
