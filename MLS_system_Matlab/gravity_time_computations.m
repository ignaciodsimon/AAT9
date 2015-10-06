TRIM_LENGTH = 20000;

% Read the impulse responses
[ir_pos1, samplingFreq] = audioread('75hz-filtered-pos1-1_best.wav');
ir_pos2 = audioread('75hz-filtered-pos2-2_best.wav');
ir_pos3 = audioread('75hz-filtered-pos3-3_best.wav');

% Normalize IRs amplitude
ir_pos1 = ir_pos1 / max(abs(ir_pos1));
ir_pos2 = ir_pos2 / max(abs(ir_pos2));
ir_pos3 = ir_pos3 / max(abs(ir_pos3));

% Trim IRs tails
ir_pos1 = ir_pos1(1:TRIM_LENGTH);
ir_pos2 = ir_pos2(1:TRIM_LENGTH);
ir_pos3 = ir_pos3(1:TRIM_LENGTH);

gravityTime_ir1 = gravityTime(ir_pos1, samplingFreq) * 1000;
gravityTime_ir2 = gravityTime(ir_pos2, samplingFreq) * 1000;
gravityTime_ir3 = gravityTime(ir_pos3, samplingFreq) * 1000;

% Lines for the division
line1 = zeros(size(ir_pos1)) -1;
line1(1 : round(gravityTime_ir1/1000 * samplingFreq)) = 1;
line2 = zeros(size(ir_pos2)) -1;
line2(1 : round(gravityTime_ir2/1000 * samplingFreq)) = 1;
line3 = zeros(size(ir_pos3)) -1;
line3(1 : round(gravityTime_ir3/1000 * samplingFreq)) = 1;

% Numbers for the X axis on time [ms]
x_axis = zeros(size(ir_pos1));
for i = 1 : length(x_axis)
    x_axis(i) = i / samplingFreq * 1000;
end

% Plots all results
subplot(3,1,1)
plot(x_axis, ir_pos1)
hold on
plot(x_axis, line1, 'r');
title(sprintf('Position 1 - Gravity time: %.2f [ms]', gravityTime_ir1));
grid

subplot(3,1,2)
plot(x_axis, ir_pos2)
hold on
plot(x_axis, line2, 'r');
title(sprintf('Position 2 - Gravity time: %.2f [ms]', gravityTime_ir2));
grid

subplot(3,1,3)
plot(x_axis, ir_pos3)
hold on
plot(x_axis, line3, 'r');
title(sprintf('Position 3 - Gravity time: %.2f [ms]', gravityTime_ir3));
grid