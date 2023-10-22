function [basis_vectors] = computeBasisVectors(X, num_sub_dim)
    size_of_X = size(X);
    num_sets = prod(size_of_X)/prod(size_of_X(1:2));
    X = reshape(X, size_of_X(1), size_of_X(2), num_sets);
    basis_vectors = zeros(size_of_X(1), num_sub_dim, num_sets);
    for i = 1:num_sets
        [~, basis_vectors(:,:,i), ~, ~, ~] = computePCA(X(:,:,i), num_sub_dim)
    end
