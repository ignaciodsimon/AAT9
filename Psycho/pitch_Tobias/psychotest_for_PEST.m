

clear all
close all
clc

%% TEST PARAMETERS % -> you can tweak thoses !


tmax = 0.7; % duration of sound in seconds
f0 = 600; % frequency of reference tone

itemax = 5; % number of repetition per delta
delta_f = 30; % first delta

nretmax = 8; % max number of returns 
Nlast = 6; % take the last ones for mean
target = 0.75; % interesting point in psychometric function


%% other parameters
fs = 44100;
ts = 1/fs;
useranswer = zeros(1,itemax); %answer vector

ret_delta = zeros(1,nretmax); %delta when returns

nreturns = 0;
turns = '';
results = '';
step = 0;

%% building sound

t = ts:ts:tmax; %time vector

attac = 50; % ! integer
w = [0:1/attac:1 ,ones(1,length(t) - 2*(attac+1)), 1:-1/attac:0]; %window

refsound = w .* sin(2*pi*f0*t);



while ( nreturns < nretmax )

   
   delta_f
   step
   delta_f = delta_f + step;
    
sprintf('listening 2 sounds different by %f Hz',delta_f)
    testsound = w .* sin(2*pi*(f0+delta_f).*t);
    
    
%%    
for i=1:itemax % repetitions for same delta 
   

    
    
%%%%random part
    RV = floor(2*rand(1,1));
    if ((RV -1) <= 0.001) && (RV > 0)
        truth = 2;
        A = refsound;
        B = testsound;
    elseif (RV < 0.001)
        truth = 1;
        A = testsound;
        B = refsound;
    end;
%%%%
    
%soundsc(A,fs)    
playblocking(audioplayer(A, fs),[10,length(t)-10]);

pause(0.5);

%soundsc(B,fs);
playblocking(audioplayer(B, fs));


answer = -1; %reinitialisation

while(answer ~= 1) && (answer ~= 2) 
   answer = input('Which sound is higher ? ');
   disp(answer);
end;
if (answer == truth)
    useranswer(i) = 1;
elseif (answer ~= truth)
    useranswer(i) =0;

end;


pause(1.5);





end; %end of for
%%
%useranswer = vector with all answers for 1 delta


[step, nreturns,results,turns] = PEST(delta_f,useranswer,turns,target,results); % nreturns counts number of returns ; target is 75% = 0.75

if(turns(length(turns)) == 1)
    ret_delta(nreturns) = delta_f;
end;


end; % end of while


lastn = ret_delta(nretmax-Nlast+1:nretmax); %taking Nlast last reversals

treshold = mean(lastn);


plot(1:Nlast,lastn,'-o',1:Nlast,treshold.*ones(1,Nlast),'--');legend('last reversal points',['mean = ',num2str(treshold)]);


output = lastn;
dlmwrite('data.txt',output,'delimiter','\t');

