load("data/CVLABFace2.mat")
training_data = cvlNormalize(X1);
testing_data = cvlNormalize(X2);

[~, num_samples, ~] = size(training_data);
[num_dim, num_samples_per_set, num_sets, num_classes] = size(testing_data);

num_dim_reference_subspaces = 60;
num_dim_input_subpaces = 20;
sigma = 10;
rff_dim = 100;

reference_subspaces = computeKernelBasisVectors(training_data, num_dim_reference_subspaces, sigma, 'RFF', rff_dim);
input_subspaces = computeKernelBasisVectors(testing_data, num_dim_input_subpaces, sigma, 'RFF', rff_dim);
similarities = computeKernelSubspacesSimilarities(training_data, reference_subspaces, testing_data, input_subspaces, sigma, 'RFF', rff_dim);

model_evaluation = ModelEvaluation(similarities(:, :, end, end), generateLabels(size(testing_data, 3), num_classes));

displayModelResults('Kernel Mutual Subspace Methods', model_evaluation, 20, 5);