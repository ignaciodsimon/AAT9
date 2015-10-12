% Architectural and Environmental Acoustics.
% Exercise from October 12th, 2015.
%
% Joe.


% Panel characteristics:
volume_density = 2300;
speed_sound_panel = 3400;
thickness = 0.1;
% Constants
c = 343;


% 1 - Critical frequency
fc = c^2 / (1.8 * thickness * speed_sound_panel);
disp(sprintf('Critical frequency: %.1f [Hz].', fc));


% 2 - field incidence sound reduction index (Rfield)
frequency = 250;
rho_c = 414;
a = (2*pi*frequency * volume_density * thickness) / (2 * rho_c);
angles = 78;
r_field = 20*log10(a) - 10*log10(log(1+a^2) - log(1 + a^2 * cos(angles/180 * pi)));
disp(sprintf('R_field: %.2f', r_field));


% 3 - Coincidence angle as a function of the frequency:
f = [1:1000];
B = 2000000;
c_air = ones(1, length(f)) * c;
c_panel = (( (2*pi*f).^2  * B) / (volume_density * thickness)).^(1/4);
coincidence_angles = abs(asin(c_air ./ c_panel)) /pi * 180;
x_axis_values = f / fc;
plot(x_axis_values, coincidence_angles);
ylim([0 120]);
xlim([min(x_axis_values) max(x_axis_values)]);
ylabel('Coincidence angle [degrees]');
xlabel('Incident frequency / critical frequency [Hz / Hz]');
title('Remember that below 1, it would mean that the angle is more than 90, so it is physically impossible.');
grid
