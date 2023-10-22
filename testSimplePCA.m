function tests = testSimplePCA
tests = functiontests(localfunctions);
end

function testPCADimensions(testCase)
data = rand(10, 3);
[coeff, score, latent] = simplePCA(data);
verifySize(testCase, coeff, [3, 3]);
verifySize(testCase, score, [10, 3]);
verifySize(testCase, latent, [3, 1]);
end

function testPCAValues(testCase)
data = [1, 2; 3, 4; 5, 6];

% Centering the data manually
data = data - mean(data);

[coeff, score, ~] = simplePCA(data);

% Define expected values
expCoeff = [0.7071, 0.7071; -0.7071, 0.7071];
expScore = [-2.8284, 0; 0, 0; 2.8284, 0];

% Custom comparison function to handle sign ambiguity in PCA
verifyEqual(testCase, abs(coeff), abs(expCoeff), 'AbsTol', 0.0001);
verifyEqual(testCase, abs(score), abs(expScore), 'AbsTol', 0.0001);
end
