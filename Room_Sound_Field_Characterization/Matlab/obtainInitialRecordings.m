function outputData = obtainInitialRecordings()
%% Performs the initial MLS recordings to obtain the IRs of the system.

clc
addpath('multichannel_lib', 'classes');

disp(sprintf('<[ INITIAL SETUP MEASUREMENTS ]>\n'));

%% Constants definitions
SAMPLING_FREQ = 48000;
INITIAL_DELAY_SAMPLES = 2000;
FINAL_RECORDING_MARGIN_SAMPLES = 5000;
PRE_IR_MARGIN_SAMPLES = 300;
MLS_SIGNAL_ORDER = 13;
MLS_GUARD_TIME = 2^MLS_SIGNAL_ORDER * 0.5 / SAMPLING_FREQ;
                      % Note: this should come from a pre-test to find out
                      %       how big is the room, and therefore how long
                      %       this guard-time has to be.
REF_SIGNAL_TRIM_MARGIN = 400;

%% First:  generate the pattern signal (MLS).
disp('  > Generating excitation signals.');
mlsSignal = generateMLS(MLS_SIGNAL_ORDER);

%% Second: create the audio signal for the six loudspeakers, multiplexing on
%         time and with a time guard between different loudspeakers to 
%         allow for the reverberation to decay.
excitationSignal = zeros(ceil((length(mlsSignal) + MLS_GUARD_TIME * SAMPLING_FREQ)* 7), 7);
for i = 1 : 7
    startPosition = 1 + (i - 1)*(length(mlsSignal) + ceil(MLS_GUARD_TIME * SAMPLING_FREQ));
    excitationSignal(startPosition : startPosition + length(mlsSignal) - 1, i) = mlsSignal;
end

% Give some extra space at the beginning
disp(sprintf('  > Playing and recording.\n'));
initialDelayZeros = zeros(INITIAL_DELAY_SAMPLES, size(excitationSignal, 2));
excitationSignal = [initialDelayZeros; excitationSignal];

% Play the generated signals and record all microphones (and loop)
recordedAudio = playAndRecord(excitationSignal, length(excitationSignal) + FINAL_RECORDING_MARGIN_SAMPLES, SAMPLING_FREQ);


% for i = 1:16
%     subplot(8, 2, i);
%     plot(recordedAudio(:,i));
%     ylim([-0.3 0.3]);
%     xlabel(sprintf('Channel %d', i));
% end

% Extracts the recording for the loop IR

% Cuts the first half part of reference playing / recording
middlePoint = round(length(recordedAudio(:,16)) * 0.5);
referencePlaying = excitationSignal(middlePoint : length(excitationSignal(:,7)), 7);
referenceRecording = recordedAudio(middlePoint : length(recordedAudio(:, 16)), 16);

% Finds a reasonable starting point to trim reference playing / recording
peakValueRefPlaying = max(abs(referencePlaying));
peakValueRefPlaying = max(abs(referenceRecording));

% Start point on the reference playing signal
for i = 1 : length(referencePlaying)
    if abs(referencePlaying(i)) >= peakValueRefPlaying / 2
        break
    end
end

if i-200 >= 1
    refSignalStartPoint = i - REF_SIGNAL_TRIM_MARGIN;
else
    refSignalStartPoint = 1;
end

% Stop point on the reference playing signal
for i = 1 : length(referenceRecording)
    if abs(referenceRecording(length(referenceRecording) - i)) >= peakValueRefPlaying / 2
        break
    end
end

if length(referenceRecording) - i + REF_SIGNAL_TRIM_MARGIN <= length(referenceRecording)
    refSignalEndPoint = length(referenceRecording) - i + REF_SIGNAL_TRIM_MARGIN;
else
    refSignalEndPoint = length(referenceRecording);
end

referencePlaying = referencePlaying(refSignalStartPoint : refSignalEndPoint);
referenceRecording = referenceRecording(refSignalStartPoint : refSignalEndPoint);

% subplot(2,1,1)
% plot(referencePlaying)
% subplot(2,1,2)
% plot(referenceRecording)
% pause

% Compute the loop IR and find the delay inserted by the system
referenceIR = computeIRFromMLS(referenceRecording', referencePlaying');
[~, hardwareLatencySamples] = estimateDelay(referenceIR, 1);

% Trims the reference IR tail
referenceIR = referenceIR(1 : hardwareLatencySamples + 500);

