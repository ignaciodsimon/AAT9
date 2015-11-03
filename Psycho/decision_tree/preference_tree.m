clc
%% Example of use for the probabilistic model.
%
% Joe.

disp(sprintf('>> Example of use for the probabilistic model.\n'));

%Preference tree opgave
% Perceived health risk of drug
% N=48
dangerGuess = [
0 28 35 10 4 7
20 0 18 2 0 3
13 30 0 3 1 0
38 46 45 0 1 17
44 48 47 47 0 44
41 45 48 31 4 0];
%Rusmidler: 
%Alc Tob Can Ecs Her Coc


% 1 - Finding the amount of violations

disp('Counting the amount of transitivity violations ...');

% Finds the normalization factor
normalization_factor = sum(sum(dangerGuess))/ (numel(dangerGuess) - length(dangerGuess)) * 2;

% Normalizes the input data matrix
prob = dangerGuess / normalization_factor;

amount_weak_violations = 0;
amount_moderate_violations = 0;
amount_strong_violations = 0;

amount_of_tests = 0;
amount_of_checks = 0;

for a = 1 : 6
    for b = 1 : 6
        for c = 1 : 6

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
A = {[1]; [2 8]; [3 8]; [4 7 8]; [5 7 8]; [6 7 8]};
%A = {[1]; [2]; [3]; [4]; [5]; [6]; [7]; [8]; [9]; [10]};
[p,chistat,u,lL_eba,lL_sat,fit,cova] = fOptiPt(dangerGuess, A);

% 3 - Check how well the model fits
if chistat(3) < 0.1
    disp(sprintf('ERROR: the goodness of fit is not good enough (below 0.1)! -> %d', chistat(3)));
    return
end

disp(sprintf('INFO: p Value: %d\n', chistat(3)));

% 3 - Compute the 95% confidence intervals
confidence_intervals = 2 * 1.96 * sqrt(diag(cova));

% 4 - Now we plot the scale values
errorbar([1:8], p * 20, confidence_intervals, 'o', 'MarkerSize', 5);
xlim([0 9]);
ylim([0 20]);
% ylim([-2 4]);
grid
xlabel('Branch number');
ylabel('Length');
ax = gca;
ax.XTickLabel = {'','1','2','3','4','5','6', '7', '8', ''};

% Note:
%
% chistat(3) -> tells you how well the model fits
% Then from the covariance matrix extract the diagonal and compute the
% formula: 
%
% u = +- 1.96 sqrt( diag(cov(p)))
% and then, those are the margin for the "errorbar" plot
