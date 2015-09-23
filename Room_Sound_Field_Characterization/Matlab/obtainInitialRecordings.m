function outputData = obtainInitialRecordings()
%% Performs the initial MLS recordings to obtain the IRs of the system.

%% Constants definitions
SAMPLING_FREQ = 44100;
MLS_SIGNAL_ORDER = 12;
MLS_GUARD_TIME = 0.5; % Note: this should come from a pre-test to find out
                      %       how big is the room, and therefore how long
                      %       this guard-time has to be.

%% First:  generate the pattern signal (MLS).
mlsSignal = generateMLS(MLS_SIGNAL_ORDER);

%% Second: create the audio signal for the six loudspeakers, multiplexing on
%         time and with a time guard between different loudspeakers to 
%         allow for the reverberation to decay.
excitationSignal = zeros(7, ceil((length(mlsSignal) + MLS_GUARD_TIME * SAMPLING_FREQ)* 7));
for i = 1:7
    startPosition = 1 + (i - 1)*(length(mlsSignal) + ceil(MLS_GUARD_TIME * SAMPLING_FREQ));
    excitationSignal(i, startPosition : startPosition + length(mlsSignal) - 1) = mlsSignal;
end


%% Third:  play the generated signal and record all 16 channels. 

referenceRecording = zeros(1, 10);


% Mics from speaker 1

speaker1recordings_micA_fromspeaker1 = zeros(1,10);
speaker1recordings_micA_fromspeaker2 = zeros(1,10);
speaker1recordings_micA_fromspeaker3 = zeros(1,10);
speaker1recordings_micA_fromspeaker4 = zeros(1,10);
speaker1recordings_micA_fromspeaker5 = zeros(1,10);
speaker1recordings_micA_fromspeaker6 = zeros(1,10);

speaker1recordings_micB_fromspeaker1 = zeros(1,10);
speaker1recordings_micB_fromspeaker2 = zeros(1,10);
speaker1recordings_micB_fromspeaker3 = zeros(1,10);
speaker1recordings_micB_fromspeaker4 = zeros(1,10);
speaker1recordings_micB_fromspeaker5 = zeros(1,10);
speaker1recordings_micB_fromspeaker6 = zeros(1,10);

speaker1recordings_micC_fromspeaker1 = zeros(1,10);
speaker1recordings_micC_fromspeaker2 = zeros(1,10);
speaker1recordings_micC_fromspeaker3 = zeros(1,10);
speaker1recordings_micC_fromspeaker4 = zeros(1,10);
speaker1recordings_micC_fromspeaker5 = zeros(1,10);
speaker1recordings_micC_fromspeaker6 = zeros(1,10);


% Mics from speaker 2

speaker2recordings_micA_fromspeaker1 = zeros(1,10);
speaker2recordings_micA_fromspeaker2 = zeros(1,10);
speaker2recordings_micA_fromspeaker3 = zeros(1,10);
speaker2recordings_micA_fromspeaker4 = zeros(1,10);
speaker2recordings_micA_fromspeaker5 = zeros(1,10);
speaker2recordings_micA_fromspeaker6 = zeros(1,10);

speaker2recordings_micB_fromspeaker1 = zeros(1,10);
speaker2recordings_micB_fromspeaker2 = zeros(1,10);
speaker2recordings_micB_fromspeaker3 = zeros(1,10);
speaker2recordings_micB_fromspeaker4 = zeros(1,10);
speaker2recordings_micB_fromspeaker5 = zeros(1,10);
speaker2recordings_micB_fromspeaker6 = zeros(1,10);

speaker2recordings_micC_fromspeaker1 = zeros(1,10);
speaker2recordings_micC_fromspeaker2 = zeros(1,10);
speaker2recordings_micC_fromspeaker3 = zeros(1,10);
speaker2recordings_micC_fromspeaker4 = zeros(1,10);
speaker2recordings_micC_fromspeaker5 = zeros(1,10);
speaker2recordings_micC_fromspeaker6 = zeros(1,10);


