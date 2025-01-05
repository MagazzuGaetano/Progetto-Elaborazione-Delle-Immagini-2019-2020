function chocoType = predictchoco(features, classifier)
%PREDICTCHOCO Predict the type of a chocolate given the features of an image.

normalizedFeats = (features - classifier.mean) ./ classifier.std;
pcaFeats = (normalizedFeats - classifier.pcaMu)*classifier.pcaCoeff;

predicted = predict(classifier.model, pcaFeats);
chocoType = convertCharsToStrings(predicted);

end