% Introduces the pre-margin for the IR also in the reference. The reason
% for this margin is to allow the IR to have a "soft rise".
referenceIR = [zeros(1, PRE_IR_MARGIN_SAMPLES) , referenceIR];

% Substract this delay from all recordings
recordedAudio = recordedAudio(hardwareLatencySamples - PRE_IR_MARGIN_SAMPLES : length(recordedAudio), :);

% 
% subplot(2,1,1)
% plot(referenceRecording, 'g')
% hold on
% plot(referencePlaying, 'r')
% 
% subplot(2,1,2)
% plot(referenceIR)
% 
% return









tempLine = zeros(length(recordedAudio), 1);
tempLineEnds = zeros(length(recordedAudio), 1);


% Find cut limits for the recorded signals
startPoints = zeros(7, 1);
endPoints = zeros(7, 1);
for i = 1:7
    currentStartPoint = (i-1) * (length(mlsSignal) + ceil(MLS_GUARD_TIME * SAMPLING_FREQ)) + 2 + INITIAL_DELAY_SAMPLES - PRE_IR_MARGIN_SAMPLES;
    currentEndPoint = currentStartPoint + (length(mlsSignal) + ceil(MLS_GUARD_TIME * SAMPLING_FREQ));
    startPoints(i) = currentStartPoint;

    if currentEndPoint > length(recordedAudio)
        endPoints(i) = length(recordedAudio);
    else
        endPoints(i) = currentEndPoint;
    end

    tempLine(currentStartPoint) = 1;
    tempLineEnds(currentEndPoint) = 1;
end


% 
% plot(recordedAudio)
% hold on
% plot(tempLine, 'g')
% plot(tempLineEnds, 'r')
% return




%% Third:  play the generated signal and record all 16 channels. 
disp(sprintf('\n  > Splitting recordings.'));

% Constants for simplifying the code below
MIC1 = 1; MIC2 = 2; MIC3 = 3; MIC4 = 4; MIC5 = 5; MIC6 = 6; MIC7 = 7;
MIC8 = 8; MIC9 = 9; MIC10 = 10; MIC11 = 11; MIC12 = 12; MIC13 = 13;
MIC14 = 14; MIC15 = 15; LOOPIN = 16; L = 1; R = 2; C = 3; LFE = 4;
LS = 5; RS = 6; LOOPOUT = 7;

% Loop signal for IR compensation
%referenceRecording = recordedAudio(startPoints(LOOPOUT) : endPoints(LOOPOUT), LOOPIN);


% Mics from speaker 1 (L)


speaker_L_recordings_micA_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC1);
speaker_L_recordings_micA_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC1);
speaker_L_recordings_micA_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC1);
speaker_L_recordings_micA_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC1);
speaker_L_recordings_micA_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC1);
speaker_L_recordings_micA_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC1);

speaker_L_recordings_micB_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC2);
speaker_L_recordings_micB_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC2);
speaker_L_recordings_micB_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC2);
speaker_L_recordings_micB_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC2);
speaker_L_recordings_micB_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC2);
speaker_L_recordings_micB_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC2);

speaker_L_recordings_micC_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC3);
speaker_L_recordings_micC_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC3);
speaker_L_recordings_micC_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC3);
speaker_L_recordings_micC_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC3);
speaker_L_recordings_micC_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC3);
speaker_L_recordings_micC_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC3);


% Mics from speaker 2 (R)

speaker_R_recordings_micA_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC4);
speaker_R_recordings_micA_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC4);
speaker_R_recordings_micA_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC4);
speaker_R_recordings_micA_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC4);
speaker_R_recordings_micA_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC4);
speaker_R_recordings_micA_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC4);

speaker_R_recordings_micB_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC5);
speaker_R_recordings_micB_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC5);
speaker_R_recordings_micB_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC5);
speaker_R_recordings_micB_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC5);
speaker_R_recordings_micB_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC5);
speaker_R_recordings_micB_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC5);

speaker_R_recordings_micC_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC6);
speaker_R_recordings_micC_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC6);
speaker_R_recordings_micC_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC6);
speaker_R_recordings_micC_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC6);
speaker_R_recordings_micC_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC6);
speaker_R_recordings_micC_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC6);


% Mics from speaker 3 (C)

