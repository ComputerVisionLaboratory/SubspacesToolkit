function labels = generateLabels(num_samples, varargin)
    % generateLabels Generates a vector of labels for dataset samples.
    %
    % This function creates a vector of integer labels for a dataset based on
    % the specified number of samples, classes, and sets. Labels are assigned
    % in a repeating sequential manner across the classes for each set.
    %
    % Parameters:
    %   num_samples (integer): The number of samples in each class.
    %   varargin: Optional input arguments to specify number of classes and sets.
    %     - If one additional argument is provided, it specifies the number of classes.
    %     - If two additional arguments are provided, the first specifies the number
    %       of classes, and the second specifies the number of sets.
    %
    % Returns:
    %   labels (1 x N integer array): The generated vector of labels, where N is the
    %     total number of samples across all classes and sets.
    %
    % Usage:
    %   labels = generateLabels(100);
    %   % Generates 100 labels, all assigned to a single class and set.
    %
    %   labels = generateLabels(100, 5);
    %   % Generates 500 labels for 5 classes, each class having 100 samples,
    %   % all within a single set.
    %
    %   labels = generateLabels(100, 5, 3);
    %   % Generates 1500 labels for 5 classes and 3 sets, each class having
    %   % 100 samples in each set.
    %
    % Errors:
    %   - An error is thrown if the number of input arguments is less than 1 or more than 3.
    %
    % Example:
    %   labels = generateLabels(10, 3, 2)
    %   % Returns: [1 2 3 1 2 3 1 2 3 1 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3]
    
        % Validate the number of input arguments
        if nargin < 1
            error('Not enough input arguments.');
        elseif nargin == 1
            num_classes = 1;  % Set default number of classes to 1
            num_sets = 1;     % Set default number of sets to 1
        elseif nargin == 2
            num_classes = varargin{1};  % Get number of classes from input
            num_sets = 1;               % Set default number of sets to 1
        elseif nargin == 3
            num_classes = varargin{1};  % Get number of classes from input
            num_sets = varargin{2};     % Get number of sets from input
        else
            error('Too many input arguments.');
        end
    
        % Create a matrix of class labels, repeating each class label 'num_samples' times
        % and then repeating the whole sequence for each set.
        A = repmat(1:num_classes, [num_samples, num_sets]);
    
        % Convert the matrix of class labels into a single row vector
        labels = A(:)';
    end
    