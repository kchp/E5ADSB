%%  E5ADSB Exercise 2
%%  Opgave beskrivelse
%  
%   
%% Setup
close all; clear; clc;

%% Øvelse 1

% de givne signaler, k ændre til n i opgaven
% x(k) = 0.5*cos(0.3*k)
% d(k) = sin*(0.3*k)

N = 20000;
n = 0:N-1;
w = 0.3;          % Vinkelfrekvens (omega)
f = w/(2*pi);     % Frekvens
x = 0.5*cos(w*n); % x(n)
d = 1*sin(w*n);   % d(n)

% 1. Hvor langs skal filtret være for at filtrere x(k) til d(k)?
% a. 

% 2. Hvad er filtrets formål?
% a. Filtret skal omforme input signalet x(k) så det ligner d(k), så der
%    skal ske en ændring af amplituden fra 0.5 til 1, og signalet skal
%    fasedrejes med 90 grader (cos til sin)

% 3. Wiener løsning
M = 2;                    % filter orden (længde)
rx = xcorr(x,M-1)/N;      % Normaliseret autokorrelation (max lag M-1)
Rx = toeplitz(rx(M:end)); % Autokorrelations matrix
                          % skaber et symmetrisk matrix af rx(fra M til
                          % slut)

rdx = xcorr(d,x,M-1)/N;   % Normaliseret krydskorrelation (max lag M-1)
pdx = rdx(M:end)';        % Krydskorrelations vektor

wo = Rx\pdx;              % Optimale wiener filterkoefficienter
disp(['Filterkoefficienter: ' num2str(wo')]);

y = filter(wo,1,x);       % Filtre input signal med de optimale
                          % filterkoefficienter
                          
e = d-y;                  % Error signal

% plot
figure;
plot(n,x,n,d,n,y,n,e);    % Plotter signalerne x, d, y og e ift. n
title('Sammenligning af signaler');
legend('x(n)','d(n)','y(n)','e(n)');
xlim([0 35]), ylim([-1.1 1.1]);
xlabel('n');
grid on;

% 4. Magnitude og faserespons af optimum filter
Nfft = 2048;
k = 0:Nfft-1;
Wo = fft(wo,Nfft);

kw = round(w/(2*pi)*Nfft); % k-værdi der svarer til vinkelfrekvens (w)
Wo_w = Wo(kw);

% plot
figure;
subplot(2,1,1);
plot(k(1:Nfft/2)*2*pi/Nfft,abs(Wo(1:Nfft/2)));
title('Optimum Wiener filter, w_o');
grid minor;
xlim([0 pi]);
ylabel('Magnitude');

subplot(2,1,2);
plot(k(1:Nfft/2)*2*pi/Nfft,angle(Wo(1:Nfft/2))*180/pi);
grid minor;
xlabel('Normaliseret vinkelfrekvens, \omega');
ylabel('Fase');
xlim([0 pi]);


