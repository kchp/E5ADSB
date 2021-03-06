%%  E5ADSB Exercise 1
%%  System Identification
%
%   Se pdf i mappe [1. �velser/�velse 1]
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
xin = randn(N,1); % input signal til systemet

%% 2. Skab d(k)
d = filter(b,1,xin); % skaber reference signalet d(k)

%% 3. Implementer LMS algorytme
M = 2;          % antal filterkoefficienter
u = 10^-3;      % step-size
x = zeros(M,N); % delay linje
                % (ville personligt bruge z, men den kaldes x i
                % dokumentationen)
W = zeros(M,N); % FIR koefficienter
                % (koefficienterne der �ndres l�bende af LMS algoritmen)
y = zeros(1,N); % FIR output
                % (resultat fra FIR filtret med de aktuelle koefficienter)
e = zeros(1,N); % error signal
                % (forskellen mellem referencen og det aktuelle resultat
                % fra FIR filtret)


% Implementering af LMS algoritme
for n = M:N
   x = xin(n:-1:n-(M-1)); % udfyld delay linjen
                          % start sample n:dekrementer med 1:til n-(M-1)
   y(n) = W(:,n)'*x;      % beregn output fra FIR filter
                          % W(:,n) : v�lger alle r�kker i kolonne n
   e(n) = d(n) - y(n);    % beregner fejlen mellem reference og aktuelt signal
   W(:,n+1) = W(:,n) + 2*u*e(n)*x; % opdater FIR koefficienter    
end

w = W(:,1:N);
wo = W(:,end);

%% 4. Plot af signal
figure;
n = 0:N-1;
subplot(2,1,1);
plot(n,w);
title('Filter koefficienters konvergens');
ylabel('w(n)');
legend('w_0(n)','w_1(n)','w_2(n)','location','best');
grid on;
subplot(2,1,2);
plot(n,10*log10(e.^2)); axis tight;
title('Squared error');
xlabel('Iteration, n'); ylabel('e^2(n) [dB]');
grid on;

disp(['Identificeret system: ' num2str(round(wo',3))]);

figure;
plot(n,d,n,y,n,e);
title('Iteration, n');
legend('d(n)','y(n)','e(n)');
grid on;

%% 5. Pr�v med andre v�rdier af M og u

disp('Hvis det identificerede system ikke er optimalt, brug anden M og/eller u');