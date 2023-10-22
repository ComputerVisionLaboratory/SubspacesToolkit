function [coeff, score, latent] = simplePCA(data)
    % Center the data
    data_centered = data - mean(data);
    
    % Calculate covariance matrix
    covarianceMatrix = cov(data_centered);
    
    % Perform eigenvalue decomposition
    [coeff, latent] = eig(covarianceMatrix);
    
    % Calculate the scores
    score = data_centered * coeff;
    
    % Sort the components by explained variance (in descending order)
    [latent, idx] = sort(diag(latent), 'descend');
    coeff = coeff(:, idx);
    score = score(:, idx);
end
