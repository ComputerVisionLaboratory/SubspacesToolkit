classdef testComputeBasisVectors < matlab.unittest.TestCase
    
    methods (Test)
        function testPositiveIntegerNumSubDim(testCase)
            X = rand(10, 20, 5);
            num_sub_dim = 5;
            basis_vectors = computeBasisVectors(X, num_sub_dim);
            expected_size = [10, 5, 5];
            verifySize(testCase, basis_vectors, expected_size);
        end

        function testRatioNumSubDim(testCase)
            X = rand(10, 20, 5);
            num_sub_dim = 0.95;
            basis_vectors = computeBasisVectors(X, num_sub_dim);
            expected_size = [10, 20, 5];
            actual_size = size(basis_vectors);
            verifyLessThanOrEqual(testCase, actual_size(2), expected_size(2));
        end

        function testInvalidNumSubDim(testCase)
            X = rand(10, 20, 5);
            num_sub_dim = -5;
            verifyError(testCase, @() computeBasisVectors(X, num_sub_dim), '');
        end

        function testInvalidRatioNumSubDim(testCase)
            X = rand(10, 20, 5);
            num_sub_dim = 1.5;
            verifyError(testCase, @() computeBasisVectors(X, num_sub_dim), '');
        end

        function test4DInput(testCase)
            X = rand(10, 20, 3, 5);
            num_sub_dim = 5;
            basis_vectors = computeBasisVectors(X, num_sub_dim);
            expected_size = [10, 5, 3, 5];
            verifySize(testCase, basis_vectors, expected_size);
        end

        function testOrthogonalityOfBasisVectors(testCase)
            X = rand(10, 20, 5);
            num_sub_dim = 5;
            basis_vectors = computeBasisVectors(X, num_sub_dim);
            
            num_sets = size(basis_vectors, 3);
            
            for i = 1:num_sets
                basis_set = basis_vectors(:,:,i);
                dot_product_matrix = basis_set' * basis_set;
                identity_matrix = eye(size(dot_product_matrix));
                % Check if the dot product matrix is approximately an identity matrix
                verifyEqual(testCase, dot_product_matrix, identity_matrix, 'AbsTol', 1e-10);
            end
        end
    end
    
end
