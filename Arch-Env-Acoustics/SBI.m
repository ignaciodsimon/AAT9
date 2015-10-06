function [ I ] = SBI(IR)
%SBI Schroeder backward integration
%   Detailed explanation goes here

L = length(IR);
I = zeros(1,L);

for j=1:L
   I(j) = sum(IR(L-j+1:L));
end

I = fliplr(I);

end

