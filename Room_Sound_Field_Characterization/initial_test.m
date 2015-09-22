%% This script will contain the procedure for the initial test, where the
%  speakers are used sequentially to obtain the IRs to all microphones.
%


% First:  generate the pattern signal (MLS).

% Second: create the audio signal for the six loudspeakers, multiplexing on
%         time and with a time guard between different loudspeakers to 
%         allow for the reverberation to decay.

% Third:  include the signal on the "Ref" channel, to compensate for the
%         delay on the acquisition system.

% Fourth: start the recording on all 16 channels (15 + 1 ref) and play the
%         previously created signal to all six loudspeakers.

% Fifth:  process the recordings to obtain the IRs (deconvolution).

% Sixth:  find out the associated delay time calling the necessary function
%         and store the results for all IRs.

