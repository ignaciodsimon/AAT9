function plotRecordings(inputData)

    SPEAKER_L = 1;
    SPEAKER_R = 2;
    SPEAKER_C = 3;
    SPEAKER_LFE = 4;
    SPEAKER_LS = 5;
    SPEAKER_RS = 6;

    close all

    plotsHandlers = [figure('name', 'TX from Speaker-L')
                     figure('name', 'TX from Speaker-R')
                     figure('name', 'TX from Speaker-C')
                     figure('name', 'TX from Speaker-LFE')
                     figure('name', 'TX from Speaker-LS')
                     figure('name', 'TX from Speaker-RS')
                     ];

    for currentSpeakerIndex = 1 : length(inputData)

        speaker = inputData(currentSpeakerIndex);
        receivingSpeaker = speaker.id;

        for currentMicrophoneIndex = 1: length(speaker.microphones)
            
            microphone = speaker.microphones(currentMicrophoneIndex);
            microphoneID = microphone.id;

            for currentRecordingIndex = 1 : length(microphone.recordings)

                recording = microphone.recordings(currentRecordingIndex);
                transmittingSpeaker = recording.fromSpeaker;

                % Recall the associated figure and plot the data in the
                % corresponding subplot
                figure(plotsHandlers(transmittingSpeaker));

                switch microphoneID
                    case 1
                        plotColor = 'r';
                    case 2
                        plotColor = 'g';
                    case 3
                        plotColor = 'b';
                    otherwise
                        plotColor = 'k';
                end

                switch receivingSpeaker
                    case SPEAKER_L
                        plotTitle = 'Received at: Speaker L';
                    case SPEAKER_R
                        plotTitle = 'Received at: Speaker R';
                    case SPEAKER_C
                        plotTitle = 'Received at: Speaker C';
                    case SPEAKER_LFE
                        plotTitle = 'Received at: Speaker LFE';
                    case SPEAKER_LS
                        plotTitle = 'Received at: Speaker LS';
                    case SPEAKER_RS
                        plotTitle = 'Received at: Speaker RS';
                    otherwise
                        plotTitle = '--Unknown receiving speaker--';
                end

                subplot(3, 2, receivingSpeaker);
                hold on
                plot(recording.computedIR, plotColor);
                title(plotTitle);

            end
        end
    end

end