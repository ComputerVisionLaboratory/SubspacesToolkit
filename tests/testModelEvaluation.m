classdef testModelEvaluation < matlab.unittest.TestCase
    
    methods (Test)
        function testSimilaritiesSingleClass(testCase)
            values = [0.9, 0.8, 0.2, 0.4];
            labels = [1, 1, 0, 0];
            modelEval = ModelEvaluation(values, labels);
            
            testCase.verifyEqual(modelEval.error_rate, 0);
            testCase.verifyEqual(modelEval.equal_error_rate, 0);
            testCase.verifyEqual(modelEval.false_accept_rate, [1; 0.5; 0; 0]);
            testCase.verifyEqual(modelEval.false_reject_rate, [0; 0; 0.5; 1]);
            testCase.verifyEqual(modelEval.num_positive_samples, 2);
            testCase.verifyEqual(modelEval.num_negative_samples, 2);
            testCase.verifyEqual(modelEval.is_similarity, true);
        end
        
        function testDistancesSingleClass(testCase)
            values = [0.2, 0.4, 0.9, 0.8];
            labels = [1, 1, 0, 0];
            modelEval = ModelEvaluation(values, labels, 'D');
            
            testCase.verifyEqual(modelEval.error_rate, 0);
            testCase.verifyEqual(modelEval.equal_error_rate, 0);
            testCase.verifyEqual(modelEval.false_accept_rate, [0; 0; 0.5; 1]);
            testCase.verifyEqual(modelEval.false_reject_rate, [1; 0.5; 0; 0]);
            testCase.verifyEqual(modelEval.num_positive_samples, 2);
            testCase.verifyEqual(modelEval.num_negative_samples, 2);
            testCase.verifyEqual(modelEval.is_similarity, false);
        end
        
        function testSimilaritiesMultiClass(testCase)
            values = [0.9, 0.8, 0.2, 0.4; 0.2, 0.3, 0.7, 0.6];
            labels = [1, 1, 2, 2];
            modelEval = ModelEvaluation(values, labels);
            
            testCase.verifyEqual(modelEval.error_rate, 0);
            testCase.verifyEqual(modelEval.equal_error_rate, 0);
            testCase.verifyEqual(modelEval.num_positive_samples, 4);
            testCase.verifyEqual(modelEval.num_negative_samples, 0);
            testCase.verifyEqual(modelEval.is_similarity, true);
        end
        
        function testDistancesMultiClass(testCase)
            values = [0.2, 0.4, 0.9, 0.8; 0.9, 0.8, 0.2, 0.4];
            labels = [1, 1, 2, 2];
            modelEval = ModelEvaluation(values, labels, 'D');
            
            testCase.verifyEqual(modelEval.error_rate, 0);
            testCase.verifyEqual(modelEval.equal_error_rate, 0);
            testCase.verifyEqual(modelEval.num_positive_samples, 4);
            testCase.verifyEqual(modelEval.num_negative_samples, 0);
            testCase.verifyEqual(modelEval.is_similarity, false);
        end
    end
    
end
