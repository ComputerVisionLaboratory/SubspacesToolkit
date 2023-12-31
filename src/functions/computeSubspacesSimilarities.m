function similarities = computeSubspacesSimilarities(X, Y, varargin)
% computeSubspacesSimilarities: Compute similarities between sets of subspaces.
% This function calculates the similarities between two sets of subspaces represented
% by multi-dimensional arrays X and Y. The similarity is defined based on the squared
% singular values of the cross-covariance matrix of the subspaces.
%
% Parameters:
%   X: A num_dim_x x num_sub_dim_x x num_sets_x 3D matrix representing the first set of subspaces.
%      - num_dim_x: dimension of the original vector space.
%      - num_sub_dim_x: dimension of each subspace in X.
%      - num_sets_x: number of subspaces in X.
%
%   Y: A num_dim_y x num_sub_dim_y x num_sets_y 3D matrix representing the second set of subspaces.
%      - num_dim_y: dimension of the original vector space.
%      - num_sub_dim_y: dimension of each subspace in Y.
%      - num_sets_y: number of subspaces in Y.
%
%   varargin: A string flag that determines the method of computation.
%      - If not specified or empty, similarities are based on the average of cos^2 theta,
%        computed efficiently using the trace of the cross-covariance matrix.
%      - If set to 'F', the function uses Singular Value Decomposition (SVD) to compute all
%        canonical angles and outputs both the average and the cos^2 of the first theta.
%
% Return:
%   similarities: A 4D matrix containing the computed similarities.
%      - size: num_sets_x x num_sets_y x num_sub_dim_x x num_sub_dim_y.
%      - Each element (i, j, k, l) represents the similarity between the k-th subspace of the
%        i-th set in X and the l-th subspace of the j-th set in Y.
%     - if vargin is set to 'F', similarities becomes a 3D matrix of size
%        num_sets_x x num_sets_y x min(num_sub_dim_x, num_sub_dim_y).
%
% Example Usage:
%   sim = computeSubspacesSimilarities(X, Y);
%   % Computes the subspace similarities between X and Y using the default method.
%
%   sim = computeSubspacesSimilarities(X, Y, 'F');
%   % Computes the subspace similarities using SVD for all canonical angles.
%
% Notes:
%   - The function normalizes the similarity by the number of singular values used in the computation.
%   - For high-dimensional data, using the default method (without 'F') is computationally more efficient.
%
% Last Update: 2023/10 by Santos Enoque
% Computer Vision Laboratory, University of Tsukuba
% http://www.cvlab.cs.tsukuba.ac.jp/

x_size = size(X);
x_size = length(x_size);
y_size = size(Y);
y_size = length(y_size);
% Check if the size of any of the subspaces is less than 3 or greater than 4
if any(x_size < 3 | x_size > 4) || any(y_size < 3 | y_size > 4)
    error('The size of each subspace must be greater than or equal to 3 and less than or equal to 4.');
end

use_svd = false;

% Check if an additional input argument is provided
if nargin == 3
    % If the additional input argument is 'F', set the flag for using SVD to true
    if varargin{1} == 'F'
        use_svd = true;
    end
end
% Ensure X and Y are 3D matrices, even if they are 4D initially
X = X(:,:,:);
Y = Y(:,:,:);

% Get dimensions information of input subspaces X and Y
[~, num_dim_x, num_sets_x] = size(X);
[~, num_dim_y, num_sets_y] = size(Y);

% If SVD is not used, compute similarities using cross-covariance
if ~use_svd
    % Compute the squared cross-covariance matrix and reshape it to a 4D matrix
    cross_cov_squared = reshape((X(:,:)' * Y(:, :)).^2, num_dim_x, num_sets_x, num_dim_y, num_sets_y);
    
    % Cumulatively sum the squared cross-covariance matrix along dimensions
    similarities = cumsum(cumsum(cross_cov_squared, 1), 3);
    
    % Normalize the similarities by the minimum dimension between X and Y subspaces
    for i = 1:num_dim_x
        for j = 1:num_dim_y
            similarities(i, :, j, :) = similarities(i, :, j, :) / min([i, j]);
        end
    end
    
    % Rearrange dimensions of the similarities matrix for consistent output format
    similarities = permute(similarities, [2, 4, 1, 3]);
    
    % If SVD is used, compute similarities using singular values
else
    % Compute the cross-covariance matrix and reshape it to a 4D matrix
    cross_cov = reshape((X(:,:)' * Y(:, :)), num_dim_x, num_sets_x, num_dim_y, num_sets_y);
    
    % Rearrange dimensions of the cross-covariance matrix for consistent computation
    cross_cov = permute(cross_cov, [1, 3, 2, 4]);
    
    % Initialize the similarities matrix with zeros
    num_dim = min([num_dim_x, num_dim_y]);
    similarities = zeros(num_sets_x, num_sets_y, num_dim);
    
    % Compute cumulative sum of squared singular values for each pair of subspaces
    for i = 1:num_sets_x
        for j = 1:num_sets_y
            similarities(i, j, :) = cumsum(svd(cross_cov(:, :, i, j)).^2, 1);
        end
    end
    
    % Normalize the similarities by the dimensionality
    for i = 1:num_dim
        similarities(:, :, i) = similarities(:, :, i) / i;
    end
end
end