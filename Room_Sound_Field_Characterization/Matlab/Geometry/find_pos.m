%% computing position of a point relative to 2 other points, knowing the times
%% function [C] = findpos(A,B,t_ac,t_bc)
% A and B are coordinates of points A : [A_x,A_y] and B :[B_x,B_y], t_ac
% and t_bc are times from point A to C and from B to C, respectively
% 
% ouputs coordinates of point C=[C_x,C_y]
% 
% Tobias van Baarsel, AAU, 2015




function [C] = find_pos(A,B,t_ac,t_bc)

c = 340;


d_ac = t_ac * c;
d_bc = t_bc * c;

d_ab = sqrt((B(2)-A(2))^2 + (B(1)-A(1))^2); % distance AB

theta = atan2((B(2)-A(2)),(B(1)-A(1))); % absolute orientation of AB segment
% 
% disp(['d_ab = ' num2str(d_ab)])
% disp(['d_ac = ' num2str(d_ac)])
% disp(['d_bc = ' num2str(d_bc)])
% 
% %% angle BAC using cosine's law
% 
angle = acos((d_ac^2 + d_ab^2 - d_bc^2) / (2*d_ac*d_ab));




%% positions

C = nan(1,2);
C(1,1) = A(1) + d_ac*cos(angle-theta); %Cx
C(1,2) = A(2) - d_ac*sin(angle-theta); %Cy


end