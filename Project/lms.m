function [w,W,J,e,y]=lms(x,d,mu,M,wi)
% LMS algorithm for M'th order adaptive FIR filter
%   Ref: Poularikas and Ramadan, Adaptive Filtering Primer with Matlab
%   Modified by KPL, 2018-11-08

if nargin<5
    wi=zeros(M,1);  % default initial coefficient guess
end

N=length(x);

% Initialization
W=zeros(M,N);       % M filter coeffs, N iterations
W(:,1)=wi;          % initial guess, default zero vector
y=zeros(1,N);
e=zeros(1,N);

for n=M:N-1
    % xk=flipud(x(k-(M-1):k));      % update delay line
    x_dl=x(n:-1:n-M+1);                % fill delay line  
    y(n)=x_dl'*W(:,n);              % y(n)
    e(n)=d(n)-y(n);                 % e(n)=d(n)-y(n)
    W(:,n+1)=W(:,n)+2*mu*e(n)*x_dl; % update coefficients
    
end
x_dl=x(N:-1:N-M+1);                 % fill delay line
y(N)=x_dl'*W(:,N);                  % y(n)
e(N)=d(N)-y(N);                     % e(n)=d(n)-y(n)
w=W(:,N);
J=e.^2; % MSE