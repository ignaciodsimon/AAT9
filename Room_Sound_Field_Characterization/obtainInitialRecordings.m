function outputData = obtainInitialRecordings()
%% Performs the initial MLS recordings to obtain the IRs of the system.

% Constants definitions
SAMPLING_FREQ = 44100;
MLS_SIGNAL_ORDER = 15;
MLS_GUARD_TIME = 1.0; % Note: this should come from a pre-test to find out
                      %       how big is the room, and therefore how long
                      %       this guard-time has to be.

% First:  generate the pattern signal (MLS).
mlsSignal = generateMLS(MLS_SIGNAL_ORDER);

% Second: create the audio signal for the six loudspeakers, multiplexing on
%         time and with a time guard between different loudspeakers to 
%         allow for the reverberation to decay.
excitationSignal = zeros(7, ceil((length(mlsSignal) + MLS_GUARD_TIME * SAMPLING_FREQ)* 7));
for i = 1:7
    startPosition = 1 + (i - 1)*(length(mlsSignal) + ceil(MLS_GUARD_TIME * SAMPLING_FREQ));
    excitationSignal(i, startPosition : startPosition + length(mlsSignal) - 1) = mlsSignal;
end
% Test code to plot the generated signals:
% 
% hold on
% plot(excitationSignal(1,:), 'b');
% plot(excitationSignal(2,:), 'r');
% plot(excitationSignal(3,:), 'g');
% plot(excitationSignal(4,:), 'y');
% plot(excitationSignal(5,:), 'k');
% plot(excitationSignal(6,:), 'c');
% plot(excitationSignal(7,:), 'o');

% Third:  include the signal on the "Ref" channel, to compensate for the
%         delay on the acquisition system.



% Fourth: start the recording on all 16 channels (15 + 1 ref) and play the
%         previously created signal to all six loudspeakers.

% For playing / recording multichannel, take a look at:
% http://www.mathworks.com/matlabcentral/fileexchange/4017-pa-wavplay/content/pa_wavplayrecord.m
% and:
% http://www.mathworks.com/matlabcentral/fileexchange/4017-pa-wavplay




% Fifth:  process the recordings to obtain the IRs (deconvolution).

% Sixth:  find out the associated delay time calling the necessary function
%         and store the results for all IRs.


    outputData = 0;
end
