% Constants
MLS_ORDER = 15;
SAMPLE_RATE = 44100;
SAFE_TIME_AFTERWARDS = 0.5;

close all
clc
disp(sprintf('>> MLS SYSTEM <<\n'));

% Generatio of excitation signal
disp(' > Generating MLS signal')
mlsSignal = generateMLS(MLS_ORDER);

% Create recorder / player handlers
playerHandler = audioplayer(mlsSignal, SAMPLE_RATE);
recorderHandler = audiorecorder(SAMPLE_RATE, 16, 2);

% Start recording and play blocking
disp(' > Reproducing and recording')
record(recorderHandler);
playblocking(playerHandler);

% Finish recording and retrieve data
pause(SAFE_TIME_AFTERWARDS);
stop(recorderHandler);
recordedAudio = double(getaudiodata(recorderHandler, 'int16'));

recordedReference = recordedAudio(:, 1);
recordedSignal = recordedAudio(:, 2);

subplot(2,1,1)
plot(recordedReference)
xlabel('Recorded signal')
subplot(2,1,2)
plot(recordedSignal)
xlabel('Reference')

% Compute IRs
disp(' > Computing individual IRs')
referenceIR = computeIRFromMLS(recordedReference', mlsSignal);
measuredIR = computeIRFromMLS(recordedSignal', mlsSignal);

% Compensate with the loop
disp(' > Compensating IR with the loop')
compensatedIR = compensateIRWithReference(referenceIR, measuredIR);

disp(' > Done!')
figure()
plot(compensatedIR);
xlabel('Samples');
ylabel('Amplitude');
