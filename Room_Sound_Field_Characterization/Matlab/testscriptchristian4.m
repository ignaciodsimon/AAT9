%test script for dynamic beamformator

clc
% clear all

addpath ('Classes', 'GEOMETRY');
Data = load('final_trimmed_data.mat');
processedData = geometry2(Data.speakerData,0);
fs = 48000;
c = 340;

resolution = 10;

focus_point_x = linspace(processedData(1).position(1) + 0.2, processedData(2).position(1) - 0.2, resolution);
focus_point_y = linspace(processedData(1).position(2) - 0.2, processedData(5).position(2) + 0.2, resolution);

%1 m2 around speaker ls
% focus_point_x = linspace(processedData(4).position(1) - 0.5, processedData(4).position(1) + 0.5, resolution);
% focus_point_y = linspace(processedData(4).position(2) - 0.5, processedData(4).position(2) + 0.5, resolution);
% 
% focus_point_x = 1;
% focus_point_y = 1;

number_of_focus_points_x = length(focus_point_x);
number_of_focus_points_y = length(focus_point_y);


inputAudio = audioread('six-channels-pink-noise.wav');

%choose the speaker(s) to radiate by setting others to zero
inputAudio(:,1:5) = zeros(size(inputAudio(:,1:5)));
% inputAudio(:,3:6) = zeros(size(inputAudio(:,3:6)));
outputAudio = playAudiosInRoom(inputAudio);




%% Beamformate
disp(sprintf('  > Initializing das beamformator of superior performance'))
%choose what speakers to form the beamformator array
array1 = 1;
array2 = 2;
array3 = 3;


spk_position1 = processedData(array1).position;
orientation1 = processedData(array1).orientation;
spk_position2 = processedData(array2).position;
orientation2 = processedData(array2).orientation;
spk_position3 = processedData(array3).position;
orientation3 = processedData(array3).orientation;

array_pos = [spk_position1; spk_position2; spk_position3];
orientations = [orientation1; orientation2; orientation3];
array_signals = [outputAudio(:,array1*3-2) outputAudio(:,array1*3)...
                 outputAudio(:,array2*3-2) outputAudio(:,array2*3)...
                 outputAudio(:,array3*3-2) outputAudio(:,array3*3)];

            disp(sprintf('Current x is: %.2d. Current y is: %.2d',j, i))

for i = 1 : number_of_focus_points_y
    for j = 1 : number_of_focus_points_x
        
        disp(sprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b %.2d. Current y is: %.2d',j,i));
        focus_point = [focus_point_x(j) focus_point_y(i)];            
        [output, bands, mic_positions, summation] = dasBeamformator(array_signals, array_pos, orientations, focus_point, c, fs);
        levels(i,j,:) = output;
        summ(i,j,:) = summation;

    end
end




%% plot levels in 3D

x = focus_point_x;
y = focus_point_y;

for i = 1 : 18
    clf
    w = 0;
    z = levels(:,:,i);
    hold on
    figure1 = surf(x,y,z,'EdgeColor','none');
    colorbar
%     imagesc(z)
    titlestr = sprintf('Band evaluated is: %.1f',bands(i));
    title(titlestr)
    xlabel('x distance [m]');
    ylabel('y distance [m]');
    zlabel('pressure [db]');
    
    for m = 1 : size(mic_positions,1)
    plot3(mic_positions(m,1),mic_positions(m,2),mean(max(z)), 'x', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'r')
    plot3(mic_positions(m,3),mic_positions(m,4),mean(max(z)), 'o', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'r')
%     plot3(mic_positions(2,1),mic_positions(2,2),mean(max(z)), 'x', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'b')
%     plot3(mic_positions(2,3),mic_positions(2,4),mean(max(z)), 'o', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'b')
%     plot3(mic_positions(3,1),mic_positions(3,2),mean(max(z)), 'x', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'b')
%     plot3(mic_positions(3,3),mic_positions(3,4),mean(max(z)), 'o', 'MarkerSize', 8, 'LineWidth', 2, 'Color', 'b')
    end
    
    for k = 1 : 5
    plot3(processedData(k).position(1),processedData(k).position(2), mean(max(z)), 'x', 'MarkerSize', 5, 'Color', 'b')
    end
    view(180,90)
    grid on
    while w == 0
       w = waitforbuttonpress;
    end
end






