% Mics from speaker 3

speaker3recordings_micA_fromspeaker1 = zeros(1,10);
speaker3recordings_micA_fromspeaker2 = zeros(1,10);
speaker3recordings_micA_fromspeaker3 = zeros(1,10);
speaker3recordings_micA_fromspeaker4 = zeros(1,10);
speaker3recordings_micA_fromspeaker5 = zeros(1,10);
speaker3recordings_micA_fromspeaker6 = zeros(1,10);

speaker3recordings_micB_fromspeaker1 = zeros(1,10);
speaker3recordings_micB_fromspeaker2 = zeros(1,10);
speaker3recordings_micB_fromspeaker3 = zeros(1,10);
speaker3recordings_micB_fromspeaker4 = zeros(1,10);
speaker3recordings_micB_fromspeaker5 = zeros(1,10);
speaker3recordings_micB_fromspeaker6 = zeros(1,10);

speaker3recordings_micC_fromspeaker1 = zeros(1,10);
speaker3recordings_micC_fromspeaker2 = zeros(1,10);
speaker3recordings_micC_fromspeaker3 = zeros(1,10);
speaker3recordings_micC_fromspeaker4 = zeros(1,10);
speaker3recordings_micC_fromspeaker5 = zeros(1,10);
speaker3recordings_micC_fromspeaker6 = zeros(1,10);


% Mics from speaker 4

speaker4recordings_micA_fromspeaker1 = zeros(1,10);
speaker4recordings_micA_fromspeaker2 = zeros(1,10);
speaker4recordings_micA_fromspeaker3 = zeros(1,10);
speaker4recordings_micA_fromspeaker4 = zeros(1,10);
speaker4recordings_micA_fromspeaker5 = zeros(1,10);
speaker4recordings_micA_fromspeaker6 = zeros(1,10);

speaker4recordings_micB_fromspeaker1 = zeros(1,10);
speaker4recordings_micB_fromspeaker2 = zeros(1,10);
speaker4recordings_micB_fromspeaker3 = zeros(1,10);
speaker4recordings_micB_fromspeaker4 = zeros(1,10);
speaker4recordings_micB_fromspeaker5 = zeros(1,10);
speaker4recordings_micB_fromspeaker6 = zeros(1,10);

speaker4recordings_micC_fromspeaker1 = zeros(1,10);
speaker4recordings_micC_fromspeaker2 = zeros(1,10);
speaker4recordings_micC_fromspeaker3 = zeros(1,10);
speaker4recordings_micC_fromspeaker4 = zeros(1,10);
speaker4recordings_micC_fromspeaker5 = zeros(1,10);
speaker4recordings_micC_fromspeaker6 = zeros(1,10);


% Mics from speaker 5

speaker5recordings_micA_fromspeaker1 = zeros(1,10);
speaker5recordings_micA_fromspeaker2 = zeros(1,10);
speaker5recordings_micA_fromspeaker3 = zeros(1,10);
speaker5recordings_micA_fromspeaker4 = zeros(1,10);
speaker5recordings_micA_fromspeaker5 = zeros(1,10);
speaker5recordings_micA_fromspeaker6 = zeros(1,10);

speaker5recordings_micB_fromspeaker1 = zeros(1,10);
speaker5recordings_micB_fromspeaker2 = zeros(1,10);
speaker5recordings_micB_fromspeaker3 = zeros(1,10);
speaker5recordings_micB_fromspeaker4 = zeros(1,10);
speaker5recordings_micB_fromspeaker5 = zeros(1,10);
speaker5recordings_micB_fromspeaker6 = zeros(1,10);

speaker5recordings_micC_fromspeaker1 = zeros(1,10);
speaker5recordings_micC_fromspeaker2 = zeros(1,10);
speaker5recordings_micC_fromspeaker3 = zeros(1,10);
speaker5recordings_micC_fromspeaker4 = zeros(1,10);
speaker5recordings_micC_fromspeaker5 = zeros(1,10);
speaker5recordings_micC_fromspeaker6 = zeros(1,10);


