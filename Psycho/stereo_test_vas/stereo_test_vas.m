
function stereo_test_vas(inputarg)

    % Test configuration
    amountOfRepetitions = 1;
    inputAudioFilename = 'audio_signals/input_audio.wav';

    clc;
    disp(sprintf('-= Surround-to-headphones experience test =-\n\n>> Preparing test ...'));

    % Create header of results file
    resultData = sprintf(...
        '= Surround-to-headphones =\n  Experience test report\n\n  Test performed on:\n  %s \n -----------------------\n\n# Presented  User   User   Realism\n    angle    dist   angle\n\n', ...
        datestr(clock,'HH:MM:SS - dd/mm/yyyy'));

    % Load input audio
    disp(' > Loading input audio ...');
    [inputAudio, samplingFreq] = audioread(inputAudioFilename);

    % Front audio
    disp(' > Generating all convolutions ...');
    frontAudio = convolveSound(inputAudio, 0);
        % Left side audios
    side_30_Audio = convolveSound(inputAudio, 30);
    side_45_Audio = convolveSound(inputAudio, 45);
    side_72_Audio = convolveSound(inputAudio, 72);
    side_110_Audio = convolveSound(inputAudio, 110);
    side_144_Audio = convolveSound(inputAudio, 144);
    side_170_Audio = convolveSound(inputAudio, 170);
        % Right side audios
    side__30_Audio = convolveSound(inputAudio, -30);
    side__45_Audio = convolveSound(inputAudio, -45);
    side__72_Audio = convolveSound(inputAudio, -72);
    side__110_Audio = convolveSound(inputAudio, -110);
    side__144_Audio = convolveSound(inputAudio, -144);
    side__170_Audio = convolveSound(inputAudio, -170);

    disp(' > Ready!');

    % Presents the test to the user
    presentIntro();

    % Presents the audios in a random order
    audioAngles = [];
    for i = 1 : amountOfRepetitions
        audioAngles = [audioAngles, [0 30 45 72 110 144 170 -170 -144 -110 -72 -45 -30]];
    end
    audioIndexes = 1:1:length(audioAngles);
    audioIndexes = audioIndexes(randperm(length(audioIndexes)));
    
    for i = 1 : length(audioIndexes)
        currentAngle = audioAngles(audioIndexes(i));
        switch currentAngle
            case 0
                playerHandler = audioplayer(frontAudio, samplingFreq);
            case 30
                playerHandler = audioplayer(side_30_Audio, samplingFreq);
            case 45
                playerHandler = audioplayer(side_45_Audio, samplingFreq);
            case 72
                playerHandler = audioplayer(side_72_Audio, samplingFreq);
            case 110
                playerHandler = audioplayer(side_110_Audio, samplingFreq);
            case 144
                playerHandler = audioplayer(side_144_Audio, samplingFreq);
            case 170
                playerHandler = audioplayer(side_170_Audio, samplingFreq);
            case -30
                playerHandler = audioplayer(side__30_Audio, samplingFreq);
            case -45
                playerHandler = audioplayer(side__45_Audio, samplingFreq);
            case -72
                playerHandler = audioplayer(side__72_Audio, samplingFreq);
            case -110
                playerHandler = audioplayer(side__110_Audio, samplingFreq);
            case -144
                playerHandler = audioplayer(side__144_Audio, samplingFreq);
            case -170
                playerHandler = audioplayer(side__170_Audio, samplingFreq);
        end

        % Play current sound
        play(playerHandler);

        % Show graphic interface to allow user input the result
        [selectedDistance, selectedAngle, selectedRealism] = showLocalizationPlot();

        % Save new result data
        resultData = sprintf('%s%.3d    %+.3d\t%+3.1f\t%+3.1f\t%+3.1f\n', resultData, i, currentAngle, selectedDistance, selectedAngle, selectedRealism);
    end

    % Save results to text file
    disp('>> Saving results to text file ...');
    saveResultsToFile(resultData);

    % Show a message of goodbye
    showGoodbye();
    disp('>> Test finished!');
end

function showGoodbye()

    % Show finishing message
    dialogHandler = dialog('Position',[500 300 350 150], 'Name','Surround-to-headphones test');
    uicontrol('Parent',dialogHandler,...
               'Style','text',...
               'FontSize', 15, ...
               'Position',[25 70 300 60],...
               'String','Test completed. Thanks for your time!');
    uicontrol('Parent',dialogHandler,...
               'Position',[140 20 70 25],...
               'String','Finish',...
               'FontSize', 13, ...
               'Callback','delete(gcf)');
end

