function chocoType = predictchoco(features, classifier)
%PREDICTCHOCO Predict the type of a chocolate given the features of an image.

normalized = (features - classifier.mean) ./ classifier.std;
predicted = predict(classifier.model, normalized);
chocoType = convertCharsToStrings(predicted);

end
