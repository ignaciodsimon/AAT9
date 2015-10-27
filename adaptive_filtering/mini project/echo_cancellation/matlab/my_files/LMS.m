function [e] = LMS( u, d, mu, M)
%% %% Least Mean Square Adaptive filter %%
%
%   [e] = LMS( u, d, mu, M, epsilon)
%
% ! input column vectors ! 
%
% mu is the step-size, M the length of the filter.
% 0 < mu < 2/tr(Ru)
%
% typical values are : mu = 0.05; 
%                      epsilon = [0.001 to 1]; 
%
% AAU, 2015

sprintf(['Running the Least Mean Square adaptive filter...' '\n \n']);

L  = length(u);
N  = L-M;         % number of iterations
A = flipud(hankel(u(1:M),u(M:N+M-1)));      %matrix of input vectors

y = zeros(1,N);
e = zeros(1,N);     % filtered signal(hopefully)
w = zeros(M,N+1);   % adaptive filter coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the LMS adaptive Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:N
  y(n) = A(:,n)'*w(:,n);            % compute the filter output
  e(n) = d(n)-y(n);                 % compute the error
  w(:,n+1) = w(:,n)+mu*A(:,n)*e(n); % update the filter coefficients 
end


end

