%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
%   Dette script er anvendt til at skabe lydsignalerne
%   
%% Setup
close all; clear; clc;

%% Generate signals

fs = 44.1e3;
N = fs;
n = 0:N-1;

%chirp
low = chirp(0:1/fs:5,20,5,400);
high = chirp(0:1/fs:8,400,8,20e3);
y = [zeros(1,fs) low high];
z = [zeros(1,fs) chirp(0:1/fs:10,20,10,20e3)];

%soundsc(y,fs);
audiowrite('chirp.wav',y,fs);
audiowrite('linchirp.wav',z,fs);

% Y = fft(y,13*N);
% Pyy = (abs(Y).^2)/13*N;
% f = fs/N*n;
% 
% figure;
% plot(f(1:N/2),Pyy(1:N/2));
% title('Power spectral density');
% xlabel('Frekvens (Hz)');


%white noise

x = [zeros(1,fs) randn(1,10*fs+1,'double')];

% X = fft(x,N);
% Pxx = X.*conj(X)/N;
% f = fs/N*n;
% 
% figure;
% plot(f(1:N/2),Pxx(1:N/2));
% title('Power spectral density');
% xlabel('Frekvens (Hz)');

%soundsc(x,fs);
audiowrite('whitenoise.wav',x,fs);
