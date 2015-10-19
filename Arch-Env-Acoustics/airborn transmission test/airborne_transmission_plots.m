
%% 0 - Global data

room_length = 5.73;
room_width = 3.55;
room_height = 3.05;

outside_width = 2.59;
outside_length = 6.30;
outside_height = 3.00;

separation_wall_width = 3.55;
separation_wall_height = 3.05;

door_width = 1.04;
door_height = 2.07;


%% 1 - Input data

% 1.1 - General data
frequency_bands = [50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000];

% 1.2 - Background noise
noise_inside_room_1 = [38.1 37.2 27.9 42.8 28.2 35.0 28.6 26.3 24.3 25.1 20.9 17.7 15.5 16.1 14.4 14.9 14.2 13.0 12.7 12.7 13.1];
noise_inside_room_2 = [45.1 33.2 30.3 35.1 30.0 34.8 30.6 25.0 25.2 22.5 18.0 16.5 17.4 16.9 13.5 14.8 13.4 13.5 12.3 12.1 12.7];
noise_inside_average = 20 * log10((10.^(noise_inside_room_1/20) + 10.^(noise_inside_room_2/20) ) / 2);

noise_outside_1 = [49.4 39.9 39.5 44.2 36.8 28.1 27.3 26.7 26.7 23.0 21.4 22.4 20.5 20.5 21.0 23.4 21.0 22.1 21.3 16.3 15.1];
noise_outside_2 = [52.0 40.7 38.4 41.9 35.0 31.1 29.6 28.3 25.9 21.1 20.1 20.3 19.2 20.8 22.0 23.3 21.5 23.4 22.4 17.5 17.0];
noise_outside_average = 20 * log10((10.^(noise_outside_1/20) + 10.^(noise_outside_2/20) ) / 2);

% 1.3 - Reverb time

% Note: this one is missing the first band (50Hz)
reverb_outside_average = [0.9 0.9 0.7 0.7 0.6 0.8 0.6 0.8 0.7 0.6 0.6 0.5 0.5 0.6 0.6 0.5 0.6 0.5 0.5 0.5];

reverb_inside_average =  [1.4 1.0 1.3 1.2 0.8 1.0 0.6 0.4 0.3 0.3 0.3 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.3 0.3 0.3];

% 1.4 - Noise transmission
out_to_in_outside = [79.0 77.2 75.6 72.8 75.1 75.0 71.5 70.0 66.2 70.0 71.1 71.9 71.6 70.0 69.8 67.8 66.4 68.1 68.2 67.6 68.2];
out_to_in_inside = [52.5 51.8 53.3 51.1 47.4 48.3 40.2 37.9 34.2 37.4 37.3 36.7 35.4 33.7 30.7 28.9 27.7 29.0 29.0 28.6 29.1];

in_to_out_inside = [73.1 77.7 73.9 78.7 75.8 75.3 74.4 74.0 69.1 69.4 68.2 64.3 68.9 66.0 65.1 65.2 64.7 64.7 64.8 64.1 64.9];
in_to_out_outside = [57.4 57.2 53.7 51.6 54.6 52.2 49.0 48.8 45.5 44.6 43.2 39.5 41.5 38.0 37.0 35.9 36.0 37.7 36.4 34.9 34.5];


%% 2 - Plots

% 2.1 - Background noise

subplot(2,1,1);
semilogx(frequency_bands, noise_inside_room_1, 'g');
hold on
semilogx(frequency_bands, noise_inside_room_2, 'r');
semilogx(frequency_bands, noise_inside_average, 'b');
grid
xlim([40 6000]);
ylim([10 55]);
legend({'Inside mic 1', 'Inside mic 2', 'Average'});
xlabel('Frequency [Hz]');
ylabel('SPL [dB]');
title('Background noise inside the room');

