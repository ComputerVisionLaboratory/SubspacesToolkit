function K = computeGaussianKernelMatrix(X, varargin)
% computeGaussianKernelMatrix - Computes Gaussian kernel matrix between two sets of data.
%
% Syntax:
% K = computeGaussianKernelMatrix(X) 
% K = computeGaussianKernelMatrix(X, sigma)
% K = computeGaussianKernelMatrix(X, Y, sigma)
%
% Parameters:
%   X     - [n x d] matrix where each row is a d-dimensional data point
%   vargin - Variable input arguments that can be used to specify Y and sigma
%       Y     - [m x d] matrix where each row is a d-dimensional data point
%       sigma - Gaussian kernel parameter
%
% Returns:
%   K - [n x n] or [n x m] Gaussian kernel matrix
% Last Update: 2023/10 by Santos Enoque
% Computer Vision Laboratory, University of Tsukuba
% http://www.cvlab.cs.tsukuba.ac.jp/

    if nargin == 2
        % Extract sigma value
        sigma = varargin{1};
        
        % Check if sigma is a positive scalar
        assert(isnumeric(sigma) && isscalar(sigma) && sigma > 0, ...
            'Sigma should be a positive scalar.');
        
        % Ensure X is in a 2D format
        X = X(:, :);
        
        % Compute Gaussian kernel matrix for X with itself
        K = exp(-cvlL2Distance(X, X) / sigma);

    elseif nargin == 3
        % Extract Y and sigma values
        Y = varargin{1};
        sigma = varargin{2};
        
        % Check if sigma is a positive scalar
        assert(isnumeric(sigma) && isscalar(sigma) && sigma > 0, ...
            'Sigma should be a positive scalar.');
        
        % Check if Y is a matrix
        assert(ismatrix(Y), 'Y should be a 2D matrix.');
        
        % Ensure X and Y are in 2D format
        X = X(:, :);
        Y = Y(:, :);
        
        % Compute Gaussian kernel matrix between X and Y
        K = exp(-cvlL2Distance(X, Y) / sigma);
    else
        error('Incorrect number of input arguments. Refer to the function documentation.');
    end
end
