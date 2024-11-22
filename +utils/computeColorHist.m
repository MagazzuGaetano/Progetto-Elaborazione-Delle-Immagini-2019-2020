function out = computeColorHist(image, N, n_bins)
    S = size(image);
    if S(2) > 2
       [r, c, ch] = size(image); 
    else
        [r, c] = size(image); 
        ch = 1;
    end
    
    if (N > r || N > c)
        image = reshape(image, [], ch);
        out = color_hist(image, n_bins);
    else
        out = [];
        for i=1:N:r
            for j=1:N:c
                if (((i+N-1) > r) || ((j+N-1) > c))
                    continue
                end

                patch = image(i:(i+N-1), j:(j+N-1), :);
                patch = reshape(patch, [], ch);
                out = [out, color_hist(patch, n_bins)];
            end
        end
     end
end

function H = color_hist(im, n_bins)
    % given an image with size (r, c, ch)
    % n_bins is a vector with size (ch, 1)
    % sulle 3 colonne abbiamo ora i 3 canali colore R, G, B
    im=reshape(im,[],3);
    H=[];
    for ch=1:3
        tmp=hist(im(:,ch),linspace(0, 1, n_bins(ch)));
        tmp=tmp./sum(tmp);
        H = [H tmp];
    end
end