subplot(2,1,2);
semilogx(frequency_bands, noise_outside_1, 'g');
hold on
semilogx(frequency_bands, noise_outside_2, 'r');
semilogx(frequency_bands, noise_outside_average, 'b');
grid
xlim([40 6000]);
ylim([10 55]);
legend({'Outside mic 1', 'Outside mic 2', 'Average'});
xlabel('Frequency [Hz]');
ylabel('SPL [dB]');
title('Background noise outside the room');

pause
close all

fig = figure();
semilogx(frequency_bands, noise_inside_average, 'b');
hold on
semilogx(frequency_bands, noise_outside_average, 'r');
grid
xlim([40 6000]);
ylim([10 55]);
legend({'Average inside', 'Average outside'});
xlabel('Frequency [Hz]');
ylabel('SPL [dB]');
title('Background noise comparison');
print(fig,'-dpdf','background_noise_comparison.pdf');

pause
close all

% 2.2 - Reverb time

fig = figure();
semilogx(frequency_bands, reverb_inside_average, 'b');
hold on
semilogx(frequency_bands(2:length(frequency_bands)), reverb_outside_average, 'r');
grid
xlim([40 6000]);
ylim([0.1 1.5]);
legend({'Inside (AVG)', 'Outside (AVG)'});
xlabel('Frequency [Hz]');
ylabel('Reverb time [s]');
title('Reverb time comparison');
print(fig,'-dpdf','reverb_time_comparison.pdf');

pause
close all

% 2.3 - Airborne transmission (out to in)

fig = figure();
subplot(2,1,1);
semilogx(frequency_bands, out_to_in_outside, 'r');
hold on
semilogx(frequency_bands, out_to_in_inside, 'b');
legend({'Transmitted level', 'Received level'}, 'Location', 'southwest');
xlabel('Frequency [Hz]');
ylabel('SPL [dB]');
title('Airborne noise transmission levels comparison (out-to-in)');
grid
xlim([40 6000]);
ylim([25 80]);

subplot(2,1,2);
semilogx(frequency_bands, out_to_in_outside - out_to_in_inside);
legend({'Level difference'}, 'Location', 'southeast');
xlabel('Frequency [Hz]');
ylabel('SPL difference [dB]');
title('Airborne noise level reduction (out-to-in)');
grid
xlim([40 6000]);
ylim([20 40]);
print(fig,'-dpdf','airborne_transmission_incoming.pdf')

pause
close all

% 2.4 - Airborne transmission (in to out)

fig = figure();
subplot(2,1,1);
semilogx(frequency_bands, in_to_out_outside, 'r');
hold on
semilogx(frequency_bands, in_to_out_inside, 'b');
legend({'Received level', 'Transmitted level'}, 'Location', 'southwest');
xlabel('Frequency [Hz]');
ylabel('SPL [dB]');
title('Airborne noise transmission levels comparison (in-to-out)');
grid
xlim([40 6000]);
ylim([30 80]);

subplot(2,1,2);
semilogx(frequency_bands, in_to_out_inside - in_to_out_outside);
legend({'Level difference'}, 'Location', 'southeast');
xlabel('Frequency [Hz]');
ylabel('SPL difference [dB]');
title('Airborne noise level reduction (in-to-out)');
grid
xlim([40 6000]);
ylim([15 35]);
print(fig,'-dpdf','airborne_transmission_outcoming.pdf')

pause
close all

% 2.5 - Airborn transmission comparision

fig = figure();
semilogx(frequency_bands, in_to_out_inside - in_to_out_outside, 'b');
hold on
semilogx(frequency_bands, out_to_in_outside - out_to_in_inside, 'r');
legend({'In to out', 'Out to in'}, 'Location', 'southeast');
xlabel('Frequency [Hz]');
ylabel('SPL difference [dB]');
title('Airborne noise level reduction (comparision of ways)');
grid
xlim([40 6000]);
ylim([15 40]);
print(fig,'-dpdf','test.pdf')
print(fig,'-dpdf','airborne_transmission_comparision_ways.pdf')

pause
close all
disp('Done!');
