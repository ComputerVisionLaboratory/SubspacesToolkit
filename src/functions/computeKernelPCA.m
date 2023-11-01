function [ eig_vectors, eig_values, eig_ratio, kernel_matrix, num_principal_components] = computeKernelPCA(X, pc_count_or_variance, sigma, varargin)
% computeKernelPCA: Compute Kernel PCA using Gaussian kernel.
%
% Parameters:
%   X: Matrix of sample data of size num_dim x num_samples.
%      Where num_dim is the number of variables (dimension of feature data)
%      and num_samples is the number of samples.
%   pc_count_or_variance: Number of principal components to keep.
%                If < 1, it indicates the ratio of variance to keep.
%   sigma: Gaussian kernel bandwidth parameter.
%   varargin: If not specified, PCA is computed on covariance matrix of X.
%             If set to 'R', PCA is computed on autocorrelation matrix of X.
%
% Return:
%   eig_vectors: Principal vectors (eigenvectors) of the kernel matrix.
%   eig_values: Eigenvalues of the kernel matrix.
%   eig_ratio: Ratio of variance explained by each principal component.
%   kernel_matrix: Kernel Gram matrix.
%   num_principal_components: Actual number of principal components computed.
%
% Last Update: 2023/10 by Santos Enoque
% Computer vision laboratory, University of Tsukuba
% http://www.cvlab.cs.tsukuba.ac.jp/

X = X(:, :);
[~, num_samples] = size(X);

use_covariance_matrix = true;
use_rff = false;
if nargin == 4
    if strcmp(varargin{1}, 'R')
        use_covariance_matrix = false;
    end
elseif nargin > 4
    if strcmp(varargin{2}, 'RFF')
        use_covariance_matrix = false;
        use_rff = true;
        rff_dim = varargin{3};
    else
        error('Invalid input arguments.');
    end
end

if use_rff == true
    kernel_matrix = computeGramMatrixRFF(X,rff_dim, sigma);
else
    kernel_matrix = computeGaussianKernelMatrix(X, sigma);
end

if use_covariance_matrix
    IN = ones(num_samples, num_samples) / num_samples;
    kernel_matrix = kernel_matrix - IN * kernel_matrix - kernel_matrix * IN + IN * kernel_matrix * IN;
end

if pc_count_or_variance < 1
    cumulative_ratio = pc_count_or_variance;
    [eig_vectors, B] = eig(kernel_matrix);
    [B, ind] = sort(diag(B), 'descend');
    eig_vectors = eig_vectors(:, ind);
    eig_values = B / num_samples;
    num_components = find(cumsum(eig_values) / sum(eig_values) >= cumulative_ratio, 1);
    eig_vectors = eig_vectors(:, 1:num_components);
    B = B(1:num_components);
    eig_vectors = eig_vectors / sqrt(diag(B));
    eig_values = eig_values(1:num_components);
    eig_ratio = sum(eig_values);
    
elseif pc_count_or_variance >= 1
    num_components = floor(pc_count_or_variance);
    OPTS.disp = 0;
    [eig_vectors, B] = eigs(kernel_matrix, num_components, 'LM', OPTS);
    [B, ind] = sort(diag(B), 'descend');
    eig_vectors = eig_vectors(:, ind);
    eig_values = B / num_samples;
    eig_vectors = eig_vectors / sqrt(diag(B));
    eig_ratio = sum(eig_values);
end
num_principal_components = size(eig_vectors, 2);
end

% function [eig_vectors, eig_values, eig_ratio, kernel_matrix, num_principal_components] = computeKernelPCA(X, pc_count_or_variance, sigma, method,varargin)
% X = X(:, :);
% [~, num_samples] = size(X);
% use_covariance_matrix = true;

% % Assume 'method' is an instance of GramMatrixType and is passed as a parameter
% % If 'method' is not passed, you can set a default method. For example:
% if ~exist('method', 'var')
%     method = GramMatrixType.gaussian;
% end

% switch method
%     case GramMatrixType.rff
%         rff_dim = varargin{1};
%         kernel_matrix = computeGramMatrixRFF(X, rff_dim, sigma);
%     case GramMatrixType.nystrom
%         num_sub_samples = varargin{1};
%        kernel_matrix = computeGramMatrixNystrom(X, num_samples, num_sub_samples); 
%     case GramMatrixType.gaussian
%         kernel_matrix = computeGaussianKernelMatrix(X, sigma);
        
%     otherwise
%         error('Unknown method');
% end


% if use_covariance_matrix
%     IN = ones(num_samples) / num_samples;
%     kernel_matrix = kernel_matrix - IN * kernel_matrix - kernel_matrix * IN + IN * kernel_matrix * IN;
% end

% if pc_count_or_variance < 1
%     cumulative_ratio = pc_count_or_variance;
%     [eig_vectors, B] = eig(kernel_matrix);
%     [B, ind] = sort(diag(B), 'descend');
%     eig_vectors = eig_vectors(:, ind);
%     eig_values = B / num_samples;
%     num_components = find(cumsum(eig_values) / sum(eig_values) >= cumulative_ratio, 1);
%     eig_vectors = eig_vectors(:, 1:num_components);
%     B = B(1:num_components);
%     eig_vectors = eig_vectors / sqrt(diag(B));
%     eig_values = eig_values(1:num_components);
%     eig_ratio = sum(eig_values);
    
% elseif pc_count_or_variance >= 1
%     num_components = floor(pc_count_or_variance);
%     OPTS.disp = 0;
%     [eig_vectors, B] = eigs(kernel_matrix, num_components, 'LM', OPTS);
%     [B, ind] = sort(diag(B), 'descend');
%     eig_vectors = eig_vectors(:, ind);
%     eig_values = B / num_samples;
%     eig_vectors = eig_vectors / sqrt(diag(B));
%     eig_ratio = sum(eig_values);
% end
% num_principal_components = size(eig_vectors, 2);
% end
