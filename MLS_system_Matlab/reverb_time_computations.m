TRIM_LENGTH = 20000;
OFFSET_IRS = 25;
VERTICAL_RANGE = [-40 5];

% Read the impulse responses
ir_pos1 = audioread('75hz-filtered-pos1-1_best.wav');
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

% Compute the SBI and take the logarithm
sbi_1 = 10*log10(SBI(ir_pos1) / 20);
sbi_2 = 10*log10(SBI(ir_pos2) / 20);
sbi_3 = 10*log10(SBI(ir_pos3) / 20);

% Normalize the SBI to 0dB
sbi_1 = sbi_1 - max(sbi_1);
sbi_2 = sbi_2 - max(sbi_2);
sbi_3 = sbi_3 - max(sbi_3);

% Amplify the IR to plot them together with the SBI
ir_pos1 = ir_pos1 * 20;
ir_pos2 = ir_pos2 * 20;
ir_pos3 = ir_pos3 * 20;

% Offset the IRs to plot them below the SBI curves
ir_pos1 = ir_pos1 - OFFSET_IRS;
ir_pos2 = ir_pos2 - OFFSET_IRS;
ir_pos3 = ir_pos3 - OFFSET_IRS;

% Plot IRs and SBI

subplot(3,1,1)
plot(ir_pos1, 'b')
hold on
plot(sbi_1, 'k', 'LineWidth', 2)
legend('IR', 'SBI')
xlabel('Position 1')
ylim(VERTICAL_RANGE)
grid

subplot(3,1,2)
plot(ir_pos2, 'b')
hold on
plot(sbi_2, 'k', 'LineWidth', 2)
legend('IR', 'SBI')
xlabel('Position 2')
ylim(VERTICAL_RANGE)
grid

subplot(3,1,3)
plot(ir_pos3, 'b')
hold on
plot(sbi_3, 'k', 'LineWidth', 2)

% Plots three additional lines that follow the envelope of the SBI
plot([500 2400], [0 -10] -2, '-r', 'LineWidth', 2)
plot([2400 8000], [-10 -19.6] -2, '-b', 'LineWidth', 2)
plot([8000 14600], [-19.6 -23.7] -2, '-g', 'LineWidth', 2)

legend('IR', 'SBI')
xlabel('Position 3')
ylim(VERTICAL_RANGE)
grid

