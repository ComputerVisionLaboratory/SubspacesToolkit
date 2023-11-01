function Z = computeRFF(X, D, sigma)
[n, d] = size(X);
% W = normrnd(0, 1/sigma, [d, D]);
W = randn(d, D) / sigma;
b = 2 * pi * rand(1, D);
Z = sqrt(2/D) * cos(X * W + repmat(b, n, 1));
end
