function out = computehog(im)
%COMPUTEHOG Compute the HOG feature vector of an image.

out = extractHOGFeatures(im, 'CellSize', [8 8]);

end
