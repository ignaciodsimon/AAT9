function [avgP,theta ] = Capon(data, d, f0, angle_res )
%CAPON computes the Capon spectrum of an wave impinging on an ULA
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
a = exp(1i*2*pi.* ((0:(L-1))') * zeta(theta)); % Vandermonde matrix (L sensor x theta)

R = @(m) inv((data(:,:,m) * ctranspose(data(:,:,m))) /L) ; %inverse sample covariance matrix

P = @(m) 1./( ctranspose(a) * R(m) * a );


Ptemp = nan(Nobs,length(theta));
for i = 1:Nobs
Ptemp(i,:) = sum(P(i));
end

avgP = sum(Ptemp,1);
avgP = avgP / max(avgP);

end

