%% C(2,N) = positions(d(N,N))
% no output, assigns values directly into TSpeaker instances
% takes TSpeaker array as input
%
% Tobias van Baarsel, AAU, 2015





function SDATA = positions(SDATA)

c = 340;

N = 5%size(SData,2)

%coord = zeros(5,2);

% 1st step : take 2 reference points

SDATA(1).position =  [0,0];
SDATA(2).position =  [SDATA(1).microphones(2).recordings(2).estimatedTime * c , 0];

for n = 3:N % initialization
   SDATA(n).position = [0,0];
end

% compute n-th point from two previous points

for n = 3:N
    n
   %disp(['point' num2str(n)])
   %coord(n,:) = find_pos(coord(n-2,:),coord(n-1,:), d(n-2,n), d(n-1,n)); 
    SDATA(n).position = find_pos(SDATA(n-2).position,SDATA(n-1).position, SDATA(n-2).microphones(2).recordings(n).estimatedTime, SDATA(n-1).microphones(2).recordings(n).estimatedTime);
end


end