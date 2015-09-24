%% DRAW 



function draw(pos1,pos2,pos3,pos4,pos5,angle1,angle2,angle3,angle4,angle5)

img = imread('speaker.png');
img = imresize(img,0.5);

scale = 400;
pos1 = scale * pos1;
pos2 = scale * pos2;
pos3 = scale * pos3;
pos4 = scale * pos4;
pos5 = scale * pos5;



figure(1)

imgrot = imrotate(img,angle1);
imgrot = uint8(255.*ones(size(imgrot))) - imgrot;
image(pos1(1),pos1(2),imgrot);
text(pos1(1),pos1(2),'speaker 1');



hold on

imgrot = imrotate(img,angle2);
imgrot = uint8(255.*ones(size(imgrot))) - imgrot;
image(pos2(1),pos2(2),imgrot);
text(pos2(1),pos2(2),'speaker 2');

hold on

imgrot = imrotate(img,angle3);
imgrot = uint8(255.*ones(size(imgrot))) - imgrot;
image(pos3(1),pos3(2),imgrot);
text(pos3(1),pos3(2),'speaker 3');

hold on

imgrot = imrotate(img,angle4);
imgrot = uint8(255.*ones(size(imgrot))) - imgrot;
image(pos4(1),pos4(2),imgrot);
text(pos4(1),pos4(2),'speaker 4');

hold on

imgrot = imrotate(img,angle5);
imgrot = uint8(255.*ones(size(imgrot))) - imgrot;
image(pos5(1),pos5(2),imgrot);
text(pos5(1),pos5(2),'speaker 5');

axis([-2000 2000 -2000 2000]);
axis square
grid on


end