% Mics from speaker 6

speaker6recordings_micA_fromspeaker1 = zeros(1,10);
speaker6recordings_micA_fromspeaker2 = zeros(1,10);
speaker6recordings_micA_fromspeaker3 = zeros(1,10);
speaker6recordings_micA_fromspeaker4 = zeros(1,10);
speaker6recordings_micA_fromspeaker5 = zeros(1,10);
speaker6recordings_micA_fromspeaker6 = zeros(1,10);

speaker6recordings_micB_fromspeaker1 = zeros(1,10);
speaker6recordings_micB_fromspeaker2 = zeros(1,10);
speaker6recordings_micB_fromspeaker3 = zeros(1,10);
speaker6recordings_micB_fromspeaker4 = zeros(1,10);
speaker6recordings_micB_fromspeaker5 = zeros(1,10);
speaker6recordings_micB_fromspeaker6 = zeros(1,10);

speaker6recordings_micC_fromspeaker1 = zeros(1,10);
speaker6recordings_micC_fromspeaker2 = zeros(1,10);
speaker6recordings_micC_fromspeaker3 = zeros(1,10);
speaker6recordings_micC_fromspeaker4 = zeros(1,10);
speaker6recordings_micC_fromspeaker5 = zeros(1,10);
speaker6recordings_micC_fromspeaker6 = zeros(1,10);


%% Structures for storing the data
speakerData = [TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker()];


% Mic 1(A) from Speaker 1
speakerData(1).id = 1;
speakerData(1).microphones(1).id = 1;
speakerData(1).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(1).recordings(1).recording = speaker1recordings_micA_fromspeaker1;
speakerData(1).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(1).recordings(2).recording = speaker1recordings_micA_fromspeaker2;
speakerData(1).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(1).recordings(3).recording = speaker1recordings_micA_fromspeaker3;
speakerData(1).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(1).recordings(4).recording = speaker1recordings_micA_fromspeaker4;
speakerData(1).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(1).recordings(5).recording = speaker1recordings_micA_fromspeaker5;
speakerData(1).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(1).recordings(6).recording = speaker1recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 1
speakerData(1).microphones(2).id = 2;
speakerData(1).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(2).recordings(1).recording = speaker1recordings_micB_fromspeaker1;
speakerData(1).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(2).recordings(2).recording = speaker1recordings_micB_fromspeaker2;
speakerData(1).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(2).recordings(3).recording = speaker1recordings_micB_fromspeaker3;
speakerData(1).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(2).recordings(4).recording = speaker1recordings_micB_fromspeaker4;
speakerData(1).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(2).recordings(5).recording = speaker1recordings_micB_fromspeaker5;
speakerData(1).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(2).recordings(6).recording = speaker1recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 1
speakerData(1).microphones(3).id = 3;
speakerData(1).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(3).recordings(1).recording = speaker1recordings_micC_fromspeaker1;
speakerData(1).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(3).recordings(2).recording = speaker1recordings_micC_fromspeaker2;
speakerData(1).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(3).recordings(3).recording = speaker1recordings_micC_fromspeaker3;
speakerData(1).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(3).recordings(4).recording = speaker1recordings_micC_fromspeaker4;
speakerData(1).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(3).recordings(5).recording = speaker1recordings_micC_fromspeaker5;
speakerData(1).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(3).recordings(6).recording = speaker1recordings_micC_fromspeaker6;


