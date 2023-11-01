load("data/CVLABFace2.mat")
training_data = cvlNormalize(X1);
testing_data = cvlNormalize(X2);

[~, num_samples, ~] = size(training_data);
[num_dim, num_samples_per_set, num_sets, num_classes] = size(testing_data);

num_dim_reference_subspaces = 20;
num_dim_input_subspace = 5;
sigma = 1;

kernelMatrix = cvlKOMSM(training_data, num_dim_reference_subspaces, sigma);
reference_subspaces = kernelMatrix.TransformS(training_data, num_dim_reference_subspaces);
input_subspaces = kernelMatrix.TransformS(testing_data, num_dim_input_subspace);
similarities = cvlCanonicalAngles(reference_subspaces,input_subspaces);
model_evaluation = ModelEvaluation(similarities(:, :, end, end), generateLabels(size(testing_data, 3), num_classes));
% display size of the model_evaluation
fprintf('The size of the model_evaluation is: %d\n', size(model_evaluation));

displayModelResults('Kernel Ortohonal Mutual Subspace Methods', model_evaluation, 20, 5);