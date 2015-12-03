%% C(N) = orientations(d(N,N))
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
%
% Tobias van Baarsel, AAU, 2015


function SData = orientations(SData)


w = SData(1).width;


    pos = SData(1).position;
    pos_1 = SData(4).position;
    pos_2 = SData(3).position;
    tA1 = SData(1).microphones(1).recordings(4).estimatedTime;
    tA2 = SData(1).microphones(1).recordings(3).estimatedTime;
    tB1 = SData(1).microphones(3).recordings(4).estimatedTime;
    tB2 = SData(1).microphones(3).recordings(3).estimatedTime;
    SData(1).orientation = find_orient_last(pos,pos_1,pos_2,tA1,tB1,tA2,tB2,w);
         
    t1x = [pos_1(1) pos(1) pos_2(1)];
    t1y = [pos_1(2) pos(2) pos_2(2)];
    
    
    
    pos = SData(2).position;
    pos_1 = SData(5).position;
    pos_2 = SData(3).position;
    tA1 = SData(2).microphones(1).recordings(5).estimatedTime;
    tA2 = SData(2).microphones(1).recordings(3).estimatedTime;
    tB1 = SData(2).microphones(3).recordings(5).estimatedTime;
    tB2 = SData(2).microphones(3).recordings(3).estimatedTime;
    SData(2).orientation = find_orient_last(pos,pos_1,pos_2,tA1,tB1,tA2,tB2,w);
    
    t2x = [pos_1(1) pos(1) pos_2(1)];
    t2y = [pos_1(2) pos(2) pos_2(2)];
    
    
    
    pos = SData(3).position;
    pos_1 = SData(1).position;
    pos_2 = SData(5).position;
    tA1 = SData(3).microphones(1).recordings(1).estimatedTime;
    tA2 = SData(3).microphones(1).recordings(5).estimatedTime;
    tB1 = SData(3).microphones(3).recordings(1).estimatedTime;
    tB2 = SData(3).microphones(3).recordings(5).estimatedTime;
    SData(3).orientation = find_orient_last(pos,pos_1,pos_2,tA1,tB1,tA2,tB2,w);
    
    t3x = [pos_1(1) pos(1) pos_2(1)];
    t3y = [pos_1(2) pos(2) pos_2(2)];
    
    
    
    pos = SData(4).position;
    pos_1 = SData(1).position;
    pos_2 = SData(5).position;
    tA1 = SData(4).microphones(1).recordings(1).estimatedTime;
    tA2 = SData(4).microphones(1).recordings(5).estimatedTime;
    tB1 = SData(4).microphones(3).recordings(1).estimatedTime;
    tB2 = SData(4).microphones(3).recordings(5).estimatedTime;
    SData(4).orientation = find_orient_last(pos,pos_1,pos_2,tA1,tB1,tA2,tB2,w);
    
    t4x = [pos_1(1) pos(1) pos_2(1)];
    t4y = [pos_1(2) pos(2) pos_2(2)];
    
    
    
    pos = SData(5).position;
    pos_1 = SData(2).position;
    pos_2 = SData(4).position;
    tA1 = SData(5).microphones(1).recordings(2).estimatedTime;
    tA2 = SData(5).microphones(1).recordings(4).estimatedTime;
    tB1 = SData(5).microphones(3).recordings(2).estimatedTime;
    tB2 = SData(5).microphones(3).recordings(4).estimatedTime;
    SData(5).orientation = find_orient_last(pos,pos_1,pos_2,tA1,tB1,tA2,tB2,w);

    t5x = [pos_1(1) pos(1) pos_2(1)];
    t5y = [pos_1(2) pos(2) pos_2(2)];
    
    
    
    %% plot the relations between orientations
    % which angles were taken to compute orientation ?
    % 1 : 3 & 4
    % 2 : 3 & 5
    % 3 : 1 & 5
    % 4 : 1 & 5
    % 5 : 2 & 4
%     
%     figure()
%     plot(t1x,t1y);
%     
%     hold on
%     plot(t2x,t1y);
%     
%     hold on
%      plot(t3x,t3y);
%     
%     hold on
%     plot(t4x,t4y);
%     
%     hold on
%     plot(t5x,t5y);
%     hold off
%     
%     
%     pause()
    
    

end