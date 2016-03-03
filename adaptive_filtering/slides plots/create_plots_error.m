
readFile = load('savedResults_nlms.mat');
capturedData  = readFile.differences;

printFilterLength = 40000;

h = figure;
currentBeta = 0;
betas = 0;
counter2 = 1;
for i = 1:length(capturedData)
    if capturedData(i, 2) == printFilterLength
        if currentBeta ~= capturedData(i,1)
            % Plot previous line
            if currentBeta ~= 0
               semilogx(currentLineX, currentLineY, 'x-', 'LineWidth', 2);
               hold on
            end

            % Start new line to plot
            currentBeta = capturedData(i,1);
            betas(counter2) = currentBeta;
            currentLineX = 0;
            currentLineY = 0;
            counter = 1;
            counter2 = counter2 + 1;

        else
            % Continue saving current line to plot
            currentLineX(counter) = capturedData(i,3);
            currentLineY(counter) = capturedData(i,4);
            counter = counter + 1;
        end
    end
end

if currentBeta ~= 0
    semilogx(currentLineX, currentLineY, 'x-', 'LineWidth', 2);

    legend(cellstr(num2str(betas', 'Beta = %.1f')), 'Location', 'northwest')
    grid
    xlabel('Epsilon value [.]');
    ylabel('Normalized error [.]');
    title(sprintf('Output error (filter length: %d samples).', printFilterLength));

    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, sprintf('output_error_filter_%d_long.pdf', printFilterLength),'-dpdf','-r0')

else
    close all
    disp('No data found for that filter length!');
end



return

dataFixedBeta_01 = [0.1000  500.0000    0.0001   43.9751
                0.1000  500.0000    0.0005   44.2324
                0.1000  500.0000    0.0010   44.5796
                0.1000  500.0000    0.0050   48.4278
                0.1000  500.0000    0.0100   49.9442
                0.1000  500.0000    0.0500   49.6939
                0.1000  500.0000    0.1000   49.6733
                0.1000  500.0000    0.5000   50.0269
                0.1000  500.0000    1.0000   50.3628
                0.1000  500.0000    2.0000   50.2458
                0.1000  500.0000    5.0000   50.4437];

dataFixedBeta_02 = [0.2000  500.0000    0.0001   43.5188
                0.2000  500.0000    0.0005   43.7248
                0.2000  500.0000    0.0010   43.9596
                0.2000  500.0000    0.0050   45.7758
                0.2000  500.0000    0.0100   46.1885
                0.2000  500.0000    0.0500   46.0242
                0.2000  500.0000    0.1000   46.0596
                0.2000  500.0000    0.5000   46.5709
                0.2000  500.0000    1.0000   46.9992
                0.2000  500.0000    2.0000   47.7409
                0.2000  500.0000    5.0000   49.4084];

dataFixedBeta_03 = [0.3000  500.0000    0.0001   43.6645
                0.3000  500.0000    0.0005   43.7123
                0.3000  500.0000    0.0010   43.8116
                0.3000  500.0000    0.0050   44.2262
                0.3000  500.0000    0.0100   44.3335
                0.3000  500.0000    0.0500   44.2268
                0.3000  500.0000    0.1000   44.2338
                0.3000  500.0000    0.5000   44.6494
                0.3000  500.0000    1.0000   45.1459
                0.3000  500.0000    2.0000   45.8543
                0.3000  500.0000    5.0000   47.4112];

dataFixedBeta_04 = [0.4000  500.0000    0.0001   42.8411
                0.4000  500.0000    0.0005   42.7912
                0.4000  500.0000    0.0010   42.8273
                0.4000  500.0000    0.0050   43.1437
                0.4000  500.0000    0.0100   43.2304
                0.4000  500.0000    0.0500   43.1842
                0.4000  500.0000    0.1000   43.0779
                0.4000  500.0000    0.5000   43.5389
                0.4000  500.0000    1.0000   43.9529
                0.4000  500.0000    2.0000   44.6880
                0.4000  500.0000    5.0000   46.0906];

dataFixedBeta_05 = [0.5000  500.0000    0.0001   42.3769
                0.5000  500.0000    0.0005   42.2577
                0.5000  500.0000    0.0010   42.2411
                0.5000  500.0000    0.0050   42.2913
                0.5000  500.0000    0.0100   42.3219
                0.5000  500.0000    0.0500   42.2583
                0.5000  500.0000    0.1000   42.1282
                0.5000  500.0000    0.5000   42.7412
                0.5000  500.0000    1.0000   43.1734
                0.5000  500.0000    2.0000   43.8079
                0.5000  500.0000    5.0000   45.1611];

dataFixedBeta_06 = [0.6000  500.0000    0.0001   42.1224
                0.6000  500.0000    0.0005   41.9605
                0.6000  500.0000    0.0010   41.9030
                0.6000  500.0000    0.0050   41.7201
                0.6000  500.0000    0.0100   41.7362
                0.6000  500.0000    0.0500   41.6601
                0.6000  500.0000    0.1000   41.5127
                0.6000  500.0000    0.5000   41.9972
                0.6000  500.0000    1.0000   42.6337
                0.6000  500.0000    2.0000   43.1797
                0.6000  500.0000    5.0000   44.4769];

dataFixedBeta_07 = [0.7000  500.0000    0.0001   42.0383
                0.7000  500.0000    0.0005   41.8521
                0.7000  500.0000    0.0010   41.6620
                0.7000  500.0000    0.0050   41.3824
                0.7000  500.0000    0.0100   41.3833
                0.7000  500.0000    0.0500   41.2596
                0.7000  500.0000    0.1000   41.1001
                0.7000  500.0000    0.5000   41.4760
                0.7000  500.0000    1.0000   42.0432
                0.7000  500.0000    2.0000   42.7150
                0.7000  500.0000    5.0000   43.9565];

dataFixedBeta_08 = [0.8000  500.0000    0.0001   42.0824
                0.8000  500.0000    0.0005   41.7929
                0.8000  500.0000    0.0010   41.5691
                0.8000  500.0000    0.0050   41.2356
                0.8000  500.0000    0.0100   41.1883
                0.8000  500.0000    0.0500   40.8743
                0.8000  500.0000    0.1000   40.7388
                0.8000  500.0000    0.5000   41.1021
                0.8000  500.0000    1.0000   41.5891
                0.8000  500.0000    2.0000   42.3635
                0.8000  500.0000    5.0000   43.5223];

dataFixedBeta_09 = [0.9000  500.0000    0.0001   41.8197
                0.9000  500.0000    0.0005   41.8320
                0.9000  500.0000    0.0010   41.6549
                0.9000  500.0000    0.0050   41.1884
                0.9000  500.0000    0.0100   41.0523
                0.9000  500.0000    0.0500   40.6174
                0.9000  500.0000    0.1000   40.4578
                0.9000  500.0000    0.5000   40.8300
                0.9000  500.0000    1.0000   41.2475
                0.9000  500.0000    2.0000   42.0585
                0.9000  500.0000    5.0000   43.1385];


% % Plot 0 - Beta and epsilon together (3D plot)
% 
% plot3(capturedData(:,1), capturedData(:,3), capturedData(:,4))
% xlabel('Beta');
% ylabel('Epsilon')
% zlabel('Similarity');

% Plot - Output error as a function of beta / epsilon

h = figure;
semilogx(dataFixedBeta_01(:,3), dataFixedBeta_01(:, 4), 'x-', 'LineWidth', 2);
hold on
semilogx(dataFixedBeta_02(:,3), dataFixedBeta_02(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_03(:,3), dataFixedBeta_03(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_04(:,3), dataFixedBeta_04(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_05(:,3), dataFixedBeta_05(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_06(:,3), dataFixedBeta_06(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_07(:,3), dataFixedBeta_07(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_08(:,3), dataFixedBeta_08(:, 4), 'x-', 'LineWidth', 2);
semilogx(dataFixedBeta_09(:,3), dataFixedBeta_09(:, 4), 'x-', 'LineWidth', 2);
legend({'Beta = 0.1', 'Beta = 0.2', 'Beta = 0.3', 'Beta = 0.4', 'Beta = 0.5', 'Beta = 0.6', 'Beta = 0.7', 'Beta = 0.8', 'Beta = 0.9'});
xlabel('Epsilon value [.]');
ylabel('Normalized error [.]');
title('Short filter output error (length: 500 samples).');
grid

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h, sprintf('output_error_filter_%d_long.pdf', printFilterLength),'-dpdf','-r0')
