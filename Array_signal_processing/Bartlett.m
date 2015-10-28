function [avgP,theta ] = Bartlett(data, d, f0, angle_res )
%BARTLETT computes the Bartlett spectrum of an wave impinging on an ULA
%
%   data = 3-D input matrix : [number of sensors x length of recording x number of observations]
%          example : data(:,:,i) = signal_model(ImpDir,A,phi,f_0,SNR,t,L,g,delta);
%   d = distance between two sensors
%   f0 = carrier frequency
%   angle_res = angle resolution (deg°)
%
%   Tobias van Baarsel
%   AAU - 10/2015


c0 = 3e8;
lambda = c0/f0;
angle_res = deg2rad(angle_res);

[L,T,Nobs] = size(data); % number of sensors, length of recording and number of observations
theta = -pi:angle_res:pi;

zeta = @(theta) (d/lambda) * cos(theta); % spatial frequency variable

a = exp(-1i*2*pi.* ((0:(L-1))') * zeta(theta)); % Vandermonde matrix (L sensor x theta)

periodogram = @(m) 1/L * (sum( (data(:,:,m)' * conj(a)).^2 ,1) ./T);

P = nan(Nobs,length(theta));
for i = 1:Nobs
P(i,:) = periodogram(i);
end

avgP = sum(P,1) / Nobs;
avgP = avgP / max(avgP); %normalized

end




