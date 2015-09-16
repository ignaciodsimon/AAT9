%% -- FREQUENCY DISCRIMINATING TEST --
%
%    This programs tries to estimate the user's ability to discern between
%    two pure tones of close frequency.
%
%    Joe.
%

function frequency_discriminating_test()
    %% Enter point to the program

    % Test parameters
    BASE_FREQUENCY = 1000;
    FREQ_MARGIN = 10;
    AMOUNT_REVERSALS = 8;
    NECESARY_AMOUNT_RIGHT_ANSWERS = 2;

    splash_answer = questdlg(sprintf('Instructions:\n\nTwo tones will be presented each time. The task is to discriminate which one has a higher pitch.\n\nReady?'),'Frequency discrimination test','Go!', 'Go!');
    if strcmp(splash_answer, '')
        return
    end

    % Asks the user for the test parameters
    prompt = {'Base frequency [Hz]:','Initial freq. delta [Hz]:', 'Amount of reversals:', 'Required amount of hits:'};
    dlg_title = 'Test configuration';
    num_lines = 1;
    defaultans = {sprintf('%.1f', BASE_FREQUENCY), sprintf('%.1f', FREQ_MARGIN), sprintf('%d', AMOUNT_REVERSALS), sprintf('%d', NECESARY_AMOUNT_RIGHT_ANSWERS)};
    answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
    BASE_FREQUENCY = str2num(answer{1});
    FREQ_MARGIN = str2num(answer{2});
    AMOUNT_REVERSALS = round(str2num(answer{3}));
    NECESARY_AMOUNT_RIGHT_ANSWERS = round(str2num(answer{4}));

    results_var = initializeResultData();
    amount_of_success = 0;
    results_list = [];
    freq_margin_list = [];
    counted_reversals = 0;
    reversal_frequencies = [];

    % First time use the maximum freq span and assume the hit
    shift_frequency = BASE_FREQUENCY + FREQ_MARGIN;
    current_direction = 'down';

    while true

        % Saves the new frequency for the list
        freq_margin_list(length(freq_margin_list) + 1) = FREQ_MARGIN;

        % Finishes when the desired amount of reversals have been reached
        if counted_reversals >= AMOUNT_REVERSALS

            % Removes the last frequency since it was not actually tested
            freq_margin_list = freq_margin_list(1 : length(freq_margin_list) - 1);

            % Finishes the test
            break
        end

        % Play both randomly selected
        if rand() > 0.5
            playTone(BASE_FREQUENCY);
            playTone(shift_frequency);
            high_tone_first = false;
        else
            playTone(shift_frequency);
            playTone(BASE_FREQUENCY);
            high_tone_first = true;
        end

        % Ask user and get answer
        user_answer = questdlg('Which sound had a higher pitch?', ...
            'Frequency discrimination test','First','Second', 'First');

        % Cancel the test if the window is closed
        if strcmp(user_answer, '')
            questdlg('Test cancelled!', 'Frequency discrimination test', ...
                'Okay', 'Okay');
            return
        end

        % Calculates the new shifted frequency, depending on the answer
        if (strcmp(user_answer,'First') && high_tone_first) || ...
           (strcmp(user_answer, 'Second') && ~high_tone_first)
            % Saves the new result
            results_var = addNewResultToOutput(results_var, BASE_FREQUENCY, ...
                                       shift_frequency, true);

            % Answer was correct last two times, reduce freq margin
            amount_of_success = amount_of_success + 1;
            if amount_of_success == NECESARY_AMOUNT_RIGHT_ANSWERS

                % Checks if there has been a reversal in the direction
                if strcmp(current_direction, 'up')
                    counted_reversals = counted_reversals + 1;
                    reversal_frequencies(length(reversal_frequencies) + 1) = FREQ_MARGIN;
                end

                FREQ_MARGIN = FREQ_MARGIN / 2;
                amount_of_success = 0;

                % Saves the state
                current_direction = 'down';
            end

            % Save the result for the list
            results_list(length(results_list) + 1) = 1;

        else
            % Saves the new result
            results_var = addNewResultToOutput(results_var, BASE_FREQUENCY, ...
                                       shift_frequency, false);

            % Checks if there has been a reversal in the direction
            if strcmp(current_direction, 'down')
                counted_reversals = counted_reversals + 1;
                reversal_frequencies(length(reversal_frequencies) + 1) = FREQ_MARGIN;
            end
            current_direction = 'up';

            % Answer was incorrect, find next frequency
            FREQ_MARGIN = FREQ_MARGIN * 2;
            amount_of_success = 0;

            % Save the result for the list
            results_list(length(results_list) + 1) = 0;
        end

        % Next frequency span
        shift_frequency = BASE_FREQUENCY + FREQ_MARGIN;

    end

    % Saves the final result to the output text
    obtained_precision = sum(reversal_frequencies) / length(reversal_frequencies);
    results_var = addFinalResultToOutput(results_var, obtained_precision);

    % Saves the results to a text file
    saveResultsToFile(results_var);

    questdlg('Test finished and results saved!','Frequency discrimination test','Alright!', 'Alright!');

    % Shows the plot with the results of the experiment
    plot(freq_margin_list, 'x-'); hold on; plot(results_list, 'ro-');
    xlabel('Test number');
    ylabel('Frequency delta [Hz]');
    title(sprintf('Final result: %.3f [Hz]', obtained_precision));
    grid();
    
    % Gets name for saving plot
    filename = inputdlg('Enter filename to save plot:',...
             'Save plot', [1 50]);
    filename = filename{1};

    % Saves plot to PDF
    set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
    set(gcf, 'PaperSize', [8.1 3.1]);
    saveas(gcf, filename, 'pdf');


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

function resultDataVar = initializeResultData()
    %% Returns the text header that will be saved in the results file.

    resultDataVar = sprintf(...
        '== Pitch test report ==\n\nTest performed on:\n%s \n\nFreq-1\tFreq-2\tResult\n----------------------\n', ...
        datestr(clock,'HH:MM:SS - dd/mm/yyyy'));

end

function returnedText = addFinalResultToOutput(resultDataVar, finalResult)

    returnedText = sprintf('%s\nFinal result %.3f [Hz]\n', resultDataVar, finalResult);

end


function returnedText = addNewResultToOutput(resultDataVar, firstFrequency, ...
                                     secondFrequency, testResult)
    %% Adds the new data with format to the existing results and returns it.

    returnedText = sprintf('%s%.2f\t%.2f\t%d\n', resultDataVar, ...
                           firstFrequency, secondFrequency, testResult);

end

function playTone(frequency)
    %% Generates and plays a pure tone for one second.

    % Constants definitions
    SAMPLING_FREQ = 44100;
    SIGNAL_LENGTH = 1;

    % Generates a signal and plays it back
    signal = generateTone(frequency, SIGNAL_LENGTH * SAMPLING_FREQ, ...
                          SAMPLING_FREQ);
    playSignal(signal, SAMPLING_FREQ);

end

function playSignal(signal, samplingFreq)
    %% Reproduces a signal through the default audio interface.

    % Plays back the signal on blocking mode
    playerHandler = audioplayer(signal, samplingFreq);
    playblocking(playerHandler);

end

function generated_signal = generateTone(frequency, length, samplingFreq)
    %% Generates a sinus signal of a given frequency, length and sampling
    % frequency.

    generated_signal = sin(2*pi()*frequency * [0:1:length] / samplingFreq);

end
