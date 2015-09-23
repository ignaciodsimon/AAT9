function [Speakerarray, distmatrix] = GenerateSyntheticIRs(x,y,fs,c)
%%This function takes the coordinates of each speaker and creates IRs based
%%on this. 
%Inputs: X coordinate, Y coordinate, sampling frequency, speed of sound
%Outputs: IRs for each speaker/microphone combination
%NOTE: (0,0) is the center of the setup


%Create simulatedIRs array
Speakerarray = [TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker()];

%Allocating vectors
for k = 1:length(x)
    intermediatedistspk(k,:)  = zeros(1,length(x));
end

%Calculate distances between speakers

for k = 1:length(x)
for i = 1:length(x) 
    intermediatedistspk(k,i) = sqrt(((x(k)-x(i))^2+(y(k)-y(i))^2));
end
end

distmatrix = intermediatedistspk;
            
            
%% Calculate the IR based on distmatrix

%convert to time
timematrix = distmatrix ./c;

%convert to samples
samplesmatrix = round(timematrix .*fs);


%convert samples to IRs and assign them to speakerobject

%For speaker 1
for i=2:length(x)
Speakerarray(1).id = 1;
Speakerarray(1).microphones(2).id = 2;
Speakerarray(1).microphones(2).recordings(1).recording = [1];
Speakerarray(1).microphones(2).recordings(i).recording = [zeros(1,samplesmatrix(1,i)) 1];
Speakerarray(1).microphones(2).recordings(i).fromSpeaker = i;
end

%For speaker 2
for i=2:length(x)
Speakerarray(2).id = 2;
Speakerarray(2).microphones(2).id = 2;
Speakerarray(2).microphones(2).recordings(1).recording = [1];
Speakerarray(2).microphones(2).recordings(i).recording = [zeros(1,samplesmatrix(2,i)) 1];
Speakerarray(2).microphones(2).recordings(i).fromSpeaker = i;
end

%For speaker 3
for i=2:length(x)
Speakerarray(3).id = 3;
Speakerarray(3).microphones(2).id = 2;
Speakerarray(3).microphones(2).recordings(1).recording = [1];
Speakerarray(3).microphones(2).recordings(i).recording = [zeros(1,samplesmatrix(2,i)) 1];
Speakerarray(3).microphones(2).recordings(i).fromSpeaker = i;
end

%For speaker 4
for i=2:length(x)
Speakerarray(4).id = 4;
Speakerarray(4).microphones(2).id = 2;
Speakerarray(4).microphones(2).recordings(1).recording = [1];
Speakerarray(4).microphones(2).recordings(i).recording = [zeros(1,samplesmatrix(2,i)) 1];
Speakerarray(4).microphones(2).recordings(i).fromSpeaker = i;
end

%For speaker 5
for i=2:length(x)
Speakerarray(5).id = 5;
Speakerarray(5).microphones(2).id = 2;
Speakerarray(5).microphones(2).recordings(1).recording = [1];
Speakerarray(5).microphones(2).recordings(i).recording = [zeros(1,samplesmatrix(2,i)) 1];
Speakerarray(5).microphones(2).recordings(i).fromSpeaker = i;
end
             

end