speaker_C_recordings_micA_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC7);
speaker_C_recordings_micA_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC7);
speaker_C_recordings_micA_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC7);
speaker_C_recordings_micA_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC7);
speaker_C_recordings_micA_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC7);
speaker_C_recordings_micA_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC7);

speaker_C_recordings_micB_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC8);
speaker_C_recordings_micB_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC8);
speaker_C_recordings_micB_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC8);
speaker_C_recordings_micB_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC8);
speaker_C_recordings_micB_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC8);
speaker_C_recordings_micB_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC8);

speaker_C_recordings_micC_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC9);
speaker_C_recordings_micC_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC9);
speaker_C_recordings_micC_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC9);
speaker_C_recordings_micC_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC9);
speaker_C_recordings_micC_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC9);
speaker_C_recordings_micC_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9);


% Mics from speaker 4 (LFE)

speaker_LFE_recordings_micA_fromspeakerL = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micA_fromspeakerR = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micA_fromspeakerC = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micA_fromspeakerLS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micA_fromspeakerRS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micA_fromspeakerLFE = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));

speaker_LFE_recordings_micB_fromspeakerL = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micB_fromspeakerR = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micB_fromspeakerC = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micB_fromspeakerLS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micB_fromspeakerRS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micB_fromspeakerLFE = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));

speaker_LFE_recordings_micC_fromspeakerL = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micC_fromspeakerR = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micC_fromspeakerC = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micC_fromspeakerLS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micC_fromspeakerRS = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));
speaker_LFE_recordings_micC_fromspeakerLFE = zeros(size(recordedAudio(startPoints(LFE) : endPoints(LFE), MIC9)));


% Mics from speaker 5 (LS)

speaker_LS_recordings_micA_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC10);
speaker_LS_recordings_micA_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC10);
speaker_LS_recordings_micA_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC10);
speaker_LS_recordings_micA_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC10);
speaker_LS_recordings_micA_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC10);
speaker_LS_recordings_micA_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC10);

speaker_LS_recordings_micB_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC11);
speaker_LS_recordings_micB_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC11);
speaker_LS_recordings_micB_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC11);
speaker_LS_recordings_micB_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC11);
speaker_LS_recordings_micB_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC11);
speaker_LS_recordings_micB_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC11);

speaker_LS_recordings_micC_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC12);
speaker_LS_recordings_micC_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC12);
speaker_LS_recordings_micC_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC12);
speaker_LS_recordings_micC_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC12);
speaker_LS_recordings_micC_fromspeakerLR = recordedAudio(startPoints(RS) : endPoints(RS), MIC12);
speaker_LS_recordings_micC_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC12);


% Mics from speaker 6 (RS)

speaker_RS_recordings_micA_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC13);
speaker_RS_recordings_micA_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC13);
speaker_RS_recordings_micA_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC13);
speaker_RS_recordings_micA_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC13);
speaker_RS_recordings_micA_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC13);
speaker_RS_recordings_micA_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC13);

speaker_RS_recordings_micB_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC14);
speaker_RS_recordings_micB_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC14);
speaker_RS_recordings_micB_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC14);
speaker_RS_recordings_micB_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC14);
speaker_RS_recordings_micB_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC14);
speaker_RS_recordings_micB_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC14);

speaker_RS_recordings_micC_fromspeakerL = recordedAudio(startPoints(L) : endPoints(L), MIC15);
speaker_RS_recordings_micC_fromspeakerR = recordedAudio(startPoints(R) : endPoints(R), MIC15);
speaker_RS_recordings_micC_fromspeakerC = recordedAudio(startPoints(C) : endPoints(C), MIC15);
speaker_RS_recordings_micC_fromspeakerLS = recordedAudio(startPoints(LS) : endPoints(LS), MIC15);
speaker_RS_recordings_micC_fromspeakerRS = recordedAudio(startPoints(RS) : endPoints(RS), MIC15);
speaker_RS_recordings_micC_fromspeakerLFE = recordedAudio(startPoints(LFE) : endPoints(LFE), MIC15);


%% Structures for storing the data
speakerData = [TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker()];


