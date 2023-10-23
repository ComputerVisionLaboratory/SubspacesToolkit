classdef testComputePCA < matlab.unittest.TestCase
    
    methods (Test)
        function testPCADimensions(testCase)
            data = rand(4, 4);
            num_sub_dim = 2;
            [eig_vecs, eig_vals, eig_rat] = computePCA(data, num_sub_dim);
            verifySize(testCase, eig_vecs, [size(data, 1), num_sub_dim]);
            verifySize(testCase, eig_vals, [num_sub_dim, 1]);
            verifySize(testCase, eig_rat, [1,1]);
        end

        function testPCACovMatrix(testCase)
            data = [1, 2, 3, 4; 5, 6, 7, 8];
            num_sub_dim = 2;
            [eig_vecs, eig_vals, eig_rat] = computePCA(data, num_sub_dim);

            % expected values
            exp_eig_vecs = [0.7071, -0.7071; 0.7071, 0.7071];
            exp_eig_vals = [2.5000; 0];
            exp_eig_rat = 1;

            % Custom comparison function to handle sign ambiguity in PCA
            verifyEqual(testCase, abs(eig_vecs), abs(exp_eig_vecs), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_vals), abs(exp_eig_vals), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_rat), abs(exp_eig_rat), 'AbsTol', 0.0001);
        end

        function testPCACorrelationMatrix(testCase)
            data = [1, 2, 3, 4; 5, 6, 7, 8];
            num_sub_dim = 2;
            [eig_vecs, eig_vals, eig_rat] = computePCA(data, num_sub_dim, 'R');

            % expected values
            exp_eig_vecs = [ 0.3762,  -0.9266; 0.9266, 0.3762];
            exp_eig_vals = [67.4730; 0.5270];
            exp_eig_rat = 1;

            % Custom comparison function to handle sign ambiguity in PCA
            verifyEqual(testCase, abs(eig_vecs), abs(exp_eig_vecs), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_vals), abs(exp_eig_vals), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_rat), abs(exp_eig_rat), 'AbsTol', 0.0001);
        end

        function testPCAOnCumultativeRatio(testCase)
            data = [1, 2, 3, 4; 5, 6, 7, 8];
            c_rate = 0.6;
            [eig_vecs, eig_vals, eig_rat] = computePCA(data, c_rate, 'R');
            
            % expected values
            exp_eig_vecs = [ 0.3762; 0.9266];
            exp_eig_vals = 67.4730;
            exp_eig_rat = 0.9923;
            
            % Custom comparison function to handle sign ambiguity in PCA
            verifyEqual(testCase, abs(eig_vecs), abs(exp_eig_vecs), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_vals), abs(exp_eig_vals), 'AbsTol', 0.0001);
            verifyEqual(testCase, abs(eig_rat), abs(exp_eig_rat), 'AbsTol', 0.0001);
        end
    end
    
end
