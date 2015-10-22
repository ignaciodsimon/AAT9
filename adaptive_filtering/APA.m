function [e] = APA( u, d, beta, M, epsilon, K )
%% %% APA Affine Projection Adaptive filter %%
%
%  [e] = APA( u, d, beta, M, epsilon, K )
%
% ! input column vectors ! 
%
% beta is the step-size parameter, M the length of the filter, K the number
% of constraints on the APA minimisation problem.
% 0 < beta < 1
%
% typical values are : beta = [0.1 to 0.8]; 
%                      epsilon = [0.001 to 1]; 
%                      K = [3 to 10];
%
% AAU, 2015

sprintf(['Running the Affine Projection Adaptive filter...' '\n \n']);

L  = length(u); %length of input vector
N  = L-(M-1+K-1); % number of iterations
U = flipud(hankel(u(1:M),u(M:N+M-1+K-1))); %matrix of input vectors

y = zeros(1,N);
e = zeros(1,N);     % filtered signal(hopefully)
w = zeros(M,N+1);   % adaptive filter coefficients

d = d'; % need row vector here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the APA adaptive Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:N
  y(n) = U(:,n+K-1)'*w(:,n)      ; % compute the filter output
  e(n) = d(n+K-1)-y(n)           ; % compute the error
  A    = fliplr(U(:,n:n+K-1)); % matrix of the K input vectors
  ev   = fliplr(d(n:n+K-1))'-A'*w(:,n); % error vector
  w(:,n+1) = w(:,n)+beta*A*((epsilon*eye(K)+A'*A)\ev); % update the filter coefficients
end

end

