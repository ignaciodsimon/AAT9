%% function theta = orientation(delta_d,w)
% A and B are coordinates of points A : [A_x,A_y] and B :[B_x,B_y], t_ac
% and t_bc are times from point A to C and from B to C, respectively
% outputs angle in radians
%
% Tobias van Baarsel, AAU, 2015





function theta = find_orient(A,B,t_A1,t_A2,t_B1,t_B2)


loc1 = find_pos(A,B,t_A1,t_B1);
loc2 = find_pos(A,B,t_A2,t_B2);

theta = atan2((loc2(2)-loc1(2)),(loc2(1)-loc1(1)));


end