% Mic 1(A) from Speaker 1 (L)
speakerData(1).id = 1;
speakerData(1).microphones(1).id = 1;
speakerData(1).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(1).recordings(1).recording = speaker_L_recordings_micA_fromspeakerL;
speakerData(1).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(1).recordings(2).recording = speaker_L_recordings_micA_fromspeakerR;
speakerData(1).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(1).recordings(3).recording = speaker_L_recordings_micA_fromspeakerC;
speakerData(1).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(1).recordings(4).recording = speaker_L_recordings_micA_fromspeakerLS;
speakerData(1).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(1).recordings(5).recording = speaker_L_recordings_micA_fromspeakerRS;
speakerData(1).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(1).recordings(6).recording = speaker_L_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 1 (L)
speakerData(1).microphones(2).id = 2;
speakerData(1).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(2).recordings(1).recording = speaker_L_recordings_micB_fromspeakerL;
speakerData(1).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(2).recordings(2).recording = speaker_L_recordings_micB_fromspeakerR;
speakerData(1).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(2).recordings(3).recording = speaker_L_recordings_micB_fromspeakerC;
speakerData(1).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(2).recordings(4).recording = speaker_L_recordings_micB_fromspeakerLS;
speakerData(1).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(2).recordings(5).recording = speaker_L_recordings_micB_fromspeakerRS;
speakerData(1).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(2).recordings(6).recording = speaker_L_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 1 (L)
speakerData(1).microphones(3).id = 3;
speakerData(1).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(1).microphones(3).recordings(1).recording = speaker_L_recordings_micC_fromspeakerL;
speakerData(1).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(1).microphones(3).recordings(2).recording = speaker_L_recordings_micC_fromspeakerR;
speakerData(1).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(1).microphones(3).recordings(3).recording = speaker_L_recordings_micC_fromspeakerC;
speakerData(1).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(1).microphones(3).recordings(4).recording = speaker_L_recordings_micC_fromspeakerLS;
speakerData(1).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(1).microphones(3).recordings(5).recording = speaker_L_recordings_micC_fromspeakerRS;
speakerData(1).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(1).microphones(3).recordings(6).recording = speaker_L_recordings_micC_fromspeakerLFE;


% Mic 1(A) from Speaker 2 (R)
speakerData(2).id = 2;
speakerData(2).microphones(1).id = 1;
speakerData(2).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(1).recordings(1).recording = speaker_R_recordings_micA_fromspeakerL;
speakerData(2).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(1).recordings(2).recording = speaker_R_recordings_micA_fromspeakerR;
speakerData(2).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(1).recordings(3).recording = speaker_R_recordings_micA_fromspeakerC;
speakerData(2).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(1).recordings(4).recording = speaker_R_recordings_micA_fromspeakerLS;
speakerData(2).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(1).recordings(5).recording = speaker_R_recordings_micA_fromspeakerRS;
speakerData(2).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(1).recordings(6).recording = speaker_R_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 2 (R)
speakerData(2).microphones(2).id = 2;
speakerData(2).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(2).recordings(1).recording = speaker_R_recordings_micB_fromspeakerL;
speakerData(2).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(2).recordings(2).recording = speaker_R_recordings_micB_fromspeakerR;
speakerData(2).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(2).recordings(3).recording = speaker_R_recordings_micB_fromspeakerC;
speakerData(2).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(2).recordings(4).recording = speaker_R_recordings_micB_fromspeakerLS;
speakerData(2).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(2).recordings(5).recording = speaker_R_recordings_micB_fromspeakerRS;
speakerData(2).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(2).recordings(6).recording = speaker_R_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 2 (R)
speakerData(2).microphones(3).id = 3;
speakerData(2).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(2).microphones(3).recordings(1).recording = speaker_R_recordings_micC_fromspeakerL;
speakerData(2).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(2).microphones(3).recordings(2).recording = speaker_R_recordings_micC_fromspeakerR;
speakerData(2).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(2).microphones(3).recordings(3).recording = speaker_R_recordings_micC_fromspeakerC;
speakerData(2).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(2).microphones(3).recordings(4).recording = speaker_R_recordings_micC_fromspeakerLS;
speakerData(2).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(2).microphones(3).recordings(5).recording = speaker_R_recordings_micC_fromspeakerRS;
speakerData(2).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(2).microphones(3).recordings(6).recording = speaker_R_recordings_micC_fromspeakerLFE;