function saveResultsToFile(resultData)
    %% Shows a save dialog to the user and saves the result data as text.

    % Asks the user for the output filename and path
    [filename, path] = uiputfile('results.txt', ...
                                 'Save results to a text file ...');    

    % Returns if the user cancelled
    if ~filename
        return
    end
    
    % Opens the file with its path
    full_path = strcat(path, filename);
    fileDescriptor = fopen(full_path, 'w');

    % Prints all data and closes file
    fprintf(fileDescriptor,'%s', resultData);
    fclose(fileDescriptor);

end

function playAudio(inputAudio)

    playerHandler = audioplayer(inputAudio, 44100);
    play(playerHandler);
    pause
    % playblocking(playerHandler);

end

function outputSound = convolveSound(inputAudio, degree)

    % This table contains the measured differences of level received on the
    % dummy head. The impulse responses were normalized to make an optimum use
    % of the dynamic range of the wav file (16 bits). Therefore, they have to
    % be scaled afterwards to include the attenuation effect between ears.
    % 
    %                         close         far       difference
    % side (30 degrees):   -15.90 dBV    -25.37 dBV     9.47 dB
    % side (45 degrees):   -15.35 dBV    -27.83 dBV    12.48 dB
    % side (72 degrees):   -15.46 dBV    -29.24 dBV    13.78 dB
    % side (110 degrees):  -16.90 dBV    -29.84 dBV    12.94 dB
    % side (144 degrees):  -20.93 dBV    -27.98 dBV     7.05 dB
    % side (170 degrees):  -22.57 dBV    -24.99 dBV     2.42 dB

    switch abs(degree)
        case {0}
            % Load IRs front
            left_IR = audioread('trimmed_ir/front_left_IR.wav');
            right_IR = audioread('trimmed_ir/front_right_IR.wav');
            attenuation_db = 0;

        case {30}
            % Load IRs 30 degrees
            left_IR = audioread('trimmed_ir/close_30_IR.wav');
            right_IR = audioread('trimmed_ir/far_30_IR.wav');
            attenuation_db = 9.47;

        case {45}
            % Load IRs 45 degrees
            left_IR = audioread('trimmed_ir/close_45_IR.wav');
            right_IR = audioread('trimmed_ir/far_45_IR.wav');
            attenuation_db = 12.48;

        case {72}
            % Load IRs 72 degrees
            left_IR = audioread('trimmed_ir/close_72_IR.wav');
            right_IR = audioread('trimmed_ir/far_72_IR.wav');
            attenuation_db = 13.78;

        case {110}
            % Load IRs 110 degrees
            left_IR = audioread('trimmed_ir/close_110_IR.wav');
            right_IR = audioread('trimmed_ir/far_110_IR.wav');
            attenuation_db = 12.94;

        case {144}
            % Load IRs 144 degrees
            left_IR = audioread('trimmed_ir/close_144_IR.wav');
            right_IR = audioread('trimmed_ir/far_144_IR.wav');
            attenuation_db = 7.05;

        case {170}
            % Load IRs 170 degrees
            left_IR = audioread('trimmed_ir/close_170_IR.wav');
            right_IR = audioread('trimmed_ir/far_170_IR.wav');
            attenuation_db = 2.42;

        otherwise
        disp('ERROR: invalid angle!');
        return
    end

    % Obtains the output data from the convolution with the IRs
    leftChannel = conv(left_IR, inputAudio);
    rightChannel = conv(right_IR, inputAudio) * 10^(-attenuation_db/20);

    % Normalizes the output audio to -1 dBFS
    normalizationValue = max(max(leftChannel), max(rightChannel));
    leftChannel = leftChannel / normalizationValue * 10^(-1/20);
    rightChannel = rightChannel / normalizationValue * 10^(-1/20);

    % Invert the output channels if the angle is negative
    if degree > 0
        outputSound = [leftChannel, rightChannel];
    else
        outputSound = [rightChannel, leftChannel];
    end
end

