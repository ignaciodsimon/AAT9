function [est_delay, samples_delay] = estimateDelay(inputIR, fs)
%%This function returns the delay in time from a speaker to a microphone
% Inputs: IR of which delay is wanted
%       : The sampling frequency
% Output: The delay in time

% Get the row which have the maximum
[~, I] = max(inputIR);

% Convert from samples to time
est_delay = 1/fs * I;
samples_delay = I;
end