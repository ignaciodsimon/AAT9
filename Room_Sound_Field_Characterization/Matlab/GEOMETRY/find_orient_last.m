% clc
% clear all
% close all

% pos = [3,-2];
% pos1 = [0,2];
% pos2 = [0,-2];
% 
% w = 0.3;



function i = find_orient_last(pos,pos1,pos2,tA1,tB1,tA2,tB2,width)


c = 343;
w = width;

%% partie théorique


dA1 = c * tA1;
dA2 = c * tA2;
dB1 = c * tB1;
dB2 = c * tB2;

%

delta1 = (dB1 - dA1); %différence de marche en valeur abs
d1 = norm(pos1 - pos); % distance entre les HP
gamma1 = atan2(pos1(2) - pos(2), pos1(1) - pos(1)); % angle entre les HP

%

delta2 = (dB2 - dA2); %différence de marche en valeur abs
d2 = norm(pos2 - pos); % distance entre les HP
gamma2 = atan2(pos2(2) - pos(2), pos2(1) - pos(1)); % angle entre les HP


%%
% d1 = round(d1,2); % arrondi des valeurs 
% d2 = round(d2,2);
% delta1 = round(delta1,2);
% delta2 = round(delta2,2);
% gamma1 = round(gamma1,2);
% gamma2 = round(gamma2,2);
%%

 
% connus : d ; gamma ; delta ; w ; 

% RÉSOLUTION NUMÉRIQUE : 

dth = 0.01;
theta_test = 0:dth:2*pi;
one = ones(1,length(theta_test));

%

PB1 = [d1*cos(gamma1).*one - w*cos(theta_test) ; d1*sin(gamma1).*one - w*sin(theta_test)]; %vecteur entre micro et HP, variable
PA1 = [d1*cos(gamma1).*one + w*cos(theta_test) ; d1*sin(gamma1).*one + w*sin(theta_test)];
normB1 = sqrt( PB1(1,:).^2 + PB1(2,:).^2 );
normA1 = sqrt( PA1(1,:).^2 + PA1(2,:).^2 );
delta_est1 = (normA1 - normB1); %distance de marche estimée en valeur abs, variable
error1 = abs(delta_est1 - delta1.*one);
moy_err_1 = mean(error1);
%

PB2 = [d2*cos(gamma2).*one - w*cos(theta_test) ; d2*sin(gamma2).*one - w*sin(theta_test)]; %distance entre micro et HP, variable
PA2 = [d2*cos(gamma2).*one + w*cos(theta_test) ; d2*sin(gamma2).*one + w*sin(theta_test)];
normB2 = sqrt( PB2(1,:).^2 + PB2(2,:).^2 );
normA2 = sqrt( PA2(1,:).^2 + PA2(2,:).^2 );
delta_est2 = (normA2 - normB2); %distance de marche estimée en valeur abs, variable
error2 = abs(delta_est2 - delta2.*one);
moy_err_2 = mean(error2);


pow = 0; %puissance de pondération
fact = (moy_err_1/moy_err_2)^pow; %facteur de pondération


error = sqrt(error1.^2 + ( fact*error2).^2);


[~,i] = min(error);
i = i*dth ; % in radianz 


%% PLOTS
% 
% posA = pos + [w*cos(i),w*sin(i)];
% posB = pos + [-w*cos(i),-w*sin(i)];
% 
% 
% figure()
% plot(pos(1),pos(2),'kx');text(pos(1),pos(2),'pos');
% hold on;
% plot(pos1(1),pos1(2),'rx');text(pos1(1),pos1(2),'pos1');
% hold on
% plot(pos2(1),pos2(2),'gx');text(pos2(1),pos2(2),'pos2');
% hold on
% plot(posA(1),posA(2),'ko');text(posA(1),posA(2),'posA');
% hold on
% plot(posB(1),posB(2),'ko');text(posB(1),posB(2),'posB');
% axis([-5 5 -5 5]);
% 
% 
% 
% figure()
% plot(rad2deg(theta_test),delta_est1,'r');
% hold on
% plot(rad2deg(theta_test),delta1.*one,'--r');
% hold on
% % plot(rad2deg(theta_test),moy_err_1 .* one,'r ^');
% hold on
% 
% plot(rad2deg(theta_test),delta_est2,'g');
% hold on
% plot(rad2deg(theta_test),delta2.*one,'--g');
% hold on
% % plot(rad2deg(theta_test),moy_err_2 .* one,'g ^');
% hold on
% 
% plot(rad2deg(theta_test),error1,'x r');
% hold on 
% plot(rad2deg(theta_test),error2,'x g');
% hold on
% plot(rad2deg(theta_test),error,'--x b');
% hold on
% plot(rad2deg(i).* ones(1,9),[-2:0.5:2],'-* k');
% legend('estimated delta1','measured delta1','estimated delta2','measured delta2','err1','err2','global error');
% text(50,-1.5,['found theta = ',num2str(rad2deg(i)),'°'],'fontsize',14);
% xlabel('variable angle (degrees)','fontsize',12);
% ylabel('"distance" delay = c_0 * dt (meters)','fontsize',12);
% title('minimising the error between measured delta and estimated delta :');
% 
% pause()

end