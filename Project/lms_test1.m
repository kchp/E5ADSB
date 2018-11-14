% Test of LMS algorithm using System Identification Example
% Ref. PR Chap 7, KPL 2018-11-08

clear; close all; clc

N=100;
n=0:N-1;

% system identification example
x=randn(N,1);           % input signal, white
v=0.2*(rand(N,1)-0.5);  % measurement noise, zero mean
b=[1 0.38]';            % filter coeffs of (unknown) system to be modelled
d_hat=filter(b,1,x);    % desired signal 
d=d_hat+v;              % desired signal + measurement noise

mu=0.05;
M=2;

[w,W,J,e,y]=lms(x,d,mu,M);

disp('wlms='),disp(w)


% compare to optimum Wiener solution
M=length(b);            
rx=xcorr(x,M-1)/N;      
Rx=toeplitz(rx(M:end));
pdx=xcorr(d,x,M-1)/N;
p=pdx(M:end);
wo=Rx\p;
disp('wo='),disp(wo)

figure
subplot(211),plot(n,W(1,:),'-o',n,W(2,:),'-s')
xlabel('n'),ylabel('w_0(n), w_1(n)')
title('Convergence of filter coefficients')
legend('w_0(n)','w_1(n)','Location','NorthWest')
grid
subplot(212),plot(n,10*log10(J))
xlabel('n'),ylabel('J(w)')
title('MSE')
grid

% figure
% plot3(W(1,:),W(2,:),n,'--.',wo(1),wo(2),N-1,'rd','MarkerFaceColor','r')
% title('Convergence of filter coefficients')
% xlabel('w_0(n)'),ylabel('w_1(n)'),zlabel('n')
% legend('w-vector','w_o','location','NorthWest')
% grid