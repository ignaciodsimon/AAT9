function [ GT ] = gravityTime( IR, fs)
% gravityTime find the gravity time of an Impulse Response
% [ GT ] = gravityTime( IR, fs)
% input : Inpulse Response vector, sampling frequency
% output : scalar, center time [s]
%
% 2015, AAU

ts = 1/fs;
L = length(IR);
T = L/fs;

t = (1:L)*ts;

num = sum(t.*(IR.^2));
denom = sum(IR.^2);


GT = num/denom;

end

