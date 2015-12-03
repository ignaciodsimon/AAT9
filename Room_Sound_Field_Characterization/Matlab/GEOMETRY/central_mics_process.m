%% distances for central mics
%
%
%
%
function micsPositions = central_mics_process()

    disp('>> CENTRAL MICS POSITION ESTIMATION');

    fs = 48000;
    c0 = 340;
    start = 100;
    stop = 5000;

    disp('Loading central mics impulse responses ...');
    data = load('processed_results\3rd day\mls\averaged_central_mics.mat');
    data = data.accumulatedSetOfIRs;

    disp('Trimming IRs (short) and estimating delay.');
    for i=1:4
        for j=1:6
    tempIR = veryShortTrim(data(i).recordings(j).computedIR);
    data(i).recordings(j).estimatedTime = groupDelayEstimation(tempIR,fs,c0,start,stop);
        end
    end

    Mdist = nan(4,6);
    for i=1:4
        for j=1:6
        Mdist(i,j) = data(i).recordings(j).estimatedTime * c0; %distance from Mic i to Speaker j
        end 
    end;
    Mdist = [Mdist(:,1:3),Mdist(:,5:6)];

    micsPositions = nan(4,2);


    disp('Loading speakers IRs ...')
    SData = load('positioned_speakers.mat');
    SData = SData.data;

    dist = zeros(5,5);% 5 speakers, distance matrix = 5x5

    for i=1:5
        for j=1:5

        dist(i,j) = SData(i).microphones(2).recordings(j).estimatedTime * c0;

        end
        dist(i,i) = 0;
    end;

    disp('Applying the multidimensional scale function ...');
    
    %% averaging data : from real data to ideal symmetric matrix
    avgdist = (dist + dist')/ 2;
    dist = avgdist;
    clear i j
    clear avgdist
    %% building new matrix, one mic included

    for M = 1:4
    dat = Mdist(M,:);

    bigDist = [dist,dat' ; dat , 0];

    %% Multidimensional Analysis
    ndim = 2;
    [Y,stress] = mdscale(bigDist,ndim);

    offset = Y(3,:);
    Y(1,:) = Y(1,:)-offset; % putting third loudspeaker to origin;
    Y(2,:) = Y(2,:)-offset;
    Y(3,:) = Y(3,:)-offset;
    Y(4,:) = Y(4,:)-offset;
    Y(5,:) = Y(5,:)-offset;
    Y(6,:) = Y(6,:)-offset;

    theta = atan2(Y(1,2),Y(1,1)); % rotate points
    R = [cos(theta) , -sin(theta) ; sin(theta) , cos(theta)];
    Y = Y * R;

    if Y(1,1)>Y(2,1)
        Y(:,1) = -1 .* Y(:,1);
    end;
    if (Y(4,2)>0)
        Y(:,2) = -1 .* Y(:,2);
    end;

    micsPositions(M,:) = Y(6,:);

    end;

    disp('Done!');
end
% central microphone positions in Mpositions


%% plotting

% labels = { '1' '2' '3' '5' '6'};
% Mlabels = {'Mic1' 'Mic2' 'Mic3' 'Mic4'};
% ftsize = 14;
% figure()
% plot(Y(1:5,1),Y(1:5,2),'r o','MarkerFaceColor','r');
% hold on
% plot(Mpositions(:,1),Mpositions(:,2),'b o');
% legend(['speakers'],['central microphones']);
% xlabel(['[m]']);ylabel(['[m]']);
% text(Y(1:5,1), Y(1:5,2), labels, 'r', 'VerticalAlignment','top', ...
%                              'HorizontalAlignment','center','FontSize',ftsize)
% text(Mpositions(:,1), Mpositions(:,2), Mlabels, 'g', 'VerticalAlignment','top', ...
%                              'HorizontalAlignment','center','FontSize',ftsize)           
% title(['using multidimentional scaling to place the central microphones'],'fontsize',12);
% grid on
% axis([-2 2 -4 0.65]);
%  set(gca,'FontSize',ftsize);
%  set(gcf,'PaperPosition',[0 0 29.7 21]);
%  set(gcf,'PaperSize',[29.7 21]);
%  saveas(gcf,'MicPos','pdf');
% 
% 




