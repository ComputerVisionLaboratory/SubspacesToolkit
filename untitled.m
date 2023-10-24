rng(42);  % Set the random number generator seed to ensure reproducibility
X = rand(10, 7, 4);  % Generate a 10x7x4 matrix of random numbers from 0 to 1
S = computeKernelBasisVectors(X, 0.6, 1);  % Compute the similarities between the subspaces
size(S)
S(:, :, 1)
