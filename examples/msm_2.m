load("data/CVLABFace2.mat")
training_data = X1;
testing_data = X2;

[~, num_samples, ~] = size(training_data);
[num_dim, num_samples_per_set, num_sets, num_classes] = size(testing_data);

max_subdim_reference_subspace = 20;  % or any other integer value
max_subdim_input_subspace = 5;  % or any other integer value
dim_ref_cell = num2cell(1:max_subdim_reference_subspace);
dim_input_cell = num2cell(1:max_subdim_input_subspace);
result = svdMSMEval(training_data, testing_data, dim_ref_cell, dim_input_cell, true);