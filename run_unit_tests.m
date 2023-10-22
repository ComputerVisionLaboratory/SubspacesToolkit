clc
functions_to_test = {'computePCA', 'computeBasisVectors'};
num_of_functions = numel(functions_to_test);

for i = 1:num_of_functions
    % Capitalize the first letter of the function name
    func_name_capitalized = functions_to_test{i};
    func_name_capitalized(1) = upper(func_name_capitalized(1));
    
    % Create the test function name
    test_function_name = ['test', func_name_capitalized];
    
    % Run the test function
    results = runtests(test_function_name);
    disp(results)
end

