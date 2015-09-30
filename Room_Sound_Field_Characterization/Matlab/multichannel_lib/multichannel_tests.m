%% Description of the multichannel setup
%
%   There are two sound cards on the computer, that will be identified
%   as:
%       [RME HDSP9632 (Top card)] -> "Card1"
%       [RME HDSP9632 (Bottom card)] -> "Card2"
%
%   Three external devices are also used:
%       [Swissonic DA24] -> "DAC"
%       [Presonus Digimax FS] -> "ADC1"
%       [Presonus Digimax FS] -> "ADC2"
%
%   The equipment is connected as follows:
%       Card1(ADAT) -> DAC(ADAT)
%       DAC(BNC) -> ADC1(BCN-IN)
%       ADC1(ADAT-OUT) -> Card1(ADAT-IN)
%       ADC1(BNC-OUT) -> ADC2(BNC-IN)
%       ADC2(ADAT-OUT) -> Card2(ADAT-IN)
%
%   Then, the cards are configured as:
%       Card1 -> Internal clock 44.100
%       Card2 -> External ADAT clock
%
%   Note:
%       The system can also work on 48 kHz if desired, but not higher.
%

function multichannel_tests(varargin)
    %% Simple script to test the multichannel play-and-record capabilities

    clc
    sampleRate = 44100;
    recordDuration = 44100;

    playBuffer = zeros(5000, 12);
    playBuffer(:, 12) = randn(length(playBuffer), 1) /8;

    recordedAudio = playAndRecord(playBuffer, recordDuration, sampleRate);
    plot(recordedAudio);

end

function listAudioDevices()
    %% Function used to show the list of audio devices available

    % Calls the player with no arguments to print a list of I/O devices
    pa_wavplay()

end

function recordedAudio = playAndRecord(audioToPlay, recordDuration, sampleRate)
    %% Function used to perform the multichannel playback and recording 
    %  simultaneously

    % Input / Output device
    playDeviceID = 0;
    recDeviceID = 0;

    % Sound driver to use
    recDeviceType = 'asio';

    % Recording channels
    firstRecChannelIndex = 1;
    lastRecChannelIndex = 16;

    % Performs the recording while playing the output signal
    recordedAudio = pa_wavplayrecord(audioToPlay, playDeviceID, ...
        sampleRate, recordDuration, firstRecChannelIndex, ...
        lastRecChannelIndex, recDeviceID, recDeviceType);

end
