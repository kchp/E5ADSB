%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
%   
%% Setup
close all; clear; clc;

[noise, fs] = audioread('whitenoise.wav'); % indl�s hvidst�jssignal og samplerate
% chirp = audioread('chirp.wav');       % indl�s chirp signal
linchirp = audioread('linchirp.wav'); % indl�s chirp signal
x = audioread('RecNoise.wav'); % indl�s hvidst�jssignal og samplerate
% y = audioread('RecChirp.wav');       % indl�s chirp signal
z = audioread('RecLinChirp.wav'); % indl�s chirp signal

% N = fs;
% n = 0:N-1;

%% analyse
close all;

% original signal
n_noise = length(noise);
% n_ch = length(chirp);
n_lch = length(linchirp);
f_noise = (0:n_noise-1)*(fs/n_noise);
% f_ch = (0:n_ch-1)*(fs/n_ch);
f_lch = (0:n_lch-1)*(fs/n_lch);
NOISE = fft(noise);
% CH = fft(chirp);
LCH = fft(linchirp);
P_noise = abs(NOISE).^2/n_noise;
% P_ch = abs(CH).^2/n_ch;
P_lch = abs(LCH).^2/n_lch;


% recorded signal
n_rnoise = length(x);
n_rlch = length(z);
f_rnoise = (0:n_rnoise-1)*(fs/n_rnoise);
f_rlch = (0:n_rlch-1)*(fs/n_rlch);
X = fft(x);
Z = fft(z);
P_rnoise = abs(X).^2/n_rnoise;
P_rlch = abs(Z).^2/n_rlch;

% plot
figure;
subplot(3,1,1), plot(noise);
title('Original hvidst�j');
xlabel('tid'), ylabel('Amplitude');
subplot(3,1,2), plot(f_noise,P_noise);
title('Amplitude plot (hvidst�j)');
xlabel('frekvens'), xlim([20 20e3]), ylabel('Amplitude');
subplot(3,1,3), plot(f_rnoise,P_rnoise);
title('Amplitude plot (optaget hvidst�j)');
xlabel('Frekvens'), xlim([20 20e3]), ylabel('Amplitude');

figure;
subplot(3,1,1), plot(linchirp);
title('Original chirp');
xlabel('tid'), ylabel('Amplitude');
subplot(3,1,2), plot(f_lch,P_lch);
title('Amplitude plot (chirp)');
xlabel('frekvens'), xlim([20 20e3]), ylabel('Amplitude');
subplot(3,1,3), plot(f_rlch,P_rlch);
title('Amplitude plot (optaget chirp)');
xlabel('Frekvens'), xlim([20 20e3]), ylabel('Amplitude');

