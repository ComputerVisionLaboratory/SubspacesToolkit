function kernel_matrix = computeGramMatrixNystom(X, sigma, m, Y)
    if nargin < 4
        Y = X;
    end
    
    num_samples_X = size(X, 2);
    num_samples_Y = size(Y, 2);

    landmark_indices = randperm(num_samples_X, m);
    X_landmarks = X(:, landmark_indices);

    K_mm = computeGaussianKernelMatrix(X_landmarks, sigma);
    K_nm_X = computeGaussianKernelMatrix(X, X_landmarks, sigma);
    K_nm_Y = computeGaussianKernelMatrix(Y, X_landmarks, sigma);

    [U_m, Lambda_m] = eig(K_mm);
    [Lambda_m, ind] = sort(diag(Lambda_m), 'descend');
    U_m = U_m(:, ind);

    kernel_matrix = K_nm_X * U_m * diag(1./sqrt(Lambda_m)) * U_m' * K_nm_Y';

    % Ensure symmetry for the single matrix case
    if nargin < 4
        kernel_matrix = (kernel_matrix + kernel_matrix') / 2;
    end
end
