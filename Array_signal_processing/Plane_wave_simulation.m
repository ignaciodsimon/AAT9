close all
clc
clear all
%% Plane wave simulation in 2-D
% for array signal processing course
% 20-10-2015


%% wave parameters

T = 2e-9; % exponential decay constant
e1 = [0.87 0.5]; % propagation direction of first wave
e2 = [0.87 -0.5]; % propagation direction of second wave
f_0 = 2.4e9; % carrier frequency
c = 3e8; % speed light

delta_d = 0.02; % spatial grid for simulation
d_max = 1; % simulation area 1m x 1m
[Dx,Dy] = meshgrid((0:delta_d:d_max),(0:delta_d:d_max));
D = (Dx + 1i.*Dy); % matrix of position vectors in complex notation
e1 = e1(1) + 1i*e1(2);% direction vector in complex notation
e2 = e2(1) + 1i*e2(2);

%% microphones

r1 = [0.1 0.84];
r2 = [0.6 0.4];

%%

dt = 0.06e-9; % time step size
t_max = 5e-9;
t = 0:dt:t_max; % time vector
L = length(t);

z = @(t)  (exp(-(t./T).^2) .* cos(2*pi*f_0.*t)); % wave shape
E = zeros(size(D));

e1r_over_c = (real(e1).*real(D) + imag(e1).*imag(D))/c; %  e1 * r / c

mic1 = nan(1,L);
mic2 = nan(1,L);

figure
ax = gca;
ax.NextPlot = 'replaceChildren';
for j = 1:L
   fig = figure(1);
   E = z( t(j).*ones(size(D)) - e1r_over_c); %whole matrix
   mic1(j) = E(round(r1(1).*length(D)),round(r1(2).*length(D))); % amplitude at sensor1 ('microphone')
   mic2(j) = E(round(r2(1).*length(D)),round(r2(2).*length(D))); % amplitude at sensor2
    %--
    subplot(2,2,[1,2])
    surf(0:delta_d:d_max,0:delta_d:d_max,E);
    hold on
    plot3(r1(1),r1(2),0,'r o','MarkerFaceColor','r','MarkerSize',8);
    hold on
    plot3(r2(1),r2(2),0,'g o','MarkerFaceColor','g','MarkerSize',8);
    hold off
    view([11,55]);
    axis([0,1,0,1,-2,2])
    title('propagation of a plane wave in 2D');
    %--
    subplot(223)
    plot(t,mic1); %plot curve
    hold on
    plot(t(j),mic1(j),'r o','MarkerFaceColor','r','MarkerSize',8); %marker
    hold off
    axis([0,t_max, -1.1,1.1]);
    xlabel('time (ns)');ylabel('amplitude');title('amplitude measured by sensor 1');
    
    subplot(224)
    plot(t,mic2);%curve
    axis([0,t_max, -1.1,1.1]);
    hold on
    plot(t(j),mic2(j),'g o','MarkerFaceColor','g','MarkerSize',8); %marker
    hold off
    xlabel('time (ns)');ylabel('amplitude');title('amplitude measured by sensor 2');
    
    F(j) = getframe;
    
end

pause()
close all

%% FOR 2 WAVES

r1 = [delta_d 1];
r2 = [1 delta_d];
t_max = 8e-9;
t = 0:dt:t_max; % time vector
L = length(t);
mic1 = nan(1,L);
mic2 = nan(1,L);



e2r_over_c = (real(e2).*real(D) + imag(e2).*imag(D))/c; %e2 * r /c

figure
ax = gca;
ax.NextPlot = 'replaceChildren';
for j = 1:L
   fig = figure(1);
   E = z(t(j).*ones(size(D)) - e1r_over_c ) + z(t(j).*ones(size(D)) - e2r_over_c);
   mic1(j) = E(round(r1(1).*length(D)),round(r1(2).*length(D))); % amplitude at sensor1 ('microphone')
   mic2(j) = E(round(r2(1).*length(D)),round(r2(2).*length(D))); % amplitude at sensor2
    %--
    subplot(2,2,[1,2])
    surf(0:delta_d:d_max,0:delta_d:d_max,E);
    hold on
    plot3(r1(1),r1(2),0,'r o','MarkerFaceColor','r','MarkerSize',8);
    hold on
    plot3(r2(1),r2(2),0,'g o','MarkerFaceColor','g','MarkerSize',8);
    hold off
    view([-45,80]);
    axis([0,1,0,1,-2,2])
    title('propagation of two plane waves in 2D');
    %--
    subplot(223)
    plot(t,mic1); %curve
    hold on
    plot(t(j),mic1(j),'r o','MarkerFaceColor','r','MarkerSize',8); %marker
    hold off
    axis([0,t_max, -1.8,1.8]);
    xlabel('time (ns)');ylabel('amplitude');title('amplitude measured by sensor 1');
    
    subplot(224)
    plot(t,mic2); %curve
    hold on
    plot(t(j),mic2(j),'g o','MarkerFaceColor','g','MarkerSize',8); %marker
    hold off
    axis([0,t_max, -1.1,1.1]);
    xlabel('time (ns)');ylabel('amplitude');title('amplitude measured by sensor 2');
    
    F(j) = getframe;
    
end

  
 