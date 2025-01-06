function chocoType = getchocotype(im, classifier, net)
%GETCHOCOTYPE Predict the type of a chocolate image given a classifier model.

features = classification.choco.computechocofeatures(im, net);
chocoType = classification.choco.predictchoco(features, classifier);

end
