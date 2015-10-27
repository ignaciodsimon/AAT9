%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                   %%
%% AFFINE PROJECTION ADAPTIVE FILTER %%
%%                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all

addpath('../');         % for schroeder reverb
addpath('../../audio'); % audio files


%% INPUT SIGNAL

[u,fs] = audioread('speech_org.wav');
[v,fsv] = audioread('houston_problem.wav');
v = v(:,1);
%% RESAMPLING & PADDING

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

M  = 300;          % length of the filter
K = 4;            % number of constraints (K < M)
N  = L-(M-1+K-1); % number of iterations
beta = 1;         % APA step size parameter
epsilon = 1; % bypass numerical problems

%% BUILDING THE SIGNALS
fprintf(['building the ' num2str(M) 'x' num2str(N) ' input signal matrix...' '\n']);
U = flipud(hankel(u(1:M),u(M:N+M-1+K-1))); %matrix of input vectors

fprintf(['computing reverb using Schroeder''s model...' '\n']);
z = schroeder_reverb(u,fs,Tr,fc,t0,g,type,y_length);        % z = u + rvrb of car

%% need row vectors here
z = z';
v = v';
%%

db_att = 12; % level attenuation for the echo
d = z*10^(-db_att/20) + awgn(v,SNR);    % add white noise to z(n) with specific SNR

y = zeros(1,N);
e = zeros(1,N);     % filtered signal(hopefully)
w = zeros(M,N+1);   % adaptive filter coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the APA adaptive Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(['computing filter coefficients...' '\n']);
for n=1:N
%    if(rem(10,n) == 0) 
%     fprintf([num2str(round(n/N,2)*100) '/100' '\n']);
%    end;
  y(n) = U(:,n+K-1)'*w(:,n)      ; % compute the filter output
  e(n) = d(n+K-1)-y(n)           ; % compute the error
  A    = fliplr(U(:,n:n+K-1)); % matrix of the K input vectors
  ev   = fliplr(d(n:n+K-1))'-A'*w(:,n); % error vector
  w(:,n+1) = w(:,n)+beta*A*((epsilon*eye(K)+A'*A)\ev); % update the filter coefficients
end


%% PLOTS

fig=figure();
subplot(211)
plot(1:length(u),u);title('u(n), karen''s voice only');text(1,0,['rms = ' num2str(rms(u))]);
subplot(212)
plot(1:length(d),d);title('d(n), karen''s voice + RVB + noise');text(1,0,['rms = ' num2str(rms(d))]);


fig=figure();
subplot(211)
plot(1:N,y);title('y(n), karen''s voice through adaptive filter');text(1,0,['rms = ' num2str(rms(y))]);
subplot(212)
plot(1:N,e);title('e(n) = d(n) - y(n)');text(1,0,['rms = ' num2str(rms(e))]);

fig=figure();
plot(w(1,:),w(2,:));title('filter coefficients');

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
