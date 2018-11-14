function Y = smoothMag(X,M)
% Smoothing of signal. Eg. frequency magnitude spectrum. 
% X must be a row vector, and M must be odd.
% KPL 2016-09-19
N=length(X);
K=(M-1)/2;
Xz=[zeros(1,K) X zeros(1,K)];
Yz=zeros(1,2*K+N);
for n=1+K:N+K
    Yz(n)=mean(Xz(n-K:n+K));
end
Y=Yz(K+1:N+K);