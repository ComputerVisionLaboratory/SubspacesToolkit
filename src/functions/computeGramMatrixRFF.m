function K = computeGramMatrixRFF(X, D, sigma, varargin)
    use_x_and_y = false;
    if nargin > 3
        Y = varargin{1};
        use_x_and_y = true;
    end
    if use_x_and_y
        Z_X = computeRFF(X, D, sigma);
        Z_Y = computeRFF(Y, D, sigma);
        K = Z_X * Z_Y';
    else
        Z_X = computeRFF(X, D, sigma);
        K = Z_X * Z_X';
    end
end
