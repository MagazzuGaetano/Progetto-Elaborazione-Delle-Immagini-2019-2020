function out = computecolorhist(image, N, n_bins)
%COMPUTECOLORHIST Compute the local color histogram of an image with N blocks.

[r, c, ~] = size(image);

if (N > r || N > c)
    out = colorhist(image, n_bins);
else
    num_blocks = floor(r / N) * floor(c / N);
    out = zeros(num_blocks, sum(n_bins));

    block_idx = 1;
    for i=1:N:r-N+1
        for j=1:N:c-N+1
            patch = image(i:(i+N-1), j:(j+N-1), :);

            out(block_idx, :) = colorhist(patch, n_bins);
            block_idx = block_idx + 1;
        end
    end
end

out = reshape(out, 1, []);

end

function H = colorhist(im, n_bins)
%COLOR_HIST Compute the histogram of an image in each color channel

[~, ~, ch] = size(im);

idx = 1;
H = zeros(sum(n_bins), 1);

for i=1:ch
    tmp = imhist(im(:, :, i), n_bins(i));
    tmp = tmp ./ sum(tmp);

    H(idx:idx + n_bins(i) - 1) = tmp;
    idx = idx + n_bins(i);
end

end