% Script for mm9 in psycho course. Assign 3 attributes to 6 different
% pictures. 
% Christian
clc
clear all
close all

words = 3;


%% show pictures 1 by 1 and rate them:
name = input('Declare your name, infidel! ', 's');

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/cold.jpg','InitialMagnification','fit');
    cold_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/warm.jpg','InitialMagnification','fit');
    warm_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/organic.jpg','InitialMagnification','fit');
    organic_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/yum.jpg','InitialMagnification','fit');
    yum_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/disgust.jpeg','InitialMagnification','fit');
    disgust_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all

disp(['Describe the pictures attributes using ',num2str(words),' different words. Press enter after each word please.']);
for i = 1 : words
    imshow('pictures/pleasure.jpg','InitialMagnification','fit');
    pleasure_answer{i} = input(['Word ', num2str(i) ,': '], 's');
end
close all


%% save to file

disp('-> Saving to .txt file..')

fid=fopen(strcat(name,'.txt'),'w');
fprintf(fid, ['Pic1' '\t\t\t\t' 'Pic2' '\t\t\t\t' 'Pic3' '\t\t\t\t' 'Pic4' '\t\t\t\t' 'Pic5' '\t\t\t\t' 'Pic6' '\n']);
for i = 1 : words
x = sprintf('%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n',...
    cold_answer{i}, warm_answer{i}, organic_answer{i}, yum_answer{i}, disgust_answer{i}, pleasure_answer{i});
fprintf(fid,x);
end
fclose(fid);
disp('-> Done saving..')

