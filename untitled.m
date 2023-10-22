rng(42);  % Set the random number generator seed to ensure reproducibility
random_matrix = rand(10, 7, 4);  % Generate a 10x7x4 matrix of random numbers from 0 to 1
basis_vecs = computeBasisVectors(random_matrix, 3);
basis_vecs