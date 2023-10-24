load("data/CVLABFace2.mat")
training_data = X1;
testing_data = X2;

[~, num_samples, ~] = size(training_data);
[num_dim, num_samples_per_set, num_sets, num_classes] = size(testing_data);

num_dim_reference_subspaces = 20;
num_dim_input_subpaces = 5;

reference_subspaces = computeBasisVectors(training_data, num_dim_reference_subspaces);
input_subspaces = computeBasisVectors(testing_data, num_dim_input_subpaces);
similarities = computeSubspacesSimilarities(reference_subspaces, input_subspaces);

model_evaluation = ModelEvaluation(similarities(:, :, end, end), generateLabels(size(testing_data, 3), num_classes));

displayModelResults('Mutual Subspace Methods', model_evaluation);