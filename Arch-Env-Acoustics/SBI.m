function [ I ] = SBI(IR)
%SBI Schroeder backward integration
%   [ I ] = SBI(IR); 
% input :  Inpulse Response vector of length L
% output : vector of length L 		 I(l) = integral(s(l).^2), from l to L 
%
% 2015, AAU


L = length(IR);
I = zeros(1,L);

for l=1:L
   I(l) = sum(IR(L-l+1:L).^2);
end

I = fliplr(I);

end