function presentIntro()

    % Show splash
    introText = sprintf('In this experiment, a series of sounds will be presented. After each presentation, you will be asked to point where the sound was coming from, for example: in front of you, to your left, behind you ... etc.\n\nYou will also be asked to rate the perception of realism, understood that a very realistic presentation is such that perfectly resembles being in a room with a surround setup instead of using headphones.');

    dialogHandler = dialog('Position',[500 300 350 150], 'Name','Surround-to-headphones test');
    uicontrol('Parent',dialogHandler,...
               'Style','text',...
               'FontSize', 15, ...
               'Position',[25 70 300 60],...
               'String','The following test will last a few minutes. Before starting you will receive some instructions.');
    uicontrol('Parent',dialogHandler,...
               'Position',[140 20 70 25],...
               'String','Okay',...
               'FontSize', 13, ...
               'Callback','delete(gcf)');
    waitfor(dialogHandler);

    % Show explanation and play audio
    [presentationAudio, samplFreq] = audioread('audio_signals/experiment_presentation.wav');
    playerHandler = audioplayer(presentationAudio, samplFreq);
    play(playerHandler);
    dialogHandler = dialog('Position',[450 250 450 350], 'Name','Surround-to-headphones test');
    uicontrol('Parent',dialogHandler,...
               'Style','text',...
               'FontSize', 15, ...
               'Position',[25 100 400 200],...
               'String', introText);
    uicontrol('Parent',dialogHandler,...
               'Position',[190 20 70 25],...
               'String','Okay',...
               'FontSize', 13, ...
               'Callback','delete(gcf)');

    % Wait for the user to close the window / click button
    waitfor(dialogHandler);
    stop(playerHandler);

end

function [distance, angle, slider] = showLocalizationPlot()

    backColor = [.82 .81 .8];
    windowTitle = 'Stereo perception test - AAT9 2015.';
    position = [-1, -1];
    slider = 50;
    positionAlreadySelected = false;

    % Loads the background image from file
    img = imread('plot_background.png');

    % Creates the figure with the desired size, centered on screen
    hFig = figure('Color', backColor);
    set(hFig,'Name', windowTitle, 'NumberTitle','off')
    hold on;
    set(hFig, 'Position', [0 0 520 650])
    movegui(hFig, 'north')

    % Callback for the click
    set(hFig,'windowbuttondownfcn',@fhbdfcn)

    % Removes the toolbar and the menu bar
    set(hFig, 'MenuBar', 'none');
    set(hFig, 'ToolBar', 'none');
    set(gca,'xtick',[],'ytick',[])

    % Sets the canvas position
    set(gca,'Position',[0.05 0.2 0.9 0.7])

    % Displays the background image
    image([-300 300], [300 -300], img);
    axis([-300 300 -300 300])

    % Sets the title to the plot
    title('Click where the source was perceived', ...
          'FontSize', 16, 'FontWeight', 'normal');

    % -- Internal callbacks --

    function [] = fhbdfcn(h, ~)

        % Gets the position coordinates
        positionCoordinates = get(gca, 'currentpoint');
        positionCoordinates = [positionCoordinates(1, 1) 
                               positionCoordinates(1, 2)];

        if ~positionAlreadySelected

            % Checks that the click is within the boundaries
            if positionCoordinates(1) > 300 || positionCoordinates(1) < -300
                return
            end
            if positionCoordinates(2) > 300 || positionCoordinates(2) < -300
                return
            end

            % Displays a mark on the selected point
            plot([positionCoordinates(1)], [positionCoordinates(2)], ...
                 'x', 'MarkerSize', 30, 'LineWidth', 3);

            % Saves the selected position
            position = positionCoordinates;

            % Adds slider for the perceived realism
            hsl = uicontrol('Style','slider','Min',1,'Max', 100,...
                            'SliderStep',[1 1]./100,'Value', 52,...
                            'Position',[130 50 250 20]);

            % Wires callback for the slider
            set(hsl, 'Callback', @callbackSlider)

            % Adds boton to continue
            uicontrol('Style', 'pushbutton', 'String', 'Continue',...
                'Position', [220 10 70 30],...
                'Callback', 'close');

            % Adds label for 'Perceived realism'
            uicontrol('Style','text',...
                'Position',[160 80 200 20],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String','Perceived realism valoration:');

            % Adds label for 'very fake'
            uicontrol('Style','text',...
                'Position',[80 30 40 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nfake'));

            % Adds label for 'very realistic'
            uicontrol('Style','text',...
                'Position',[390 30 70 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nrealistic'));

            % Removes the title
            title('');

            % Flag of 'position already selected'
            positionAlreadySelected = true;
        end
    end

    % Internal function for the slider callback
    function callbackSlider(hObject, evt)
        slider = get(hObject, 'Value');
    end

    % Waits until the window is closed
    waitfor(hFig);

    % Calculates the returned distance and angle
    distance = sqrt(position(1)^2 + position(2)^2);
    angle = atan2(position(2), position(1)) / pi * 180;

    % Corrects the angle to match the initial criteria
    if angle >= -90 && angle <= 180
        angle = angle - 90;
    else
        angle = angle + 270;
    end    
end
