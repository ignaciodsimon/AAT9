%% Test

addpath('Classes','Geometry');
clc
close all
% clear all

fs = 44100;
c = 340;


x = [0 1 2 1 0];
y = [0 0 1 2 2];
phi = [0 45 0 90 270 ]; % in degrees

a = 0.3;


SDATA= generateSyntheticIRs(x,y,a,phi,fs,c);
SDATA(1).width = 0.3;
SDATA = geometry2(SDATA);



disp('done');

% 
draw(SDATA(1).position, SDATA(2).position, SDATA(3).position, SDATA(4).position, SDATA(5).position,...
    SDATA(1).orientation, SDATA(2).orientation, SDATA(3).orientation, SDATA(4).orientation, SDATA(5).orientation);


