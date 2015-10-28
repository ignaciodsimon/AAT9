function [observation] = signal_model(ImpDir,A,phi,f_0,SNR,t,L,g,delta)
%SIGNAL_MODEL models the observation of a harmonic complex wave in 2D by a
%             Uniform Linear Array (ULA) of sensors.
%
%   [observation] = signal_model(ImpDir,A,phi,f_0,SNR,t,L,g,delta).
%
%   SIGNAL PARAMETERS : s(t) = A*exp(j*phi.*t)
%   ImpDir : impinging direction = -(propagation direction) ; (2x1)vector.
%   A       : amplitude of signal; scalar or vector
%   phi     : phase of signal; vector matching the size of time vector.
%   f_0     : carrier frequency; scalar.
%   SNR     : Signal to noise ratio of added temporaly and spatially
%             independant noise; scalar or set 'null' for no noise.
%   t       : time vector; vector.
%   
%   ULA PARAMETERS : 
%   L       : number of sensors; scalar.
%   g       : directional gain of sensors; scalar = 1 for omnidirectivity, 
%             upcoming versions may include vector-parameter for 
%             directivity pattern...
%   delta   : distance between two sensors; scalar (assuming the array is
%             colinear to x-axis, with first sensor located on the origin).
%
%   Column Vectors only !!!
%
%   Tobias van Baarsel
%   AAU, 10/2015


%% SIGNAL 
s = @(t)  A' .* exp(1i * phi .* t);

%% CONSTANTS 
c_0 = 3e8; % speed of EM waves
w_0 = 2*pi*f_0; % angular frequency
T = length(t);

%%

t = t';

observation = nan(L,T);

r = (0:delta:delta*(L-1));  % x-coordinate sensor position vector, y is 0 anyway

for l=1:L                            
    observation(l,:) = g.*exp(1i*w_0*(ImpDir(1)*r(l)) /c_0) * s(t - (-ImpDir(1)*r(l) / c_0).*ones(T,1));
end

if(ischar(SNR))
    if(strcmp(SNR,'null'))
        return;
    else
        fprintf('error with SNR : did you mean ''null'' ? ');
    end;
else 
    observation = awgn(observation, SNR);
end;

end

