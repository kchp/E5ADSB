%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
% 
%   
%   N�dvendig filer til dette script:
%   Equalizer.m (denne fil)
%   whitenoise.wav (originalt hvidst�js signal)
%   linchirp.wav (originalt chirp signal)
%   RecNoise.wav (Optaget hvidst�j)
%   RecLinChirp.wav (Optaget chirp)
%   Test_sample.wav (Musik sample)
%   smoothMag.m (Funktion til midling af amplitude)
%
%% Setup
close all; clear; clc;

% Indl�sning af originale og optagede lydsignaler, samt samplerate
[noise, fs] = audioread('whitenoise.wav');
linchirp = audioread('linchirp.wav');
x = audioread('RecNoise.wav');
z = audioread('RecLinChirp.wav');

%% Analyse
% Indledende analyse af de originale og optagede signaler

% Originale signaler
% find l�ngden af signalerne
n_noise = length(noise);
n_lch = length(linchirp);

% normaliser x-aksen s� signalerne kan plottes som frekvens
f_noise = (0:n_noise-1)*(fs/n_noise);
f_lch = (0:n_lch-1)*(fs/n_lch);

% beregn FFT 
NOISE = fft(noise);
LCH = fft(linchirp);

% 
P_noise = abs(NOISE).^2/n_noise;
P_lch = abs(LCH).^2/n_lch;


% optagede signaler
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
xlabel('tid [s]'), ylabel('Amplitude');
subplot(3,1,2), plot(f_noise,10*log10(P_noise));
title('Amplitude plot (hvidst�j)');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');
subplot(3,1,3), plot(f_rnoise,10*log10(P_rnoise));
title('Amplitude plot (optaget hvidst�j)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
subplot(3,1,1), plot(linchirp);
title('Original chirp');
xlabel('tid [s]'), ylabel('Amplitude');
subplot(3,1,2), plot(f_lch,10*log10(P_lch));
title('Amplitude plot (chirp)');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');
subplot(3,1,3), plot(f_rlch,10*log10(P_rlch));
title('Amplitude plot (optaget chirp)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');


%% Overf�ringsfunktion (h�jtaler/rum/mikrofon)
% lavet med hvidst�jssignal
N = 2^19;
f = (0:N-1)*(fs/N);

XNOISE = fft(noise,N);
XRNOISE = fft(x,N);

Y = XRNOISE./XNOISE;

% figure;
% semilogx(f,20*log10(abs(Y)));
% title('Overf�ringsfunktion');
% xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

MIDY = smoothMag(abs(Y'),499);
figure;
semilogx(f,20*log10(abs(MIDY)));
title('Overf�ringsfunktion (midlet hvidst�j)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

y = ifft(Y);

midy = smoothMag(abs(y'),499);
figure;
semilogx(f,20*log10(abs(midy)));
title('Impulsrespons (hvidst�j)');
xlabel('[]'), xlim([20 20e3]), ylabel('[]');

%% Overf�ringsfunktion (h�jtaler/rum/mikrofon)
% lavet med chirp signal
Nchirp = 2^20;
fchirp = (0:Nchirp-1)*(fs/Nchirp);

XCHIRP = fft(linchirp,Nchirp);
XRCHIRP = fft(z,Nchirp);

YCHIRP = XRCHIRP./XCHIRP;

% figure;
% semilogx(fchirp,20*log10(abs(YCHIRP)));
% title('Overf�ringsfunktion (chirp)');
% xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

mYCHIRP = smoothMag(abs(YCHIRP'),499);
figure;
semilogx(fchirp,20*log10(abs(mYCHIRP)));
title('Overf�ringsfunktion (midlet chirp)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

ychirp = ifft(YCHIRP);

mychirp = smoothMag(abs(ychirp'),499);
figure;
semilogx(fchirp,20*log10(abs(mychirp)));
title('Impulsrespons (chirp)');
xlabel('[]'), xlim([20 20e3]), ylabel('[]');

%% Filter (hvidst�js filter)

[orig,Fsorig] = audioread('Test_sample.wav');
ysound = filter(midy,1,orig);
ynoise = filter(midy,1,noise);

Norig = length(orig);
YSOUND = fft(ysound);
f_orig = (0:Norig-1)*(Fsorig/Norig);
P_orig = abs(YSOUND).^2/Norig;
mP_orig = smoothMag(P_orig',499);

YNOISE = fft(ynoise);
P_ynoise = abs(YNOISE).^2/n_noise;
mP_ynoise = smoothMag(P_ynoise',499);

mP_rnoise = smoothMag(P_rnoise',499);

figure;
semilogx(f_orig,10*log10(mP_orig));
title('Amplitude plot (hvidst�js filter [musik])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_noise,10*log10(mP_ynoise));
title('Amplitude plot (hvidst�js filter [hvidst�js])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_rnoise,10*log10(mP_rnoise));
title('Amplitude plot (hvidst�js filter [optaget hvidst�js])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

%% Filter (chirp filter)

y2sound = filter(mychirp,1,orig);
yfchirp = filter(mychirp,1,linchirp);

Y2SOUND = fft(y2sound);
P2_orig = abs(Y2SOUND).^2/Norig;
mP2_orig = smoothMag(P2_orig',499);

YFCHIRP = fft(yfchirp);
P_yfchirp = abs(YFCHIRP).^2/n_lch;
mP_yfchirp = smoothMag(P_yfchirp',499);

mP_rlch = smoothMag(P_rlch',499);

figure;
semilogx(f_orig,10*log10(mP2_orig));
title('Amplitude plot (chirp filter [musik])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_noise,10*log10(mP_yfchirp));
title('Amplitude plot (chirp filter [chirp])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_rnoise,10*log10(mP_rlch));
title('Amplitude plot (chirp filter [optaget chirp])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

%% LMS implementering
%

XCORRdelay = xcorr(z,linchirp);
[~,Dindex] = max(XCORRdelay);
Delay = Dindex - length(z);
