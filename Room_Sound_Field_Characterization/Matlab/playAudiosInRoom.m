function [outputAudio, SAMPLE_RATE] = playAudiosInRoom(inputAudio)

    % Input data and constants definitions
    %INPUT_AUDIO_FILENAME = 'wav_audios/six-channels-pink-noise.wav';
    %OUTPUT_AUDIO_FILENAME = 'wav_audios/received-in-room.wav';
    SPEAKERS_MIC_IRS_FILENAME = 'processed_results/3rd day/mls/final_trimmed_data.mat';
    CENTRAL_MIC_IRS_FILENAME = 'processed_results/3rd day/mls/trimmed_data_central_mics.mat';
    SAMPLE_RATE = 48000;

    addpath('utilities', 'Classes');
%    clc
    
    disp(sprintf('\n    <[ ROOM PLAYBACK TOOL ]>\n\n'));
    
    % Load six-channel input audio
%    disp('  > Loading input audio.');
%    inputAudio = audioread(INPUT_AUDIO_FILENAME);

    % Load impulse responses
    disp('  > Loading impulse responses.');
    speakerMicsIRs = load(SPEAKERS_MIC_IRS_FILENAME);
    speakerMicsIRs = speakerMicsIRs.speakerData;  
    centralMicsIRs = load(CENTRAL_MIC_IRS_FILENAME);
    centralMicsIRs = centralMicsIRs.speakerData;

%     size(centralMicsIRs(1).recordings(1).computedIR)
%     size(speakerMicsIRs(1).microphones(1).recordings(1).computedIR)
%     return



    % Form each output by performing convolution    
    outputAudio = zeros(length(inputAudio) + length(speakerMicsIRs(1).microphones(1).recordings(1).computedIR) -1, 19);

    % Look up table used to convert the currentRxMic (1 ~ 15) 
    % to speaker-mic pair:
    %   1 -> 1,1
    %   2 -> 1,2
    %   3 -> 1,3
    %   4 -> 2,1
    %   5 -> 2,2
    %   6 -> 2,3
    %   7 -> 3,1
    %   8 -> 3,2
    %   9 -> 3,3    __ Jump
    %   10-> 5,1
    %   11-> 5,2
    %   12-> 5,3
    %   13-> 6,1
    %   14-> 6,2
    %   15-> 6,3

    % Produce the output for the microphones on the speakers
    lut = [1,1; 1,2; 1,3; 2,1; 2,2; 2,3; 3,1; 3,2; 3,3; 5,1; 5,2; 5,3; 6,1; 6,2; 6,3];

    disp(sprintf('  > Obtaining audio from speaker-mic #%.2d of 15.', 1));    
    for currentRxMic = 1 : 15
        disp(sprintf('\b\b\b\b\b\b\b\b\b\b%.2d of 15.', currentRxMic));
        for currentTxSpeaker = 1 : 6

%             disp(sprintf('Rx Mic: %d   From spk: %d mic:%d, Tx spk: %d', currentRxMic, lut(currentRxMic, 1), lut(currentRxMic, 2), currentTxSpeaker));

%             size(outputAudio(:, currentRxMic))
%             size(                conv(...
%                     inputAudio(:, currentTxSpeaker), ...
%                     speakerMicsIRs(lut(currentRxMic,1)).microphones(lut(currentRxMic,2)).recordings(currentTxSpeaker).computedIR)')

            outputAudio(:, currentRxMic) = outputAudio(:, currentRxMic) + ...
                conv(...
                    inputAudio(:, currentTxSpeaker), ...
                    speakerMicsIRs(lut(currentRxMic,1)).microphones(lut(currentRxMic,2)).recordings(currentTxSpeaker).computedIR);

%                 close all
%                 subplot(2,1,1)
%                 plot(inputAudio(:, currentTxSpeaker))
%                 subplot(2,1,2)
%                 plot(speakerMicsIRs(lut(currentRxMic,1)).microphones(lut(currentRxMic,2)).recordings(currentTxSpeaker).computedIR)
%                 pause
                
                % To show the IR used in each iteration
%                 close all
%                 plot(speakerMicsIRs(lut(currentRxMic,1)).microphones(lut(currentRxMic,2)).recordings(currentTxSpeaker).computedIR);
%                 pause
        end
    end

    % Produce the output for the microphones in the middle
    disp(sprintf('  > Obtaining audio from central mic #%d of 4.', 1));
    for currentRxMic = 16 : 19
        disp(sprintf('\b\b\b\b\b\b\b\b%d of 4.', currentRxMic - 15));
    
        for currentTxSpeaker = 1 : 6

%             disp(sprintf('Output: %d - Central mic: %d - From spk: %d', currentRxMic, currentRxMic - 15, currentTxSpeaker));
            outputAudio(:, currentRxMic) = outputAudio(:, currentRxMic) + ...
                conv(...
                     inputAudio(:, currentTxSpeaker), ...
                     centralMicsIRs(currentRxMic - 15).recordings(currentTxSpeaker).computedIR);
        end
    end

    % Normalize amplitude to -1 dBFS
    normalizationValue = max(max(abs(outputAudio))) * 10^(1/20);
    outputAudio = outputAudio / normalizationValue;

%    % Save generated recordings
%    disp('  > Saving generated audio.');
%    audiowrite(OUTPUT_AUDIO_FILENAME, outputAudio, SAMPLE_RATE);

    disp(sprintf('\n  > All done!'));
end
