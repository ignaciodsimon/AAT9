
TRIM_LENGTH = 20000;
TIME_THRESHOLD = 50;


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

% Estimates the clarity
C50_ir1 = clarity(ir_pos1, TIME_THRESHOLD, samplingFreq);
C50_ir2 = clarity(ir_pos2, TIME_THRESHOLD, samplingFreq);
C50_ir3 = clarity(ir_pos3, TIME_THRESHOLD, samplingFreq);

% Plots all results
subplot(3,1,1)
plot(ir_pos1)
title(sprintf('Position 1 - Clarity: %.2f', C50_ir1));
grid

subplot(3,1,2)
plot(ir_pos2)
title(sprintf('Position 2 - Clarity: %.2f', C50_ir2));
grid

subplot(3,1,3)
plot(ir_pos3)
title(sprintf('Position 3 - Clarity: %.2f', C50_ir3));
grid