% Mic 1(A) from Speaker 3 (C)
speakerData(3).id = 3;
speakerData(3).microphones(1).id = 1;
speakerData(3).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(1).recordings(1).recording = speaker_C_recordings_micA_fromspeakerL;
speakerData(3).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(1).recordings(2).recording = speaker_C_recordings_micA_fromspeakerR;
speakerData(3).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(1).recordings(3).recording = speaker_C_recordings_micA_fromspeakerC;
speakerData(3).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(1).recordings(4).recording = speaker_C_recordings_micA_fromspeakerLS;
speakerData(3).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(1).recordings(5).recording = speaker_C_recordings_micA_fromspeakerRS;
speakerData(3).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(1).recordings(6).recording = speaker_C_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 3 (C)
speakerData(3).microphones(2).id = 2;
speakerData(3).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(2).recordings(1).recording = speaker_C_recordings_micB_fromspeakerL;
speakerData(3).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(2).recordings(2).recording = speaker_C_recordings_micB_fromspeakerR;
speakerData(3).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(2).recordings(3).recording = speaker_C_recordings_micB_fromspeakerC;
speakerData(3).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(2).recordings(4).recording = speaker_C_recordings_micB_fromspeakerLS;
speakerData(3).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(2).recordings(5).recording = speaker_C_recordings_micB_fromspeakerRS;
speakerData(3).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(2).recordings(6).recording = speaker_C_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 3 (C)
speakerData(3).microphones(3).id = 3;
speakerData(3).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(3).microphones(3).recordings(1).recording = speaker_C_recordings_micC_fromspeakerL;
speakerData(3).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(3).microphones(3).recordings(2).recording = speaker_C_recordings_micC_fromspeakerR;
speakerData(3).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(3).microphones(3).recordings(3).recording = speaker_C_recordings_micC_fromspeakerC;
speakerData(3).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(3).microphones(3).recordings(4).recording = speaker_C_recordings_micC_fromspeakerLS;
speakerData(3).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(3).microphones(3).recordings(5).recording = speaker_C_recordings_micC_fromspeakerRS;
speakerData(3).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(3).microphones(3).recordings(6).recording = speaker_C_recordings_micC_fromspeakerLFE;


% Mic 1(A) from Speaker 4 (LFE)
speakerData(4).id = 4;
speakerData(4).microphones(1).id = 1;
speakerData(4).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(1).recordings(1).recording = speaker_LFE_recordings_micA_fromspeakerL;
speakerData(4).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(1).recordings(2).recording = speaker_LFE_recordings_micA_fromspeakerR;
speakerData(4).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(1).recordings(3).recording = speaker_LFE_recordings_micA_fromspeakerC;
speakerData(4).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(1).recordings(4).recording = speaker_LFE_recordings_micA_fromspeakerLS;
speakerData(4).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(1).recordings(5).recording = speaker_LFE_recordings_micA_fromspeakerRS;
speakerData(4).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(1).recordings(6).recording = speaker_LFE_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 4 (LFE)
speakerData(4).microphones(2).id = 2;
speakerData(4).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(2).recordings(1).recording = speaker_LFE_recordings_micB_fromspeakerL;
speakerData(4).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(2).recordings(2).recording = speaker_LFE_recordings_micB_fromspeakerR;
speakerData(4).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(2).recordings(3).recording = speaker_LFE_recordings_micB_fromspeakerC;
speakerData(4).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(2).recordings(4).recording = speaker_LFE_recordings_micB_fromspeakerLS;
speakerData(4).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(2).recordings(5).recording = speaker_LFE_recordings_micB_fromspeakerRS;
speakerData(4).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(2).recordings(6).recording = speaker_LFE_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 4 (LFE)
speakerData(4).microphones(3).id = 3;
speakerData(4).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(4).microphones(3).recordings(1).recording = speaker_LFE_recordings_micC_fromspeakerL;
speakerData(4).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(4).microphones(3).recordings(2).recording = speaker_LFE_recordings_micC_fromspeakerR;
speakerData(4).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(4).microphones(3).recordings(3).recording = speaker_LFE_recordings_micC_fromspeakerC;
speakerData(4).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(4).microphones(3).recordings(4).recording = speaker_LFE_recordings_micC_fromspeakerLS;
speakerData(4).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(4).microphones(3).recordings(5).recording = speaker_LFE_recordings_micC_fromspeakerRS;
speakerData(4).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(4).microphones(3).recordings(6).recording = speaker_LFE_recordings_micC_fromspeakerLFE;


