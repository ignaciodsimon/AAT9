 
function SData = multidimensional_positions(SData, showPlot)
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
% uses multidimensional scaling as seen in psychophysics course

% Tobias van Baarsel, AAU, 2015


ndim = 2; %number of dimensions to map to. Speakers in 2D
c = 343; %speed of sound

%% building distance matrix


dist = zeros(5,5);% 5 speakers, distance matrix = 5x5

for i=1:5
    for j=1:5

    dist(i,j) = SData(i).microphones(2).recordings(j).estimatedTime * c;

    end
    dist(i,i) = 0;
end;

%% averaging data : from real data to ideal symmetric matrix

avgdist = (dist + dist')/ 2;

%% Multidimensional Analysis

[Y,stress] = mdscale(avgdist,ndim);

offset = Y(3,:);
Y(1,:) = Y(1,:)-offset; % putting third loudspeaker to origin;
Y(2,:) = Y(2,:)-offset;
Y(3,:) = Y(3,:)-offset;
Y(4,:) = Y(4,:)-offset;
Y(5,:) = Y(5,:)-offset;

theta = atan2(Y(1,2),Y(1,1)); % rotate points
R = [cos(theta) , -sin(theta) ; sin(theta) , cos(theta)];
newY = Y * R;

if newY(1,1)>newY(2,1)
    newY(:,1) = -1 .* newY(:,1);
end;
if (newY(4,2)>0)
    newY(:,2) = -1 .* newY(:,2);
end;

%% comparing with measured data

measured = load('measuredDistances.mat');
[X,stressX] = mdscale(measured.measuredDistances,2);
X = [X(:,1) X(:,2)];

X(1,:) = X(1,:)-offset; % putting third loudspeaker to origin;
X(2,:) = X(2,:)-offset;
X(3,:) = X(3,:)-offset;
X(4,:) = X(4,:)-offset;
X(5,:) = X(5,:)-offset;
% rotate points
X = X * R;

if X(1,1)>X(2,1)
    X(:,1) = -1 .* X(:,1);
end;
if (X(4,2)>0)
    X(:,2) = -1 .* X(:,2);
end;

%%

if showPlot
    labels = { '1' '2' '3' '5' '6'};
    ftsize = 14;
    figure()
    plot(newY(:,1),newY(:,2),'r o','MarkerFaceColor','r');
    hold on
    plot(X(:,1),X(:,2),'b o');
    legend(['from IR delays, stress = ' num2str(stress)],['from measured distances, stress = ' num2str(stressX)]);
    xlabel(['[m]']);ylabel(['[m]']);
    text(newY(:,1), newY(:,2), labels, 'Color', 'r', 'VerticalAlignment','top', ...
         'HorizontalAlignment','center','FontSize', ftsize);
    text(X(:,1), X(:,2), labels, 'Color', 'b', 'VerticalAlignment','top', ...
         'HorizontalAlignment','center','FontSize', ftsize);
    title(['comparing the two estimated positions for ' num2str(ndim) ' dimensions'],'fontsize',12);
    grid on
    set(gca,'FontSize',ftsize);
    set(gcf,'PaperPosition',[0 0 29.7 21]);
    set(gcf,'PaperSize',[29.7 21]);
    saveas(gcf,'EstPos','pdf');

    pause()
    close all
end

SData(1).position = [newY(1,1) newY(1,2)];
SData(2).position = [newY(2,1) newY(2,2)];
SData(3).position = [newY(3,1) newY(3,2)];
SData(4).position = [newY(4,1) newY(4,2)]; % WARNING : SPEAKER 4 IS NO LONGER SUBWOOFER (WITH NEW GEOMETRY2)
SData(5).position = [newY(5,1) newY(5,2)];



end








