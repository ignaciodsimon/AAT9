

close all
clc

run facial_expressions_mds.m;

[n,~] = size(facial); %number of points


stress = zeros(1,n-1);

for j=1:n-1 
ndim = j; %number of dimensions
[Y,stress(j)] = mdscale(facial,ndim);
end

figure(1)
hFig = figure(1);
set(hFig, 'Position', [0 0 800 300])
plot(1:n-1,stress);
xlabel('Number of dimensions []');ylabel('Stress []');

% Saves plot to PDF
set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
set(gcf, 'PaperSize', [8.1 3.1]);
saveas(gcf, 'spreeplot', 'pdf');


%
ndim = 3
[Y,stress,disparities] = mdscale(facial,ndim);


%labels = cellstr( num2str([1:n]') );  
labels = {'grief at death', 'savouring a coke', 'pleasant surprise', 'maternal love', 'physical exhaustion', 'smthing wrong with plane', 'anger', 'pulling hard', ...
    'unexpectedly meets old boyfriend', 'revulsion', 'extrm pain', 'knows plane crash', 'light sleep' };  


% figure()
% 
% U = 2;
% V = 3;
% 
% plot(Y(:,U),Y(:,V),'o');
% xlabel(['dimension ' num2str(U)]);ylabel(['dimension ' num2str(V)]);
% text(Y(:,U), Y(:,V), labels, 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','center')
% title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);

%%
figure(2)
hFig = figure(2);
set(hFig, 'Position', [0 0 800 300])
plot3(Y(:,1),Y(:,2),Y(:,3),'o');
xlabel('dimension 1');ylabel('dimension 2');zlabel('dimension 3');
text(Y(:,1), Y(:,2), Y(:,3), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','center')
title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);
grid('on')

% Saves plot to PDF
set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
set(gcf, 'PaperSize', [8.1 3.2]);
saveas(gcf, 'mdsplot3d', 'pdf');

%%
figure(3)
hFig = figure(3);
set(hFig, 'Position', [0 0 800 300])
plot3(Y(:,1),Y(:,2),Y(:,3),'o');
view(-2,50)
xlabel('dimension 1');ylabel('dimension 2');zlabel('dimension 3');
text(Y(:,1), Y(:,2), Y(:,3), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','center')
title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);
grid('on')

% Saves plot to PDF
set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
set(gcf, 'PaperSize', [8.1 3.2]);
saveas(gcf, 'mdsplot3drotated', 'pdf');



%%
figure(4)
hFig = figure(4);
set(hFig, 'Position', [0 0 800 300])
dissimilarities = squareform(facial);
 
       % Use non-metric scaling to recreate the data in 2D, and make a
       % Shepard plot of the results.
       [Y,stress,disparities] = mdscale(dissimilarities,3);
       distances = pdist(Y);
       [dum,ord] = sortrows([disparities(:) dissimilarities(:)]);
       plot(dissimilarities,distances,'bo', ...
            dissimilarities(ord),disparities(ord),'r.-');
       xlabel('Dissimilarities'); ylabel('Distances/Disparities')
       
       % Saves plot to PDF
set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
set(gcf, 'PaperSize', [8.1 3.2]);
saveas(gcf, 'shepardplot', 'pdf');

       
       
% % Displays plots and save them nicely
% 
% hFig = figure(1);
% set(hFig, 'Position', [0 0 800 300])
% 
% plot(h_RL, 'Marker','o', 'LineWidth', 1)
% hold on
% plot(h_RR, 'Marker','o', 'LineWidth', 1)
% grid on
% % Legend and labels
% legend('Far ear IR','Close ear IR', 'location', 'southwest')
% xlabel('Samples', 'FontSize', 12)
% ylabel('Amplitude [.]', 'FontSize', 12)
% %title(sprintf('Estimated SNR: %.2f [dB]', estimated_snr), 'FontSize', 12, 'FontWeight', 'bold')
% 
% % Saves plot to PDF
% set(gcf, 'PaperPosition', [0 0 8.15 3.15]);
% set(gcf, 'PaperSize', [8.1 3.1]);
% saveas(gcf, 'RspeakBothears', 'pdf');
