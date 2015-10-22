function mini_project_adaptive_filtering()

    clc
    disp(sprintf('Array sensor signal processing - AAU 2015\n    Adaptative filtering miniproject\n         Group 960 - Acoustics\n\n\n [ Previous steps ]\n'));

    % Simulation parameters
    beta = 0.4;
    filterLength = 4000;
    epsilon = 0.001;

    % ---- Load input audios ----
    peterSpeech = getPeterSpeech();
    karenSpeech = getKarenSpeech();

    % ---- Process signals ----

    % 1 - Karen through the speaker
    karenAfterSpeaker = speakerResponse(karenSpeech);

    % 2 - Peter and Karen reverberating on the car
    summedSignals = (karenAfterSpeaker * 10^(-12/20)) + peterSpeech;
    summedSignals = summedSignals / max(abs(summedSignals));
    reverberatingVoices = reverbCar(summedSignals);

    % 3 - Microphone response of all ambient signal on the car
    micCaptured = micResponse(reverberatingVoices);

    % 4 - Additive noise produced by the whole system
    accumulatedSignal = additiveNoise(micCaptured);

    disp(sprintf('\n [ Adaptative filtering ]\n'));

    differences = zeros(2, 4);
    columns = {'beta', 'filterLength', 'epsilon', 'error'};
    counter = 1;
    % ---- Adaptive filtering ----
    for filterLength = [100 200 300 400 500 600 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 20000 30000 40000]
        for beta = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]
            for epsilon = [0.0001 0.0005 0.001 0.005 0.01 0.05 0.1 0.5 1 2 5]
                outputAudioNLMS = nlms(karenSpeech, accumulatedSignal, beta, filterLength, epsilon);

                % Compute the difference
                differences(counter, :) = [beta, filterLength, epsilon, norm(outputAudioNLMS - accumulatedSignal)];
                counter = counter + 1;

                % Save results to file
                save('savedResults_nlms.mat', 'columns', 'differences');
                disp(sprintf('Iteration #%d', counter));
            end
        end
    end

    % ---- Saving processed audio data ----
    audiowrite('output_audio.wav', outputAudioNLMS, 44100);
    playAudios([accumulatedSignal, outputAudioNLMS]);


    subplot(2,1,1)
    plot(accumulatedSignal)
    title('Mic signal')
    subplot(2,1,2)
    plot(outputAudioNLMS)
    title('Output')

end

function plotAudios(audios)

    for i = 1 : size(audios, 2)
        subplot(size(audios, 2), 1, i);
        plot(audios(:,i));
        title(sprintf('Audio #%d', i));
    end

end

function playAudios(audios)

    for i = 1 : size(audios, 2)
        disp(sprintf('[PLAYER] Playing audio %d ...  [Press any key to continue]', i));
        playerHandler = audioplayer(audios(:, i), 44100);
        play(playerHandler)
        pause
        stop(playerHandler)
    end
end

function outputData = nlms(inputAudio, processedAudio, beta, filterLength, epsilon)

%     % Filter design
%     filterLength = 2000;
%     % Step size parameter (0 < beta < 2)
%     beta = 0.4;
%     % Regularization parameter
%     epsilon = 0.001;

    % Output data
    outputData = zeros(size(inputAudio));
    lastFilter = zeros(filterLength, 1);

    for i = 2 : length(inputAudio) - filterLength;

        % Current input segment
        currentInput = inputAudio(i : i + filterLength - 1);

        % Produces the new output sample from the filter
        filterOutput = sum( (currentInput) .* (lastFilter) );

        % Generate the new output sample
        outputData(i) = -filterOutput + processedAudio(i-1);

        % Updates the step size
        stepSize = (beta / (epsilon + norm(currentInput)^2));

        % Updates the filter coeficients
        lastFilter = lastFilter + (stepSize * currentInput * outputData(i));

%         clc
%         disp(strcat('Current input: [', strtrim(sprintf('%d ', currentInput)), ']'));
%         disp(sprintf('Output data: %.2f', outputData(i)));
%         disp(sprintf('Processed audio: %.2f', processedAudio(i)));
%         disp(sprintf('Filter output: %.2f', filterOutput));
%         disp(sprintf('Step size: %.2f', stepSize));
%         disp(strcat('Last filter: [',strtrim(sprintf('%d ', lastFilter)), ']'));
%         pause

    end
    outputData = outputData / max(abs(outputData));

end

function output = upsampleAudio(inputAudio, inputSampleRate, outputSampleRate)

    disp('> Upsampling audio to 44.1 kHz.');

    % Inserts zeros
    withZeros = upsample(inputAudio, (outputSampleRate/inputSampleRate));

    % Low pass filters to eliminate replicas (this combination of cut
    % frequency and filter order seems to produce a very similar sounding
    % output)
    cutFreq = 0.23;
    [B,A] = butter(20, cutFreq);
    filtered = filter(B, A, withZeros);

    % Normalizes amplitude to match the input signal
    upsampledAudio = filtered / max(abs(filtered)) * max(abs(inputAudio));
    
    output = upsampledAudio;

