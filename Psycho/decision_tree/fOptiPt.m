function [p,chistat,u,lL_eba,lL_sat,fit,cova] = fOptiPt(M,A,s)
% fOptiPt parameter estimation for BTL/Pretree/EBA models
%   p = fOptiPt(M,A) estimates the parameters of a model specified
%   in A for the paired-comparison matrix M. M is a matrix with
%   absolute frequencies. A is a cell array.
%
%   [p,chistat,u] = fOptiPt(M,A) estimates parameters and reports
%   the chi2 statistic as a measure of goodness of fit. The vector
%   of scale values is stored in u.
%
%   [p,chistat,u,lL_eba,lL_sat,fit,cova] = fOptiPt(M,A,s) estimates
%   parameters, checks the goodness of fit, computes the scale values,
%   reports the log-likelihoods of the model specified in A and of the
%   saturated model, returns the fitted values and the covariance
%   matrix of the parameter estimates. If defined, s is the starting
%   vector for the estimation procedure. Otherwise each starting value
%   is set to 1/length(p).
%   The minimization algorithm used is FMINSEARCH.
%
%   Examples
%     Given the matrix M = 
%                            0    36    35    44    25
%                           19     0    31    37    20
%                           20    24     0    46    24
%                           11    18     9     0    13
%                           30    35    31    42     0
%
%     A BTL model is specified by A = {[1];[2];[3];[4];[5]}
%     Parameter estimates and the chi2 statistic are obtained by
%       [p,chistat] = fOptiPt(M,A)
%
%     A Pretree model is specified by A = {[1 6];[2 6];[3 7];[4 7];[5]} 
%     A starting vector is defined by s = [2 2 3 4 4 .5 .5]
%     Parameter estimates, the chi2 statistic, the scale values, the
%     log-likelihoods of the Pretree model and of the saturated model,
%     the fitted values, and the covariance matrix are obtained by
%       [p,chistat,u,lL_eba,lL_sat,fit,cova] = fOptiPt(M,A,s)
%
% Authors: Florian Wickelmaier (wickelmaier@web.de) and Sylvain Choisel
% Last mod: 29/NOV/2003 (Bug fix: y1/y0 have the correct upper/lower tri)
% For detailed information see Wickelmaier, F. & Schmid, C. (2004). A Matlab
% function to estimate choice model parameters from paired-comparison data.
% Behavior Research Methods, Instruments, and Computers, 36(1), 29-40.

I = length(M);  % number of stimuli
mmm = 0;
for i = 1:I
  mmm = [mmm max(A{i})];
end
J = max(mmm);  % number of pt parameters
if(nargin == 2)
  p = [ones(1,J)*(1/J)]';  % starting values
elseif(nargin == 3)
  p = s;
end

idx1 = zeros(I*(I-1)/2,J);
idx0 = idx1;
rdx = 1;
for i = 1:I-1
  for j = i+1:I
    idx1(rdx,setdiff(A{i},A{j})) = 1;
    idx0(rdx,setdiff(A{j},A{i})) = 1;
    rdx = rdx+1;
  end
end

tM = M';
y1 = tM(find(tril(ones(size(tM)),-1)));
y0 = M(find(tril(ones(size(M)),-1)));
n = y1+y0;
lL_sat = nansum(log(binopdf(y1,n,y1./n)));

p = fminsearch(@ebalik,p,optimset('Display','iter','MaxFunEvals',10000,...
    'MaxIter',10000),y1,n,idx1,idx0);  % optimized parameters
lL_eba = -ebalik(p,y1,n,idx1,idx0);  % likelihood of the specified model

fit = ones(I)-diag(diag(ones(I)));  % fitted PCM
fit(tril(fit)~=0) = n./(1+(idx0*p)./(idx1*p));
fit = fit';
fit(tril(fit)~=0) = n./(1+(idx1*p)./(idx0*p));

chi = 2*(lL_sat-lL_eba);
df =  I*(I-1)/2 - (J-1);
chistat = [chi df 1-chi2cdf(chi,df)];  % goodness-of-fit statistic

u = sum(p(A{1}));  % scale values
for i = 2:I
  u = [u sum(p(A{i}))];
end

H = hessian('ebalik',p,y1,n,idx1,idx0);
C = inv([H ones(J,1); ones(1,J) 0]);
cova = C(1:J,1:J);

function lL_eba = ebalik(p,y1,n,idx1,idx0)  % computes the likelihood

if min(p)<=0  % bound search space
  lL_eba = inf;
  return
end

lL_eba = -sum(log(binopdf(y1,n,1./(1+(idx0*p)./(idx1*p)))));

function H = hessian(f,x,varargin)  % computes numerical Hessian

k = size(x,1);
fx = feval(f,x,varargin{:});
h = eps.^(1/3)*max(abs(x),1e-2);
xh = x+h;
h = xh-x;
ee = sparse(1:k,1:k,h,k,k);

g = zeros(k,1);
for i = 1:k
  g(i) = feval(f,x+ee(:,i),varargin{:});
end

H = h*h';
for i = 1:k
  for j = i:k
    H(i,j) = (feval(f,x+ee(:,i)+ee(:,j),varargin{:})-g(i)-g(j)+fx)...
                 / H(i,j);
    H(j,i) = H(i,j);
  end
end