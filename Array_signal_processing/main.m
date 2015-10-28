%% testing signal_model.m

clear
close all
clc


c_0 = 3e8; 
fs = 9e9;
ts = 1/fs;
ns = 250; % number of samples
T = ns * ts;
t = (ts:ts:T);
%
direction = 10; %impinging direction in degrees
%
ImpDir = [cos(deg2rad(direction));sin(deg2rad(direction))];
A = sqrt(10);
f_0 = 2.4e8;
SNR = 10; % some heavy noise to it
L = 35; % number of sensors
g = 1; % omni
delta =  c_0 / (2*f_0); % inter-sensor spacing = lambda/2

Nobs = 10; %number of observations
data = zeros(L,ns,Nobs);

for i = 1:Nobs
phi = rand*2*pi; %for each new observation, new phi random between 0 and 2pi
data(:,:,i) = signal_model(ImpDir,A,phi,f_0,SNR,t,L,g,delta);
end


%% BARTLETT

[BB,theta] = Bartlett(data,delta,f_0,1);


hFig = figure(2);
set(hFig, 'Position', [200 100 900 600])

subplot(221)
plot(rad2deg(theta),abs(BB));
title('the Bartlett beamformer');
xlabel('freq (Hz)');ylabel('amplitude');
subplot(223)
plot(rad2deg(theta),unwrap(angle(BB)));
xlabel('freq (Hz)');ylabel('rad');
subplot(2,2,[2;4])
polar(theta,abs(BB));
title('polar representation');
tech = text(-1,-1.5,['Impingent angle = ' num2str(direction) '°'],'fontsize',12);

%% CAPON


[CB,theta] = Capon(data,delta,f_0,1);

hFig = figure(3);
set(hFig, 'Position', [200 100 900 600])

subplot(221)
plot(rad2deg(theta),abs(CB));
title('the Capon beamformer');
xlabel('freq (Hz)');ylabel('amplitude');
subplot(223)
plot(rad2deg(theta),unwrap(angle(CB)));
xlabel('freq (Hz)');ylabel('rad');
subplot(2,2,[2;4])
polar(theta,abs(CB));
title('polar representation');
tech = text(-1,-1.5,['Impingent angle = ' num2str(direction) '°'],'fontsize',12);


%% 

hFig = figure(4);
set(hFig, 'Position', [200 100 900 600])

subplot(121)
plot(rad2deg(theta(length(theta)/2:end)),abs(BB(length(theta)/2:end)));
hold on
plot(rad2deg(theta(length(theta)/2:end)),abs(CB(length(theta)/2:end)));
title('Comparison between Bartlett and Capon Beamforming');
xlabel('freq');ylabel('amplitude');
legend('Bartlett','Capon');
axis([direction-20 direction+20 -0.2 1.2]);

subplot(122)
polar(theta,abs(BB));
hold on
polar(theta,abs(CB));
title('polar representation');
legend('Bartlett','Capon');
tech = text(-1,-1.5,['Impingent angle = ' num2str(direction) '°'],'fontsize',12);