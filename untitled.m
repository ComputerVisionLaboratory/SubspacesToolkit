% These are the similarity scores for each data point, representing likelihood of belonging to class 1
evaluation_values = [0.9, 0.8, 0.2, 0.1, 0.9, 0.7];
% 1 for class 1 and 2 for class 2
labels = [1, 1, 2, 2, 1, 1];
model_eval = ModelEvaluation(evaluation_values, labels);
disp("Error Rate: " + model_eval.error_rate);
disp("EER: " + model_eval.equal_error_rate);

