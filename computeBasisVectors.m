function [basis_vectors] = computeBasisVectors(X, num_sub_dim)
% computeBasisVectors: Compute subspace basis vectors for the data X.
% This function calculates the basis vectors of subspaces represented by the data in X.
% X can be a 3D or 4D matrix, representing data samples across different sets and classes.
% The function uses PCA to perform dimensionality reduction, keeping either a specific
% number of dimensions or a specific ratio of the total variance.
%
% Parameters:
%   X: A num_dim x num_samples x num_classes 3D matrix, or a 4D matrix of size
%      num_dim x num_of_samples_per_set x num_sample_sets x num_classes. It represents
%      the data samples, where each slice along the third dimension represents a
%      different set of data.
%   num_sub_dim: An integer specifying the number of basis vectors (sub-dimensions)
%                to compute for each set. Alternatively, a ratio (0 < num_sub_dim < 1)
%                specifying the fraction of total variance that the basis vectors
%                should capture.
%
% Return:
%   basis_vectors: a 3D / 4D matrix that represents the subspace basis vectors.
%                  whether it is 3D or 4D depends on the input X.
%
% Example Usage:
%   basis_vectors = computeBasisVectors(X, 5);
%   % Computes 5 basis vectors for each set in X.
%
%   basis_vectors = computeBasisVectors(X, 0.95);
%   % Computes enough basis vectors for each set in X to capture 95% of the total variance.
%
% Notes:
%   - The function automatically decides whether to use the covariance or correlation
%     matrix for PCA based on the input data.
%   - If num_sub_dim is a ratio, the function computes enough basis vectors to capture
%     at least that fraction of the total variance. The actual number of vectors may be
%     less than the number of samples per set.
%
% Last Update: 2023/10 by Santos Enoque
% Computer Vision Laboratory, University of Tsukuba
% http://www.cvlab.cs.tsukuba.ac.jp/

if num_sub_dim <= 0 || (num_sub_dim >= 1 && floor(num_sub_dim) ~= num_sub_dim)
    error('num_sub_dim must be a positive integer or a ratio (0 < num_sub_dim < 1).');
end

% Check the number of dimensions in X and get its size
size_of_X = size(X);
num_sets = prod(size_of_X)/prod(size_of_X(1:2));
X = reshape(X, size_of_X(1), size_of_X(2), num_sets);

if num_sub_dim >= 1
    % Pre-allocate space for the basis vectors
    basis_vectors = zeros(size_of_X(1), floor(num_sub_dim), num_sets);
else
    % If num_sub_dim is a ratio, allocate maximum possible space
    basis_vectors = zeros(size_of_X(1), size_of_X(2), num_sets);
end

% Loop through each set of data and compute the basis vectors
for i = 1:num_sets
    [eig_vectors, ~, ~, actual_dim] = computePCA(X(:,:,i), num_sub_dim, 'R');
    
    if num_sub_dim >= 1
        basis_vectors(:, :, i) = eig_vectors;
    else
        basis_vectors(:, 1:actual_dim, i) = eig_vectors;
    end
end
basis_vectors = reshape(basis_vectors, [size_of_X(1), size(basis_vectors, 2), size_of_X(3:end), 1]);

