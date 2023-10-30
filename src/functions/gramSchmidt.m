function eig_vectors = gramSchmidt(X, n)
% gramSchmidt: Compute an orthogonal basis using the Gram-Schmidt process.
%
% Syntax:
%   eig_vectors = gramSchmidt(X)
%   eig_vectors = gramSchmidt(X, n)
%
% Description:
%   gramSchmidt applies the Gram-Schmidt process to a set of column vectors 
%   to compute an orthogonal basis. If the number of vectors to orthogonalize, n, 
%   is specified, it returns the first n orthogonal vectors.
%
% Inputs:
%   X - Matrix (m x k) of k column vectors each of dimension m.
%   n - (Optional) Scalar specifying the number of orthogonal vectors to obtain.
%       If not specified, the function orthogonalizes all the input vectors.
%
% returns:
%   eig_vectors - Matrix (m x n) of n orthogonal vectors.
%
% Examples:
%   % Example 1: Compute an orthogonal basis for all column vectors in X
%   orthogonal_basis = gramSchmidt(X);
%
%   % Example 2: Compute an orthogonal basis for the first 3 column vectors in X
%   orthogonal_basis = gramSchmidt(X, 3);
%
% Notes:
%   - If n is not specified, MATLAB's built-in `orth` function is used to 
%     orthogonalize all column vectors.
%   - If n is specified, the function applies the Gram-Schmidt process to 
%     orthogonalize the first n vectors.
%
% Created by: Computer vison laboratory, University of Tsukuba
% Last Update: 2023/10 by Santos Enoque
% http://www.cvlab.cs.tsukuba.ac.jp/ 
    
    % Check number of input arguments
    if nargin < 2
        % If n is not specified, use MATLAB's built-in function to orthogonalize all vectors
        eig_vectors = orth(X);
    else
        % Initialize variables
        dim = size(X, 1);              % Dimension of the vectors
        eig_vectors = zeros(dim, n);   % Initialize matrix to store orthogonal vectors
        
        % First orthogonal vector is the normalized first vector from X
        eig_vectors(:, 1) = X(:, 1) / norm(X(:, 1));
        
        % Apply Gram-Schmidt process to obtain n orthogonal vectors
        for i = 2:n
            v = X(:, i);
            for j = 1:i-1
                v = v - (eig_vectors(:, j)' * X(:, i)) * eig_vectors(:, j);
            end
            eig_vectors(:, i) = v / norm(v);
        end
    end
    end
    