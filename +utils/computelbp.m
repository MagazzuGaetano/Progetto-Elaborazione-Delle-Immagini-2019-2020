function out = computelbp(image, CellSize, NumNeighbors, Radius, Upright)
  out = extractLBPFeatures(image, ...
      'CellSize', CellSize, ... % [64 64]
      'NumNeighbors', NumNeighbors, ... % 16
      'Radius', Radius, ... % 2
      'Upright', Upright ... % true
  );
end

