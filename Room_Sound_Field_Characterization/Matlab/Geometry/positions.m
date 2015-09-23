%% C(2,N) = positions(d(N,N))
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
%
% Tobias van Baarsel, AAU, 2015





function positions(SData)


[N,~] = size(d);

%coord = zeros(5,2);

% 1st step : take 2 reference points

SData(1).position =  [0,0];
SData(2).position =  [SData(1).mic(2).recordings(2).est_time , 0];


% compute n-th point from two previous points

for n = 3:N
   %disp(['point' num2str(n)])
   %coord(n,:) = find_pos(coord(n-2,:),coord(n-1,:), d(n-2,n), d(n-1,n)); 
    SData(1).position = find_pos(SData(n-2).position,SData(n-1).position, SData(n-2).mic(2).recordings(n).est_time, SData(n-1).mic(2).recordings(n).est_time);
end

end