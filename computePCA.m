function [eig_vectors, eig_values, eig_ratio] = computePCA(X, num_sub_dim, varargin)
    % computePCA: compute PCA of X
    % Input:
    %   X: num_dim x num_samples data matrix
    %   num_sub_dim: number of sub-dimensions to keep (Principal Components). if num_sub_dim < 1
    %                then it is the ratio of variance to keep
    %   varargin: if not specified PCA is computed on covariance matrix, 
    %             if set to 'R' then PCA is computed on correlation matrix
    % Output:
    %   Z: projected data to the principal components
    %   eig_vectors: eigenvectors of the covariance/correlation matrix
    %   eig_values: eigenvalues of the covariance/correlation matrix
    %   eig_ratio: ratio of variance explained by each principal component
    % Last Update: 2023/10 by Santos Enoque
    % Computer vison laboratory, University of Tsukuba
    % http://www.cvlab.cs.tsukuba.ac.jp/ 
    X = X(:, :);
    [num_dim, num_samples] = size(X);

    use_covariance_matrix = true;
    if nargin > 2
        if strcmp(varargin{1}, 'R')
            use_covariance_matrix = false;
        end
    end

    apply_matrix_normalization = use_covariance_matrix;

    if num_sub_dim < 1
        c_ratio = num_sub_dim;
        if num_dim < num_samples
            if use_covariance_matrix
                C = cov(X', 1);
            else
                C = X*X'/(num_samples-1);
            end
            [eig_vectors, temp_diagonal] = eig(C);
            [eig_values, ind] = sort(diag(temp_diagonal), 'descend');
            eig_vectors = eig_vectors(:, ind);
            num_sub_dim = find(cumsum(eig_values)/sum(eig_values) >= c_ratio, 1);
            eig_vectors = eig_vectors(:, 1:num_sub_dim);
            eig_values = eig_values(1:num_sub_dim);
            eig_ratio = sum(eig_values)/trace(C);
        else
            if apply_matrix_normalization
                K = X'*X;
                IN = ones(num_samples, num_samples)/num_samples; 
                K = K - IN*K - K*IN + IN*K*IN;
            else
                K = X'*X;
            end
            [A, B] = eig(K);
            [B, ind] = sort(diag(B), 'descend');            
            A = A(:, ind);
            eig_values = B/num_samples;
            num_sub_dim = find(cumsum(eig_values)/sum(eig_values) >= c_ratio, 1);
            A = A(:, 1:num_sub_dim);
            B = B(1:num_sub_dim);
            A = A/sqrt(diag(B));
            eig_vectors = X*A;
            eig_values = eig_values(1:num_sub_dim);
            eig_ratio = sum(eig_values);
        end
    elseif num_sub_dim >= 1 
        num_sub_dim = floor(num_sub_dim);
        if num_dim < num_samples
            if use_covariance_matrix
                C = cov(X', 1);
            else
                C = X*X'/(num_samples-1);
            end

            OPTS.disp = 0;
            if num_sub_dim < num_dim
                [eig_vectors, temp_diagonal] = eigs(C, num_sub_dim, 'LM', OPTS);
            else
                [eig_vectors, temp_diagonal] = eig(C);
            end
            [eig_values, ind] = sort(diag(temp_diagonal), 'descend');
            eig_vectors = eig_vectors(:, ind);
            eig_ratio = sum(eig_values)/trace(C);
        else
            if apply_matrix_normalization
                K = X'*X;
                IN = ones(num_samples, num_samples)/num_samples; 
                K = K - IN*K - K*IN + IN*K*IN;
            else
                K = X'*X;
            end
            OPTS.disp = 0;
            [A, B] = eigs(K, num_sub_dim, 'LM', OPTS);
            [B, ind] = sort(diag(B), 'descend');
            A = A(:, ind);
            eig_values = B/num_samples;
            A = A/sqrt(diag(B));
            eig_vectors = X*A;
            eig_ratio = sum(eig_values);
        end
    end
   