function [C] = clarity(IR,threshold,fs )
%clarity computes acoustic clarity coefficient C50 or C80, depending on
%input parameters
%  [C] = clarity(IR,threshold )
% inputs : Impulse Response vector, threshold [ms] (50 for C50, 80 for C80...), sampling
% frequency [Hz]
% output : clarity coefficient [dB]
%
% 2015, AAU

T = threshold * fs / 1000;
L = length(IR);

num = sum(IR(1:T).^2);
denom = sum(IR(T:L).^2);

C = 10*log10(num/denom);


end

