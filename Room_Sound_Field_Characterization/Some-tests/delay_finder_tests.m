
clc
% [inputIR, sampleFreq] = audioread('example_ir.wav');
% 
% inputIR = inputIR(1:10000);
% 
% plot(inputIR)
% return
% 
% 
% % minVar = 1000;
% % stepSize = 1000;
% % 
% % for i = 100 : stepSize : 100000
% %     spectra = fft(inputIR, i);
% %     specModule = 20*log10(abs(spectra));
% %     if var(specModule) < minVar
% %         minVar = var(specModule);
% %         minVarLength = i;
% %     end
% % end
% % 
% % disp(sprintf('Best FFT for length: %d', minVarLength));
% 
% spectra = fft(inputIR, 1000);
% specModule = 20*log10(abs(spectra));
% specPhase = phase(spectra);
% 
% subplot(4,1,1)
% semilogx(specModule);
% grid
% subplot(4,1,2)
% plot(specPhase);
% grid
% 
% selectedPhaseValues = specPhase(440:560);
% averagePhase = sum(selectedPhaseValues) / length(selectedPhaseValues);
% 
% close all
% disp(averagePhase);
% return


[inputIR, sampleFreq] = audioread('example_ir.wav');
inputIR = inputIR(1:10000);
inputIR = inputIR.^3;
inputIR = inputIR / max(abs(inputIR));


filterLength = 50;
avgFilter = ones(1, filterLength);
filteredInputIR = conv(abs(inputIR), avgFilter);
filteredInputIR = filteredInputIR / max(abs(filteredInputIR));
filteredInputIR = filteredInputIR(filterLength/2:length(filteredInputIR));

plot(abs(inputIR));
hold on
plot(filteredInputIR, 'r')




return











filterLength = 200;
avgFilter = ones(1, filterLength);
filteredInputIR = conv(abs(inputIR), avgFilter);
filteredInputIR = filteredInputIR / max(abs(filteredInputIR));
filteredInputIR = filteredInputIR(filterLength : 10000 + filterLength-1);

plot(inputIR.^3)
hold on
plot(filteredInputIR/80, 'r')
return

inputIR = inputIR .* filteredInputIR(1:10000);


plot(inputIR)
return



















point = 1;

idealIR = zeros(1, 5011);
idealIR = idealIR + randn(size(idealIR))/400;
idealIR(point:point) = 1;

avgFilter = ones(1, 2);
idealIR = conv(idealIR, avgFilter);
idealIR = idealIR / max(abs(idealIR));

spectra = fft(idealIR);
specModule = 20*log10(abs(spectra));
specPhase = phase(spectra);
subplot(2,1,1)
plot(specModule);
grid
subplot(2,1,2)
plot(specPhase);
grid

