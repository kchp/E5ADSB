%%  E5ADSB Exercise 1
%%  System Identification
%
%   Se pdf i mappe [1. Øvelser/Øvelse 1]
%   
%   Det ukendte system!
%   H(z) = 0.67 + 0.21z^1
%   d(k) = 0.67x(k) + 0.21x(k-1)
%   
%% Setup
close all; clear; clc;

b = [0.67; 0.21];   % koefficienter for ukendte system

%% 1. Skab signalet x(k)
N = 1000;
xin = randn(N,1);

%% 2. Skab d(k)
d = filter(b,1,xin);

%% 3. Implementer LMS algorytme
M = 2;             % antal filterkoefficienter
u = 10^-3;         % step-size
z = zeros(M,N);    % delay blok
W = zeros(M,N);    % FIR koefficienter
e = zeros(1,N);    % error signal
y = zeros(1,N);    % FIR output

for n = M:N
   
    
end
