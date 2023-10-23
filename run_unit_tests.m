clc;

% List of functions to test
functions_to_test = {'ComputePCA',...
                    'ComputeBasisVectors',...
                    'ComputeSubspacesSimilarities'};

functions_to_test = functions_to_test(1, end);

% Run tests for each function
for func_name = functions_to_test
    runTestsForFunction(char(func_name));
end

function runTestsForFunction(func_name)
    try
        % Generate the test function name based on the function name
        test_function_name = ['test', func_name];

        % Trim leading and trailing whitespace
        test_function_name = strtrim(test_function_name);        

        % Check if the test function exists
        if exist(test_function_name, 'file') ~= 2
            error('Test function "%s" does not exist.', test_function_name);
        end
        
        % Run the test function
        results = runtests(test_function_name);
        
        % Display results
        displayTestResults(results, func_name);
    catch ME
        fprintf('Error running tests for "%s": %s\n', func_name, ME.message);
    end
end

function displayTestResults(results, func_name)
    fprintf('\nResults for "%s":\n', func_name);
    fprintf('----------------------------------------\n');
    
    if all([results.Passed])
        fprintf('All %d tests passed.\n', numel(results));
    else
        fprintf('%d out of %d tests failed.\n', sum([results.Failed]), numel(results));
        disp(results([results.Failed]));
    end
    
    fprintf('----------------------------------------\n');
end
