function [out] = computeLocalTextureDescriptors(image)
    f_mean = @(x) mean(x);
    f_std = @(x) std(x);
    f_kurt = @(x) kurtosis(x);
    f_skew = @(x) skewness(x);
    f_range = @(x) max(x) - min(x);
    f_uniformity = @(x) sum((imhist(x) / 255) .^ 2, 'all');
    f_energy = @(x) sqrt(f_uniformity(x));
    f_entropy = @(x) entropy(x);
    f_contrast = @(x) 1 - (1 / (1 + (var(x) ./ (255*255))));

    gray = rgb2gray(image);
    out = [
        local_methods(gray, 16, f_mean), ...
        local_methods(gray, 16, f_contrast), ...
        local_methods(gray, 16, f_uniformity), ...
        local_methods(gray, 16, f_entropy), ...
        local_methods(gray, 16, f_skew), ...
    ];
end


function out = local_methods(image, N, func)
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
            if (((i+N-1) > r) || ((j+N-1) > c))
                continue
            end

            patch = image(i:(i+N-1), j:(j+N-1), :);
            patch = reshape(patch, [], ch);
            out = [out, func(patch)];
        end
    end
end
