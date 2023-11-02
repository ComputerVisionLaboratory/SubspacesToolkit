load("data/CVLABFace2.mat")
training_data = cvlNormalize(X1);
testing_data = cvlNormalize(X2);

[~, num_samples, ~] = size(training_data);
[num_dim, num_samples_per_set, num_sets, num_classes] = size(testing_data);

num_dim_reference_subspaces = 20;
num_dim_input_subpaces = 4;
sigma = 0.5;
ref_landmarks = 2;
inp_landmarks = 2;

reference_subspaces = computeKernelBasisVectors(training_data, num_dim_reference_subspaces, sigma, 'NY', ref_landmarks);
input_subspaces = computeKernelBasisVectors(testing_data, num_dim_input_subpaces, sigma, 'NY', inp_landmarks);
similarities = computeKernelSubspacesSimilarities(training_data, reference_subspaces, testing_data, input_subspaces, sigma);

model_evaluation = ModelEvaluation(similarities(:, :, end, end), generateLabels(size(testing_data, 3), num_classes));

displayModelResults('Kernel Mutual Subspace Methods', model_evaluation, 20, 5);