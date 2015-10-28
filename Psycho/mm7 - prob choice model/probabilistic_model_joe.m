clc
%% Example of use for the probabilistic model.
%
% Joe.

disp(sprintf('>> Example of use for the probabilistic model.\n'));

% Sounds: 
% 1 - truck
% 2 - brake
% 3 - train
% 4 - water
% 5 - boat
% 6 - jackhammer
% 7 - mower
% 8 - crash
% 9 - mixer
% 10 - vent.

unpleasant=[
0 9 16 45 56 5 29 6 24 33
51 0 34 58 58 13 46 30 39 50
44 26 0 55 57 9 48 37 38 55
15 2 5 0 38 2 17 6 6 20
4 2 3 22 0 3 6 3 3 12
55 47 51 58 57 0 58 53 55 57
31 14 12 43 54 2 0 16 17 41
54 30 23 54 57 7 44 0 40 52
36 21 22 54 57 5 43 20 0 43
27 10 5 40 48 3 19 8 17 0];

% 1 - Finding the amount of violations

disp('Counting the amount of transitivity violations ...');

% Finds the normalization factor
normalization_factor = sum(sum(unpleasant))/ (numel(unpleasant) - length(unpleasant)) * 2;

% Normalizes the input data matrix
prob = unpleasant / normalization_factor;

amount_weak_violations = 0;
amount_moderate_violations = 0;
amount_strong_violations = 0;

amount_of_tests = 0;
amount_of_checks = 0;

for a = 1 : 10
    for b = 1 : 10
        for c = 1 : 10

            % Eliminates the case where some (or all) are the same
            if a ~= b && a ~= c && b ~= c

                amount_of_tests = amount_of_tests + 1;
                
                % Checks the probabilities are greater than 0.5
                if prob(a,b) >= 0.5 && prob(b,c) >= 0.5

                    amount_of_checks = amount_of_checks + 1;
                    
                    if prob(a,c) < 0.5 
                        % Weak violation
                        amount_weak_violations = amount_weak_violations + 1;
                    end

                    if prob(a,c) < min(prob(a,b), prob(b,c))
                        % Moderate violation
                        amount_moderate_violations = amount_moderate_violations + 1;
                    end

                    if prob(a,c) < max(prob(a,b), prob(b,c))
                        % Strong violation
                        amount_strong_violations = amount_strong_violations + 1;
                    end

                end
            end            
        end
    end
end

disp(sprintf('Amount of total items tested: %d', amount_of_tests));
disp(sprintf('Amount of checks: %d\n', amount_of_checks));

disp(sprintf('Amount of violations:       Weak       Moderate        Strong\n-----------------------------------------------------------------\n                             %.3d         %.3d            %.3d\n', amount_weak_violations, amount_moderate_violations, amount_strong_violations));


% 2 - Analyze data with BTL-model using function fOptiPt.m
A = {[1]; [2]; [3]; [4]; [5]; [6]; [7]; [8]; [9]; [10]};
[p,chistat,u,lL_eba,lL_sat,fit,cova] = fOptiPt(unpleasant, A);

% 3 - Check how well the model fits
if chistat(3) < 0.1
    disp('ERROR: the goodness of fit is not good enough (below 0.1)!');
    return
end

% 3 - Compute the 95% confidence intervals
confidence_intervals = 2 * 1.96 * sqrt(diag(cova));

% 4 - Now we plot the scale values
errorbar([1:10], u, confidence_intervals, 'o', 'MarkerSize', 5);
xlim([1 10]);
ylim([0 1.5]);
grid
xlabel('Type of sound');
ylabel('Unpleasentness');


% Note:
%
% chistat(3) -> tells you how well the model fits
% Then from the covariance matrix extract the diagonal and compute the
% formula: 
%
% u = +- 1.96 sqrt( diag(cov(p)))
% and then, those are the margin for the "errorbar" plot