% Mic 1(A) from Speaker 2
speakerData(2).id = 2;
speakerData(2).microphones(1).id = 1;
speakerData(2).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(1).recordings(1).recording = speaker2recordings_micA_fromspeaker1;
speakerData(2).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(1).recordings(2).recording = speaker2recordings_micA_fromspeaker2;
speakerData(2).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(1).recordings(3).recording = speaker2recordings_micA_fromspeaker3;
speakerData(2).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(1).recordings(4).recording = speaker2recordings_micA_fromspeaker4;
speakerData(2).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(1).recordings(5).recording = speaker2recordings_micA_fromspeaker5;
speakerData(2).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(1).recordings(6).recording = speaker2recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 2
speakerData(2).microphones(2).id = 2;
speakerData(2).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(2).recordings(1).recording = speaker2recordings_micB_fromspeaker1;
speakerData(2).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(2).recordings(2).recording = speaker2recordings_micB_fromspeaker2;
speakerData(2).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(2).recordings(3).recording = speaker2recordings_micB_fromspeaker3;
speakerData(2).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(2).recordings(4).recording = speaker2recordings_micB_fromspeaker4;
speakerData(2).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(2).recordings(5).recording = speaker2recordings_micB_fromspeaker5;
speakerData(2).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(2).recordings(6).recording = speaker2recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 2
speakerData(2).microphones(3).id = 3;
speakerData(2).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(3).recordings(1).recording = speaker2recordings_micC_fromspeaker1;
speakerData(2).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(3).recordings(2).recording = speaker2recordings_micC_fromspeaker2;
speakerData(2).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(3).recordings(3).recording = speaker2recordings_micC_fromspeaker3;
speakerData(2).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(3).recordings(4).recording = speaker2recordings_micC_fromspeaker4;
speakerData(2).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(3).recordings(5).recording = speaker2recordings_micC_fromspeaker5;
speakerData(2).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(3).recordings(6).recording = speaker2recordings_micC_fromspeaker6;


% Mic 1(A) from Speaker 3
speakerData(3).id = 3;
speakerData(3).microphones(1).id = 1;
speakerData(3).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(1).recordings(1).recording = speaker3recordings_micA_fromspeaker1;
speakerData(3).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(1).recordings(2).recording = speaker3recordings_micA_fromspeaker2;
speakerData(3).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(1).recordings(3).recording = speaker3recordings_micA_fromspeaker3;
speakerData(3).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(1).recordings(4).recording = speaker3recordings_micA_fromspeaker4;
speakerData(3).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(1).recordings(5).recording = speaker3recordings_micA_fromspeaker5;
speakerData(3).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(1).recordings(6).recording = speaker3recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 3
speakerData(3).microphones(2).id = 2;
speakerData(3).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(2).recordings(1).recording = speaker3recordings_micB_fromspeaker1;
speakerData(3).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(2).recordings(2).recording = speaker3recordings_micB_fromspeaker2;
speakerData(3).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(2).recordings(3).recording = speaker3recordings_micB_fromspeaker3;
speakerData(3).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(2).recordings(4).recording = speaker3recordings_micB_fromspeaker4;
speakerData(3).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(2).recordings(5).recording = speaker3recordings_micB_fromspeaker5;
speakerData(3).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(2).recordings(6).recording = speaker3recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 3
speakerData(3).microphones(3).id = 3;
speakerData(3).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(3).recordings(1).recording = speaker3recordings_micC_fromspeaker1;
speakerData(3).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(3).recordings(2).recording = speaker3recordings_micC_fromspeaker2;
speakerData(3).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(3).recordings(3).recording = speaker3recordings_micC_fromspeaker3;
speakerData(3).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(3).recordings(4).recording = speaker3recordings_micC_fromspeaker4;
speakerData(3).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(3).recordings(5).recording = speaker3recordings_micC_fromspeaker5;
speakerData(3).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(3).recordings(6).recording = speaker3recordings_micC_fromspeaker6;


