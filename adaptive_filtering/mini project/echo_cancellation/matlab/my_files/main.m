%% TESTING ADAPTIVE FILTERS FUNCTIONS
%

clc
close all

addpath('../');         % for schroeder reverb
addpath('../../audio'); % audio files


%% INPUT SIGNAL

[u,fs] = audioread('speech_org.wav');
[v,fsv] = audioread('houston_problem.wav');
v = v(:,1);
%% RESAMPLING

u  = resample(u,8000,fs); % to 8000Hz
v  = resample(v,8000,fsv);
fs = 8000;
L  = length(u);
l_zero = 40000;
v = [zeros(l_zero , 1) ; v ; zeros(L-length(v)-l_zero,1)];

%% CAR TRANSFER FUNCTION

Tr   = 0.3;         % reverberation time
fc   = 800;        % lp-filter corner frequency
g    = 1;           % reverberation level
type = 'lp';        % either 'plain' or 'lp' where lp refers to low-pass
t0   = 0;           % pre-delay length
y_length = 1;    % desired length of output signal

SNR  = 30;       %SNR of car noise

%% FILTERING PARAMETERS

M  = 150;       % length of the filter
N  = L-M;         % number of iterations
mu = 0.05;      % LMS step size

beta = 0.45;
epsilon = 1;
K = 3;

%% BUILDING THE SIGNALS

z = schroeder_reverb(u,fs,Tr,fc,t0,g,type,y_length);        % z = u + rvrb of car

db_att = 12; % level attenuation for the echo
d = z*10^(-db_att/20) + awgn(v,SNR);    % add white noise to z(n) with specific SNR


%% RUNNING FILTER %%%%%%%%%%%%%%%%%%%%%%%%%%%

%e = LMS(u,d,mu,M);
e = APA(u,d,beta,M,epsilon,K);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTS

%% AUDIO

daudio = audioplayer(d,fs);
play(daudio);
pause()
stop(daudio);
eaudio = audioplayer(e,fs);
play(eaudio);
pause()
stop(eaudio);



pause()
close all