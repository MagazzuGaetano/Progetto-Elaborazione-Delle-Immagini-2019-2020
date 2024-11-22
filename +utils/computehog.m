function out = computehog(im)
    out = extractHOGFeatures(im, 'CellSize', [8 8]);
end