% Mic 1(A) from Speaker 4
speakerData(4).id = 4;
speakerData(4).microphones(1).id = 1;
speakerData(4).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(1).recordings(1).recording = speaker4recordings_micA_fromspeaker1;
speakerData(4).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(1).recordings(2).recording = speaker4recordings_micA_fromspeaker2;
speakerData(4).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(1).recordings(3).recording = speaker4recordings_micA_fromspeaker3;
speakerData(4).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(1).recordings(4).recording = speaker4recordings_micA_fromspeaker4;
speakerData(4).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(1).recordings(5).recording = speaker4recordings_micA_fromspeaker5;
speakerData(4).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(1).recordings(6).recording = speaker4recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 4
speakerData(4).microphones(2).id = 2;
speakerData(4).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(2).recordings(1).recording = speaker4recordings_micB_fromspeaker1;
speakerData(4).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(2).recordings(2).recording = speaker4recordings_micB_fromspeaker2;
speakerData(4).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(2).recordings(3).recording = speaker4recordings_micB_fromspeaker3;
speakerData(4).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(2).recordings(4).recording = speaker4recordings_micB_fromspeaker4;
speakerData(4).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(2).recordings(5).recording = speaker4recordings_micB_fromspeaker5;
speakerData(4).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(2).recordings(6).recording = speaker4recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 4
speakerData(4).microphones(3).id = 3;
speakerData(4).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(3).recordings(1).recording = speaker4recordings_micC_fromspeaker1;
speakerData(4).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(3).recordings(2).recording = speaker4recordings_micC_fromspeaker2;
speakerData(4).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(3).recordings(3).recording = speaker4recordings_micC_fromspeaker3;
speakerData(4).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(3).recordings(4).recording = speaker4recordings_micC_fromspeaker4;
speakerData(4).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(3).recordings(5).recording = speaker4recordings_micC_fromspeaker5;
speakerData(4).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(3).recordings(6).recording = speaker4recordings_micC_fromspeaker6;


% Mic 1(A) from Speaker 5
speakerData(5).id = 5;
speakerData(5).microphones(1).id = 1;
speakerData(5).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(1).recordings(1).recording = speaker5recordings_micA_fromspeaker1;
speakerData(5).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(1).recordings(2).recording = speaker5recordings_micA_fromspeaker2;
speakerData(5).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(1).recordings(3).recording = speaker5recordings_micA_fromspeaker3;
speakerData(5).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(1).recordings(4).recording = speaker5recordings_micA_fromspeaker4;
speakerData(5).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(1).recordings(5).recording = speaker5recordings_micA_fromspeaker5;
speakerData(5).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(1).recordings(6).recording = speaker5recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 5
speakerData(5).microphones(2).id = 2;
speakerData(5).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(2).recordings(1).recording = speaker5recordings_micB_fromspeaker1;
speakerData(5).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(2).recordings(2).recording = speaker5recordings_micB_fromspeaker2;
speakerData(5).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(2).recordings(3).recording = speaker5recordings_micB_fromspeaker3;
speakerData(5).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(2).recordings(4).recording = speaker5recordings_micB_fromspeaker4;
speakerData(5).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(2).recordings(5).recording = speaker5recordings_micB_fromspeaker5;
speakerData(5).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(2).recordings(6).recording = speaker5recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 5
speakerData(5).microphones(3).id = 3;
speakerData(5).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(3).recordings(1).recording = speaker5recordings_micC_fromspeaker1;
speakerData(5).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(3).recordings(2).recording = speaker5recordings_micC_fromspeaker2;
speakerData(5).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(3).recordings(3).recording = speaker5recordings_micC_fromspeaker3;
speakerData(5).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(3).recordings(4).recording = speaker5recordings_micC_fromspeaker4;
speakerData(5).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(3).recordings(5).recording = speaker5recordings_micC_fromspeaker5;
speakerData(5).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(3).recordings(6).recording = speaker5recordings_micC_fromspeaker6;


% Mic 1(A) from Speaker 6
speakerData(6).id = 6;
speakerData(6).microphones(1).id = 1;
speakerData(6).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(1).recordings(1).recording = speaker6recordings_micA_fromspeaker1;
speakerData(6).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(1).recordings(2).recording = speaker6recordings_micA_fromspeaker2;
speakerData(6).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(1).recordings(3).recording = speaker6recordings_micA_fromspeaker3;
speakerData(6).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(1).recordings(4).recording = speaker6recordings_micA_fromspeaker4;
speakerData(6).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(1).recordings(5).recording = speaker6recordings_micA_fromspeaker5;
speakerData(6).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(1).recordings(6).recording = speaker6recordings_micA_fromspeaker6;

