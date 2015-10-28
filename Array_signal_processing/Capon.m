function [avgP,theta ] = Capon(data, d, f0, angle_res )
%CAPON computes the Capon spectrum of an wave impinging on an ULA
%   Detailed explanation goes here

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

