function chocoType = getchocotype(im, classifier)
%GETCHOCOTYPE Predict the type of a chocolate image given a classifier model.

features = classification.choco.computechocofeatures(im);
chocoType = classification.choco.predictchoco(features, classifier);

end
