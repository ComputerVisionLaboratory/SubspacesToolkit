function RSLT = svdMSMEval(train_data, test_data, ref_subdim, inp_subdim, showFlag)

if ndims(test_data) == 4
    testSet = size(test_data, 3);
else
    testSet = 1;
end

nClass = size(train_data, 3);

RSLT = cell(size(inp_subdim, 2), size(ref_subdim, 2));
highest_accuracy = 0;
highest_ref_subdim = 0;
highest_in_subdim = 0;
i_index = 0;
j_index = 0;
for i = 1:size(ref_subdim, 2)
    V1 = computeBasisVectors(train_data, ref_subdim{i});
    for j = 1:size(inp_subdim, 2)
        V2 = computeBasisVectors(test_data, inp_subdim{j});
        sim = computeSubspacesSimilarities(V1, V2);
        RSLT{j, i} = ModelEvaluation(sim(:, :, end, end), generateLabels(testSet, nClass));
        if showFlag == true
            fprintf('subdim1: %d, indim %d, ER: %0.3f%%, accuracy %0.3f%% \n', ref_subdim{i}, inp_subdim{j}, RSLT{j, i}.error_rate, RSLT{j, i}.accuracy * 100);
        end
        if RSLT{j, i}.accuracy > highest_accuracy
            highest_accuracy = RSLT{j, i}.accuracy;
            highest_ref_subdim = ref_subdim{i};
            highest_in_subdim = inp_subdim{j};
            i_index = i;
            j_index = j;
        end
    end
end

best_result = RSLT{j_index, i_index};
displayModelResults('Mutual Subspace Methods', best_result, highest_ref_subdim, highest_in_subdim);
end