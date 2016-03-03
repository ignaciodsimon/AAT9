
h = figure();
[peter_speech_audio, sampleRate] = audioread('../accumulated_signal_audio.wav');
% [peter_speech_audio, sampleRate] = audioread('../peter_speech_audio.wav');

outputSignal_nothing = audioread('../output_audio_nothing.wav');
outputSignal_mic_speaker = audioread('../output_audio_mic_speaker.wav');
outputSignal_mic_speaker_white = audioread('../output_audio_mic_speaker_white.wav');
outputSignal_mic_speaker_white_reverb = audioread('../output_audio_mic_speaker_white_reverb.wav');
outputSignal_mic_speaker_real_noise_reverb = audioread('../output_audio_mic_speaker_real_noise_reverb.wav');

timeAxis = [1:length(outputSignal_nothing)] / sampleRate;

hold on
plot(timeAxis, peter_speech_audio + 1, 'LineWidth', 2)
plot(timeAxis, outputSignal_nothing + 0.6, 'LineWidth', 2)
plot(timeAxis, outputSignal_mic_speaker + 0.2, 'LineWidth', 2)
plot(timeAxis, outputSignal_mic_speaker_white - 0.2, 'LineWidth', 2)
plot(timeAxis, outputSignal_mic_speaker_white_reverb - 0.6, 'LineWidth', 2)
plot(timeAxis, outputSignal_mic_speaker_real_noise_reverb - 1, 'LineWidth', 2)

grid
xlim([0 max(timeAxis)])
ylim([-1.4 1.5])
ylabel('Amplitude [.]')
xlabel('Time [s]')
title('Output audio waveform comparison');
legend({'Outcome without filter', 'Filtered (only voices)', 'Filtered (mic + speaker)', 'Filtered (mic + speaker + white noise)', 'Filtered (mic + speaker + white noise + reverb)', 'Filtered (mic + speaker + real noise + reverb)'})


set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h, 'output_audio_comparison_2.pdf','-dpdf','-r0')



