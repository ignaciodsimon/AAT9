

clc 
close all
%clear all


M = 500
x = 1:M;

test = rand(1,M).* (0.5.*x.^2);

I = SBI(test);

semilogy(x,test);
hold on
semilogy(x,I,'r');
xlabel('time');
ylabel('amplitude');
legend('signal','Backward Schröder Integration');
