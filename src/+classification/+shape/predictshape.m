function labels = predictshape(values, classifier)
%PREDICT Predict the shape by computing the distance to the means of the classes.

predicted = pdist2(values, classifier.mr) < pdist2(values, classifier.mq);

labels = repmat("quadrata", size(values, 1), 1);
labels(predicted) = "rettangolare";

end