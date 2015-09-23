%% C(N) = orientations(d(N,N))
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
%
% Tobias van Baarsel, AAU, 2015




function orientations(SData)

for n = 1:N

SData(n).orientation = find_orient( SData(n-2).position, SData(n-1).position, ...
                                      SData(n-2).mic(1).recordings(n).est_time, SData(n-2).mic(3).recordings(n).est_time, ...
                                         SData(n-1).mic(1).recordings(n).est_time, SData(n-1).mic(3).recordings(n).est_time ...
                                    );

end

end