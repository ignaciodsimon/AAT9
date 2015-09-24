%% C(N) = orientations(d(N,N))
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
%
% Tobias van Baarsel, AAU, 2015




function orientations(SData)

N = size(SData,2);

for n = 3:N

SData(n).orientation = find_orient( SData(n-2).position, SData(n-1).position, ...
                                      SData(n-2).mic(1).recordings(n).estimatedTime, SData(n-2).mic(3).recordings(n).estimatedTime, ...
                                         SData(n-1).mic(1).recordings(n).estimatedTime, SData(n-1).mic(3).recordings(n).estimatedTime ...
                                    );

end


% first speaker orientation with 2 last ones
n = N + 1
SData(1).orientation = find_orient( SData(n-2).position, SData(n-1).position, ...
                                      SData(n-2).mic(1).recordings(1).estimatedTime, SData(n-2).mic(3).recordings(1).estimatedTime, ...
                                         SData(n-1).mic(1).recordings(1).estimatedTime, SData(n-1).mic(3).recordings(1).estimatedTime ...
                                    );
                                
                                
% second speaker orientation with last one and first one                   
n = N + 2
SData(2).orientation = find_orient( SData(n-2).position, SData(1).position, ...
                                      SData(n-2).mic(1).recordings(2).estimatedTime, SData(n-2).mic(3).recordings(2).estimatedTime, ...
                                         SData(1).mic(1).recordings(2).estimatedTime, SData(1).mic(3).recordings(2).estimatedTime ...
                                    );

                                
                               
                                

end