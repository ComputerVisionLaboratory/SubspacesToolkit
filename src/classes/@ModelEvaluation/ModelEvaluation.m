classdef ModelEvaluation
    properties
        accuracy;                 % Accuracy
        error_rate;                % Overall error rate
        equal_error_rate;         % Equal error rate (point where FAR and FRR are approximately equal)
        classification_threshold; % Threshold used for classification
        
        sorted_values;            % Sorted evaluation values (either similarities or distances)
        false_accept_rate;        % False accept rate (FAR)
        false_reject_rate;        % False reject rate (FRR)
        
        num_positive_samples;     % Number of positive samples
        num_negative_samples;     % Number of negative samples
        
        is_similarity;            % Flag indicating if values represent similarities (true) or distances (false)
    end

    methods
        function obj = ModelEvaluation(evaluation_values, labels, optional_flag)
            % Constructor for ModelEvaluation class.
            % 
            % Parameters:
            % - evaluation_values: Matrix of evaluation scores (either similarities or distances).
            % - labels: Actual labels corresponding to evaluation_values.
            % - optional_flag: (Optional) If 'D', values are treated as distances. Otherwise, as similarities.
            
            % Check if values represent similarities or distances
            obj.is_similarity = true;
            if nargin == 3 && optional_flag == 'D'
                obj.is_similarity = false;
            end

            evaluation_values = evaluation_values(:, :);
            is_multiclass_scenario = size(evaluation_values, 1) > 1;
            if is_multiclass_scenario
                binary_labels = zeros(size(evaluation_values));
                unique_labels = unique(labels);
                for i = 1:size(unique_labels, 2)
                    binary_labels(i, labels == unique_labels(i)) = 1;
                end

                if obj.is_similarity
                    [~, predicted_labels] = max(evaluation_values, [], 1);
                else
                    [~, predicted_labels] = min(evaluation_values, [], 1);
                end
                obj.accuracy = mean(predicted_labels == labels); 
                obj.error_rate = 1 - obj.accuracy;
            else
                binary_labels = zeros(size(labels));
                binary_labels(labels ~= 0) = 1;
                predicted_labels = evaluation_values >= obj.classification_threshold;
                obj.accuracy = mean(predicted_labels == binary_labels);
            end

            evaluation_values = evaluation_values(:);
            binary_labels = binary_labels(:);

            obj.num_positive_samples = sum(binary_labels == 1);
            obj.num_negative_samples = sum(binary_labels == 0);

            % Sort evaluation values
            if obj.is_similarity
                [obj.sorted_values, sorted_indices] = sort(evaluation_values, 'ascend');
            else
                [obj.sorted_values, sorted_indices] = sort(evaluation_values, 'descend');
            end

            sorted_binary_labels = binary_labels(sorted_indices);

            obj.false_accept_rate = 1 - cumsum(sorted_binary_labels == 0) / obj.num_negative_samples;
            obj.false_reject_rate = cumsum(sorted_binary_labels == 1) / obj.num_positive_samples;

            % Compute equal error rate
            [~, eer_index] = min(abs(obj.false_accept_rate - obj.false_reject_rate));
            obj.equal_error_rate = (obj.false_accept_rate(eer_index) + obj.false_reject_rate(eer_index)) / 2;
            obj.classification_threshold = obj.sorted_values(eer_index);
        end
    end
end
