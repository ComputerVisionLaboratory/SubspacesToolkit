function displayModelResults(model_name, model_evaluation,...
    num_dim_reference_subspaces, num_dim_input_subpaces)
% This function displays the model evaluation results.
%
% Parameters:
% - model_name: Name of the model being evaluated.
% - model_evaluation: Object of ModelEvaluation class containing evaluation results.

% Assertions to check input types
assert(ischar(model_name) || isstring(model_name), 'The model name should be a string.');
assert(isa(model_evaluation, 'ModelEvaluation'), 'The model_evaluation should be an instance of the ModelEvaluation class.');

% Parse optional arguments
% if (nargin == 3)
%     error('The number of reference and input subspaces should be provided together.');
% elseif (nargin > 2 && nargin <= 4)
%     num_dim_reference_subspaces = varargin{1};
%     num_dim_input_subpaces = varargin{2};
% end
% Display the model name

% Display the results
disp('---------- Best Model Parameters----------');
fprintf('Model: %s\n', model_name);
disp('---------- Best Model Parameters----------');
fprintf('Reference subspace dim: %d\n', num_dim_reference_subspaces); % Display as percentage
fprintf('Input subspace dim: %d\n', num_dim_input_subpaces); % Display as percentage
disp('---------- Model Evaluation Results ----------');
fprintf('Model Accuracy: %.2f%%\n', model_evaluation.accuracy * 100); % Display as percentage
fprintf('Model Error Rate: %.2f%%\n', model_evaluation.error_rate * 100); % Display as percentage
fprintf('Equal Error Rate (EER): %.2f%%\n', model_evaluation.equal_error_rate * 100); % Display as percentage
fprintf('Classification Threshold: %.2f\n', model_evaluation.classification_threshold);
disp('----------------------------------------------');
end
