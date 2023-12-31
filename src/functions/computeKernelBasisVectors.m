function [basis_vectors] = computeKernelBasisVectors(X,num_sub_dim_or_c_ratio,sigma)
% computeKernelBasisVectors: Compute kernel-based subspace basis vectors using Gaussian kernel PCA.
%
% This function calculates the kernel-based basis vectors for the given data X.
% X can be a 2D, 3D, or 4D matrix, representing data samples across various dimensions,
% subsets, and superset categories. The function uses Kernel PCA with Gaussian
% kernel to derive the subspace basis vectors, considering either a specific number of
% dimensions or a specific ratio of the total variance.
%
% Parameters:
%   X: Multidimensional matrix (up to 4D) where:
%      1st-order: dimension of the feature vector
%      2nd-order: number of samples
%      3rd-order: subset of samples (sub-category, number of sets)
%      4th-order: bigger set of samples (superset category,the number of classes)
%   num_sub_dim_or_c_ratio:
%      - If integer: specifies the number of basis vectors to compute.
%      - If fraction (0 < num_sub_dim_or_c_ratio < 1): specifies the fraction of
%        total variance that the basis vectors should capture.
%   sigma: Gaussian bandwidth parameter for the kernel.
%
% Returns:
%   basis_vectors: Kernel-based basis vectors computed using Gaussian kernel PCA.
%
% Notes:
%   - If num_sub_dim_or_c_ratio is a ratio, the function computes enough basis vectors
%     to capture at least that fraction of the total variance.
%
% Last Update: 2023/10 by Santos Enoque
% Computer Vision Laboratory, University of Tsukuba
% http://www.cvlab.cs.tsukuba.ac.jp/


if num_sub_dim_or_c_ratio <= 0 || (num_sub_dim_or_c_ratio >= 1 && floor(num_sub_dim_or_c_ratio) ~= num_sub_dim_or_c_ratio)
    error('num_sub_dim must be a positive integer or a ratio (0 < num_sub_dim < 1).');
end

size_of_X = size(X);
num_sets = prod(size_of_X)/prod(size_of_X(1:2));
X = reshape(X,size(X,1),size(X,2),num_sets);

if num_sub_dim_or_c_ratio >= 1
    % Pre-allocate space for the basis vectors
    basis_vectors = zeros(size_of_X(2), floor(num_sub_dim_or_c_ratio), num_sets);
else
    % If num_sub_dim is a ratio, allocate maximum possible space
    basis_vectors = zeros(size_of_X(2), size_of_X(2), num_sets);
end

for i =1:num_sets
    [eig_vectors, ~, ~, ~, num_principal_components] = computeKernelPCA(X(:,:,i),num_sub_dim_or_c_ratio,sigma,'R');
    
    if num_sub_dim_or_c_ratio >= 1
        basis_vectors(:, :, i) = eig_vectors;
    else
        basis_vectors(:, 1:num_principal_components, i) = eig_vectors;
        % Check if is the last iteration of the loop
        if i == num_sets
            % Trim the basis vectors to the correct size
            basis_vectors = basis_vectors(:, 1:num_principal_components, :);
        end
    end
end

if size(X,3) ~= 1
    basis_vectors = reshape(basis_vectors,[size_of_X(2),size(basis_vectors, 2),size_of_X(3:end),1]);
end