% Mic 1(A) from Speaker 5 (LS)
speakerData(5).id = 5;
speakerData(5).microphones(1).id = 1;
speakerData(5).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(1).recordings(1).recording = speaker_LS_recordings_micA_fromspeakerL;
speakerData(5).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(1).recordings(2).recording = speaker_LS_recordings_micA_fromspeakerR;
speakerData(5).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(1).recordings(3).recording = speaker_LS_recordings_micA_fromspeakerC;
speakerData(5).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(1).recordings(4).recording = speaker_LS_recordings_micA_fromspeakerLS;
speakerData(5).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(1).recordings(5).recording = speaker_LS_recordings_micA_fromspeakerRS;
speakerData(5).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(1).recordings(6).recording = speaker_LS_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 5 (LS)
speakerData(5).microphones(2).id = 2;
speakerData(5).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(2).recordings(1).recording = speaker_LS_recordings_micB_fromspeakerL;
speakerData(5).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(2).recordings(2).recording = speaker_LS_recordings_micB_fromspeakerR;
speakerData(5).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(2).recordings(3).recording = speaker_LS_recordings_micB_fromspeakerC;
speakerData(5).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(2).recordings(4).recording = speaker_LS_recordings_micB_fromspeakerLS;
speakerData(5).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(2).recordings(5).recording = speaker_LS_recordings_micB_fromspeakerRS;
speakerData(5).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(2).recordings(6).recording = speaker_LS_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 5 (LS)
speakerData(5).microphones(3).id = 3;
speakerData(5).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(5).microphones(3).recordings(1).recording = speaker_LS_recordings_micC_fromspeakerL;
speakerData(5).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(5).microphones(3).recordings(2).recording = speaker_LS_recordings_micC_fromspeakerR;
speakerData(5).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(5).microphones(3).recordings(3).recording = speaker_LS_recordings_micC_fromspeakerC;
speakerData(5).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(5).microphones(3).recordings(4).recording = speaker_LS_recordings_micC_fromspeakerLS;
speakerData(5).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(5).microphones(3).recordings(5).recording = speaker_LS_recordings_micC_fromspeakerLR;
speakerData(5).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(5).microphones(3).recordings(6).recording = speaker_LS_recordings_micC_fromspeakerLFE;


% Mic 1(A) from Speaker 6 (RS)
speakerData(6).id = 6;
speakerData(6).microphones(1).id = 1;
speakerData(6).microphones(1).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(1).recordings(1).recording = speaker_RS_recordings_micA_fromspeakerL;
speakerData(6).microphones(1).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(1).recordings(2).recording = speaker_RS_recordings_micA_fromspeakerR;
speakerData(6).microphones(1).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(1).recordings(3).recording = speaker_RS_recordings_micA_fromspeakerC;
speakerData(6).microphones(1).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(1).recordings(4).recording = speaker_RS_recordings_micA_fromspeakerLS;
speakerData(6).microphones(1).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(1).recordings(5).recording = speaker_RS_recordings_micA_fromspeakerRS;
speakerData(6).microphones(1).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(1).recordings(6).recording = speaker_RS_recordings_micA_fromspeakerLFE;

% Mic 2(B) from Speaker 6 (RS)
speakerData(6).microphones(2).id = 2;
speakerData(6).microphones(2).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(2).recordings(1).recording = speaker_RS_recordings_micB_fromspeakerL;
speakerData(6).microphones(2).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(2).recordings(2).recording = speaker_RS_recordings_micB_fromspeakerR;
speakerData(6).microphones(2).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(2).recordings(3).recording = speaker_RS_recordings_micB_fromspeakerC;
speakerData(6).microphones(2).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(2).recordings(4).recording = speaker_RS_recordings_micB_fromspeakerLS;
speakerData(6).microphones(2).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(2).recordings(5).recording = speaker_RS_recordings_micB_fromspeakerRS;
speakerData(6).microphones(2).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(2).recordings(6).recording = speaker_RS_recordings_micB_fromspeakerLFE;