% Mic 2(B) from Speaker 6
speakerData(6).microphones(2).id = 2;
speakerData(6).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(2).recordings(1).recording = speaker6recordings_micB_fromspeaker1;
speakerData(6).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(2).recordings(2).recording = speaker6recordings_micB_fromspeaker2;
speakerData(6).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(2).recordings(3).recording = speaker6recordings_micB_fromspeaker3;
speakerData(6).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(2).recordings(4).recording = speaker6recordings_micB_fromspeaker4;
speakerData(6).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(2).recordings(5).recording = speaker6recordings_micB_fromspeaker5;
speakerData(6).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(2).recordings(6).recording = speaker6recordings_micB_fromspeaker6;

% Mic 3(C) from Speaker 6
speakerData(6).microphones(3).id = 3;
speakerData(6).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(3).recordings(1).recording = speaker6recordings_micC_fromspeaker1;
speakerData(6).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(3).recordings(2).recording = speaker6recordings_micC_fromspeaker2;
speakerData(6).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(3).recordings(3).recording = speaker6recordings_micC_fromspeaker3;
speakerData(6).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(3).recordings(4).recording = speaker6recordings_micC_fromspeaker4;
speakerData(6).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(3).recordings(5).recording = speaker6recordings_micC_fromspeaker5;
speakerData(6).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(3).recordings(6).recording = speaker6recordings_micC_fromspeaker6;


%% Fifth:  process the recordings to obtain the IRs (deconvolution) and corresponding time delay.

referenceIR = computeIRFromMLS(mlsSignal, referenceRecording);

for currentReceivingSpeakerIndex = 1 : 6
    for currentMicIndex = 1 : 3
        for currentTransmittingSpeakerIndex = 1 : 3

            % Computes the IR
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR = ...
                computeIRFromMLS(mlsSignal, speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).recording);

            % Corrects the IR with the reference IR
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR = ...
                compensateIRWithReference( ...
                    speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR, ...
                    referenceIR);
                
            % Find out associated delay time for each IR
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).estimatedTime = ...
                estimateDelay( ...
                    speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR, ...
                    SAMPLING_FREQ);

        end
    end
    
end

    outputData = speakerData;
end




%% Test code to plot the generated signals:
% 
% hold on
% plot(excitationSignal(1,:), 'b');
% plot(excitationSignal(2,:), 'r');
% plot(excitationSignal(3,:), 'g');
% plot(excitationSignal(4,:), 'y');
% plot(excitationSignal(5,:), 'k');
% plot(excitationSignal(6,:), 'c');
% plot(excitationSignal(7,:), 'o');


%% Third:  include the signal on the "Ref" channel, to compensate for the
%         delay on the acquisition system.



% Fourth: start the recording on all 16 channels (15 + 1 ref) and play the
%         previously created signal to all six loudspeakers.

% For playing / recording multichannel, take a look at:
% http://www.mathworks.com/matlabcentral/fileexchange/4017-pa-wavplay/content/pa_wavplayrecord.m
% and:
% http://www.mathworks.com/matlabcentral/fileexchange/4017-pa-wavplay








%% Testing the IR computation:
% 
% recordingHandler = audiorecorder(44100, 16, 2);
% record(recordingHandler);
% playblocking(audioplayer(mlsSignal, 44100));
% pause(0.1); % This is necessary to let the "tail" of the reverb in
% stop(recordingHandler);
% recordedAudios = getaudiodata(recordingHandler, 'int16');
% 
% audio1 = recordedAudios(:, 1);
% audio2 = recordedAudios(:, 2);
% 
% computedIR1 = computeIRFromMLS(mlsSignal, audio1);
% computedIR2 = computeIRFromMLS(mlsSignal, audio2);
% 
% finalIR = compensateIRWithReference(computedIR1, computedIR2);
% 
% plot(finalIR);


