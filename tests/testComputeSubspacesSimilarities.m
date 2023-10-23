classdef testComputeSubspacesSimilarities < matlab.unittest.TestCase
    
    methods(Test)
        
        function testDefaultMethod(testCase)
            X = rand(3, 2, 4);
            Y = rand(3, 2, 5);
            expectedSize = [4, 5, 2, 2];
            
            similarities = computeSubspacesSimilarities(X, Y);
            
            testCase.verifySize(similarities, expectedSize);
            % Add more verification checks as needed
        end
        
        function testSvdMethod(testCase)
            X = rand(3, 2, 4);
            Y = rand(3, 2, 5);
            expectedSize = [4, 5, 2];
            
            similarities = computeSubspacesSimilarities(X, Y, 'F');
            
            testCase.verifySize(similarities, expectedSize);
            % Add more verification checks as needed
        end

        function testInvalidSubspaceSize(testCase)
            X = rand(3, 2, 4);  % 3-dimensional subspace
            Y = rand(2, 2);  % 2-dimensional subspace (less than 3)
            
            expectedErrorID = '';
            testCase.verifyError(@() computeSubspacesSimilarities(X, Y), expectedErrorID);
            
            X = rand(5, 2, 4, 2, 3);  % 5-dimensional subspace (greater than 4)
            Y = rand(3, 2, 5);  % 3-dimensional subspace
            testCase.verifyError(@() computeSubspacesSimilarities(X, Y), expectedErrorID);
        end 
    end
end
