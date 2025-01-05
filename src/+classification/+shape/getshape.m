function shape = getshape(mask, classifier)
%GETSHAPE Determine the shape of an image using eccentricity.

props = regionprops(mask, "Eccentricity");
shape = classification.shape.predictshape(props.Eccentricity, classifier);

end
