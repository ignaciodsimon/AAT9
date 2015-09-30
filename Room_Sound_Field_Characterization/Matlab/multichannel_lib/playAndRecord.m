function recordedAudio = playAndRecord(audioToPlay, recordDuration, sampleRate)
    %% Function used to perform the multichannel playback and recording 
    %  simultaneously

    % Maps the input audio channels to the output matrix
    outputAudioMatrix = zeros(size(audioToPlay, 1), 12);
    outputAudioMatrix(:, 5: 5 + size(audioToPlay, 2)-1) = audioToPlay;

    % Input / Output device
    playDeviceID = 0;
    recDeviceID = 0;

    % Sound driver to use
    recDeviceType = 'asio';

    % Recording channels
    firstRecChannelIndex = 5;
    lastRecChannelIndex = 24;

    % Performs the recording while playing the output signal
    recordedAudio = pa_wavplayrecord(outputAudioMatrix, playDeviceID, ...
        sampleRate, recordDuration, firstRecChannelIndex, ...
        lastRecChannelIndex, recDeviceID, recDeviceType);

    recordedAudio = [recordedAudio(:, 1:8), recordedAudio(:,13:20)];
end