end

function [output, sampleRate] = getPeterSpeech()

    disp('> Loading Peter`s speech.');

    audioPositionPercentage = 25;
    sampleRate = 44100;

    % Reads the input wav file
    [peterSpeech, inputSampleRate] = audioread('input_audios/houston_problem.wav');

    % Keeps only the first channel
    peterSpeech = peterSpeech(:, 1);

    % Normalizes the sampling frequency to 44.1 kHz
    peterSpeech = upsampleAudio(peterSpeech, inputSampleRate, sampleRate);

    % Normalizes the amplitude
    peterSpeech = peterSpeech / max(abs(peterSpeech));

    % Padds the signal with zeros at the beginning and ending to match the
    % length of Karen's speech
    firstPart = round(audioPositionPercentage * 441234 / 100);
    secondPart = 441234 - firstPart - length(peterSpeech);

    output = [zeros(firstPart, 1); peterSpeech; zeros(secondPart, 1); ];

end

function [output, sampleRate] = getKarenSpeech()

    disp('> Loading Karen`s speech.');

    [karenSpeech, sampleRate] = audioread('input_audios/speech_org.wav');

    % Normalizes the amplitude
    karenSpeech = karenSpeech / max(abs(karenSpeech));

    output = karenSpeech;

end

function output = speakerResponse(input)

%     output = input;
%     return

    disp('> Convolving with speaker response.');

    % Speaker response from a Celestion GM12 captured with a AKG C414
    % http://www.redwirez.com/free1960g12m25s.jsp
    % 
    % TODO: use the response of a typical cheap loudspeaker for a car
    % instead

    speakerIR = audioread('impulse_responses/Marshall1960A-G12Ms-C414-Cap-0in.wav');

    % Trims impulse response to the first 1500 samples
    speakerIR = speakerIR(1:1500);

    convolvedAudio = conv(input, speakerIR);

    % Normalizes amplitude to match input
    convolvedAudio = convolvedAudio / max(abs(convolvedAudio)) * max(abs(input));

    % Trims signal to match length of input
    output = convolvedAudio(1:length(input));

end

function output = reverbCar(inputAudio)

%     output = inputAudio;
%     return

    disp('> Generating reverberation of the car.');

    sampleRate = 44100;

    % Uses the Schroeder reverb function
    audioWithReverb = schroeder_reverb(inputAudio, sampleRate, 0.3, 1000, 0, 1, 'lp', length(inputAudio));

    % Description of input parameters:
    % 
    % x:         input signal
    % fs:        sampling frequency
    % Tr: 0.3    reverberatation time
    % fc: 1000   lp-filter corner frequency
    % m0: 0      pre-delay length
    % g:  1      reverberation level
    % type:      either 'plain' or 'lp' where lp refers to low-pass
    % y_length:  desired length of output signal
    % y:         output signal with length y_length

    % Compensates amplitude to match the input signal
    withReverb = audioWithReverb / max(abs(audioWithReverb)) * max(abs(inputAudio));

    % Normalizes amplitude to match input
    withReverb = withReverb / max(abs(withReverb)) * max(abs(inputAudio));

    % Trims signal to match length of input
    output = withReverb(1:length(inputAudio));
end

function output = micResponse(input)

%     output = input;
%     return

    disp('> Convolving with mic response.');

    % Mic response corresponds to an old Sony condenser:
    % http://micirp.blogspot.dk/2013/11/sony-c37fet.html

    % TODO: Try to find the IR of a cheap electrec mic, which will be
    % the typically used for this application.

    micIR = audioread('impulse_responses/Sony_C37Fet.wav');

    % Trims mic impulse response
    micIR = micIR(1:600);

    convolvedAudio = conv(input, micIR);

    % Normalizes amplitude to match the input
    convolvedAudio = convolvedAudio / max(abs(convolvedAudio)) * max(abs(input));

    % Trims the audio to match the input length
    output = convolvedAudio(1:length(input));
end

function output = additiveNoise(input)

%     output = input;
%     return

    disp('> Adding white noise.');

    desiredSNR = 30;

    % Generates white noise (mean=0, var=1) and adjusts its amplitude
    % according to the requirements of SNR
    rng(0);
    noise = randn(size(input)) * (rms(input) / 10^(desiredSNR/20));

%     % Noise from the recording
%     noise = audioread('input_audios/inside_car.wav');
%     noise = noise(600000 : 600000 + length(input) -1);
%     noise = noise /rms(noise) * (rms(input) / 10^(desiredSNR/20));

    % Mixes the input signal with the noise
    noisyAudio = input + noise;

    % Normalizes amplitude to match input
    output = noisyAudio / max(abs(noisyAudio)) * max(abs(input));
end
