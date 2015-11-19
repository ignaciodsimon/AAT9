function [phase_delay, rough_delay] = groupDelayEstimation(time_signal, fs, c, start, stop)
%% Estimates the group delay of a given time signal.


%start = 1000;
%stop = 1200;
% c = 340;
% d1 = 4.99;
% d2 = 1.672;
% farResponse1_real_delay = d1/c; %0.0146764
% farResponse2_real_delay = d2/c; %0.0049176

time_signal = veryShortTrim(time_signal);

%-----First the rought estimate
[~, delay_samples] = max(time_signal);
rough_delay = delay_samples/fs;

%----Now try with phase delay

%First perform fft:
frequency_domain_signal = fft(time_signal,fs);
x = 1:length(frequency_domain_signal);

%Now extract phase of the signal in radians(unwrapped):
phase_of_fft = unwrap(angle((frequency_domain_signal)));

%convert phase to degrees:
% phase_of_fft = phase_of_fft.* 180 / pi;

%Plot to check if selected region can be considered linear:
% figure(1)
% plot(phase_of_fft)
% hold on
% plot(start,phase_of_fft(start),'x', 'MarkerSize', 8)
% hold on
% plot(stop,phase_of_fft(stop),'x', 'MarkerSize', 8)

%Calculate the slope from start to stop:
% dy = diff(phase_of_fft(start:stop))./diff(x(start:stop));
dy = x(start:stop)'\phase_of_fft(start:stop)';



% delay = sum(dy)/length(dy);
phase_delay = sum(dy)/length(dy)/(2*pi);
% phase_delay = dy(length(dy))/(2*pi);
%error with rough estimation
% error_rough = abs(rough_delay - d2/c);
phase_dist = abs(phase_delay*c);
rough_dist = abs(rough_delay*c);



% disp(['Rough estimate based on maximum value is:                         ', num2str(rough_delay), ' [s] -> ', num2str(rough_dist), ' [m]']);
disp(['Estimated group delay based on low frequency phase:               ', num2str(abs(phase_delay)), ' [s] -> ', num2str(phase_dist), ' [m]']);
% disp(['Delay based on measured length for farResponse1: ', num2str(farResponse1_real_delay), ' [s]']);
% disp(['Delay based on measured length for farResponse2: ', num2str(farResponse2_real_delay), ' [s]']);
% disp(['The absolute error between derived and rough estimated delay is : ', num2str(error_rough) ' [s]'])

phase_delay = abs(phase_delay-1/fs);
rough_delay = abs(rough_delay);

% scale_factor1 = abs(delay) / farResponse1_real_delay

% rescaled_delay = abs(delay)/ 6.27901832229296;%scale_factor1;
% disp(['Estimated group delay WITH SCALE FACTOR: ', num2str(abs(rescaled_delay)), ' [s]']);



end