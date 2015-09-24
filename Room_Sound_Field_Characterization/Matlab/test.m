%% Test

addpath('Classes','Geometry');
clc
close all

fs = 44100;
c = 340;


% x = [ 1 0 2 0 2];
% y = [ -1 2 2 0 0];

x = [0 1 2 1 0]; %first speaker always (0,0), need to think about what that means and what it does with real imput signals...
y = [0 0 1 2 2];

% x = [0 1 0 -1 -2];
% y = [0 1 2 2 1];

SDATA= generateSyntheticIRs(x,y,fs,c);

SDATA(1).orientation = 0;
SDATA(2).orientation = 30;
SDATA(3).orientation = 90;
SDATA(4).orientation = 120;
SDATA(5).orientation = 240;



%geometry(SDATA);
SDATA = positions(SDATA);


draw(SDATA(1).position, SDATA(2).position, SDATA(3).position, SDATA(4).position, SDATA(5).position,...
    SDATA(1).orientation, SDATA(2).orientation, SDATA(3).orientation, SDATA(4).orientation, SDATA(5).orientation);
