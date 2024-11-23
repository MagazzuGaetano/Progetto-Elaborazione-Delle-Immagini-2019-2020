function out = computelbp(image, cellSize, numNeighbors, radius, upright)
%COMPUTELBP Compute the LBP feature vector of an image.

out = extractLBPFeatures(image, ...
  'CellSize', cellSize, ... % [64 64]
  'NumNeighbors', numNeighbors, ... % 16
  'Radius', radius, ... % 2
  'Upright', upright ... % true
  );

end

