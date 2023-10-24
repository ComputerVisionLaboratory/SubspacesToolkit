function similarities = computeKernelSubspacesSimilarities(X1, A1, X2, A2, nSigma)
    % computeKernelSubspacesSimilarities computes the similarities between subspaces using a kernelized method.
    %
    % Input:
    % - X1: The primary data matrix.
    % - A1: The primary coefficient matrix.
    % - varargin: Additional input arguments, depending on the number of inputs this function handles different scenarios.
    %
    % Output:
    % - similarities: A 4D matrix containing the computed similarities between subspaces.
    %
    % Usage:
    % For self similarity: similarities = computeKernelSubspacesSimilarities(X1, A1, nSigma)
    % For cross similarity: similarities = computeKernelSubspacesSimilarities(X1, A1, X2, A2, nSigma)
    
    % Ensure all matrices are 3D
    X1 = X1(:,:,:);
    A1 = A1(:,:,:);
    X2 = X2(:,:,:);
    A2 = A2(:,:,:);
    
    [nNum1, nSubDim1, nSet1] = size(A1);
    [nNum2, nSubDim2, nSet2] = size(A2);
    B = zeros(nSet1, nSet2, nSubDim1, nSubDim2);
            
    % Compute similarities using the kernel matrix
    for I = 1:nSet1
        for J = 1:nSet2
            K = exp(-orzL2Distance(X1(:,:,I), X2(:,:,J)) / nSigma);
            B(I, J, :, :) = (A1(:,:,I)' * K * A2(:,:,J)).^2;
        end
    end
    
    % Cumulatively sum and normalize
    similarities = cumsum(cumsum(B, 3), 4);
    for S1 = 1:nSubDim1
        for S2 = 1:nSubDim2
            similarities(:,:,S1,S2) = similarities(:,:,S1,S2) / min([S1, S2]);
        end
    end
    
    end
    