% Mic 3(C) from Speaker 6 (RS)
speakerData(6).microphones(3).id = 3;
speakerData(6).microphones(3).recordings(1).fromSpeaker = 1;
speakerData(6).microphones(3).recordings(1).recording = speaker_RS_recordings_micC_fromspeakerL;
speakerData(6).microphones(3).recordings(2).fromSpeaker = 2;
speakerData(6).microphones(3).recordings(2).recording = speaker_RS_recordings_micC_fromspeakerR;
speakerData(6).microphones(3).recordings(3).fromSpeaker = 3;
speakerData(6).microphones(3).recordings(3).recording = speaker_RS_recordings_micC_fromspeakerC;
speakerData(6).microphones(3).recordings(4).fromSpeaker = 4;
speakerData(6).microphones(3).recordings(4).recording = speaker_RS_recordings_micC_fromspeakerLS;
speakerData(6).microphones(3).recordings(5).fromSpeaker = 5;
speakerData(6).microphones(3).recordings(5).recording = speaker_RS_recordings_micC_fromspeakerRS;
speakerData(6).microphones(3).recordings(6).fromSpeaker = 6;
speakerData(6).microphones(3).recordings(6).recording = speaker_RS_recordings_micC_fromspeakerLFE;


%% Fifth:  process the recordings to obtain the IRs (deconvolution) and corresponding time delay.
tic

% subplot(2,1,1)
% plot(referenceRecording)
% xlabel('reference recording');
% subplot(2,1,2)
% plot(mlsSignal)
% xlabel('mls signal')
% pause


disp('  > Computing reference (Loop) IR.');
%referenceIR = computeIRFromMLS(mlsSignal, referenceRecording');

% plot(referenceIR)
% xlabel('reference ir')
% pause

disp(sprintf('  > Computing IR 000 of 000 [...]'));
currentIteration = 1;
for currentReceivingSpeakerIndex = 1 : 6
    for currentMicIndex = 1 : 3
        for currentTransmittingSpeakerIndex = 1 : 6

            disp(sprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b %.3d of %.3d [...]', currentIteration, 6 * 3 * 6));
            currentIteration = currentIteration + 1;

%             close all
%             subplot(3,1,1)
%             plot( speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).recording)
%             xlabel('Received recording')
%             subplot(3,1,2)
%             plot(referenceRecording)
%             xlabel('reference recording')
%             subplot(3,1,3)
%             plot(mlsSignal)
%             xlabel('mls signal')
%             pause

            % Computes the IR
            disp(sprintf('\b\b\b\b\b\b[#..]'));
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR = ...
                computeIRFromMLS( ...
                    speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).recording', ...
                    mlsSignal);

            close all
            subplot(3,1,1)
            plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR)
            xlabel('Before correction')
                
%                plot(mlsSignal, 'g')
%                hold on
%                plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).recording', 'r')
%                pause


%             close all
%             subplot(2,1,1)
%             plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).recording');
%             xlabel('Input signal')
%             subplot(2,1,2)
%             plot(referenceRecording)
%             xlabel('Reference recording');
%             pause

%             subplot(2,1,1)
%             plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR);
%             xlabel('speaker ir');
%             subplot(2,1,2)
%             plot(referenceIR);
%             xlabel('reference ir');
% 
%             size(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR)
%             size(referenceIR)
%             pause
%             

%             close all
%             plot(referenceIR, 'g')
%             hold on
%             plot([zeros(1, hardwareLatencySamples - PRE_IR_MARGIN_SAMPLES), speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR])
%             pause

            % Corrects the IR with the reference IR
            disp(sprintf('\b\b\b\b\b\b[##.]'));
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR = ...
                compensateIRWithReference( ...
                    [zeros(1, hardwareLatencySamples - PRE_IR_MARGIN_SAMPLES), speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR], ...
                    referenceIR);

% 
% 
%             close all
%             plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR)
%             xlabel('after correction')
%             pause
% 
% 
%             close all
%             spectrum = abs(fft(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR(1:100)));
%             semilogx(20*log10(spectrum));
%             pause
            
                
%             subplot(3,1,2)
%             plot(speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR)
%             xlabel('after correction')
%             subplot(3,1,3)
%             plot(referenceIR)
%             xlabel('reference ir')
%             pause

            % Find out associated delay time for each IR
            disp(sprintf('\b\b\b\b\b\b[###]'));
            speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).estimatedTime = ...
                estimateDelay( ...
                    speakerData(currentReceivingSpeakerIndex).microphones(currentMicIndex).recordings(currentTransmittingSpeakerIndex).computedIR, ...
                    SAMPLING_FREQ);

        end
    end
end

    outputData = speakerData;
    elapsedTime = toc;
    disp(sprintf('  > All IR computations done. Elapsed time: %d:%d [mm:ss]', floor(elapsedTime/60), round(elapsedTime - floor(elapsedTime/60)*60) ));
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


