 
function SData = multidimensional_positions( SData )
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

%% Multidimensional Analysis

[Y,stress] = mdscale(dist,ndim);


labels = { '1' '2' '3' '4' '5'};

figure()
plot(Y(:,1),Y(:,2),'o');
xlabel(['dimension 1']);ylabel(['dimension 2']);
text(Y(:,1), Y(:,2), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','center')
title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);

pause()

for i =1:5
SData(i).position = [Y(i,1) Y(i,2)];
end;


end








