%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
% 
%   
%   Nødvendig filer til dette script:
%   Equalizer.m (denne fil)
%   whitenoise.wav (originalt hvidstøjs signal)
%   linchirp.wav (originalt chirp signal)
%   RecNoise.wav (Optaget hvidstøj)
%   RecLinChirp.wav (Optaget chirp)
%   Test_sample.wav (Musik sample)
%   smoothMag.m (Funktion til midling af amplitude)
%
%% Setup
close all; clear; clc;

% Indlæsning af originale og optagede lydsignaler, samt samplerate
[noise, fs] = audioread('whitenoise.wav');
linchirp = audioread('linchirp.wav');
x = audioread('RecNoise.wav');
z = audioread('RecLinChirp.wav');
%% Signal delay
%

XCORRnoise = xcorr(x,noise);
XCORRchirp = xcorr(z,linchirp);
[~,DInoise] = max(XCORRnoise);
[~,DIchirp] = max(XCORRchirp);
Delay_noise = DInoise - length(x);
Delay_chirp = DIchirp - length(z);

noise = noise(44100:end);
linchirp = linchirp(44100:end);
x = x(Delay_noise:length(noise));
z = z(Delay_chirp:length(linchirp));

%% Analyse
% Indledende analyse af de originale og optagede signaler

% Originale signaler
% find længden af signalerne
n_noise = length(noise);
n_lch = length(linchirp);

% normaliser x-aksen så signalerne kan plottes som frekvens
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
title('Original hvidstøj');
xlabel('tid [s]'), ylabel('Amplitude');
subplot(3,1,2), plot(f_noise,10*log10(P_noise));
title('Amplitude plot (hvidstøj)');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');
subplot(3,1,3), plot(f_rnoise,10*log10(P_rnoise));
title('Amplitude plot (optaget hvidstøj)');
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


%% Overføringsfunktion (højtaler/rum/mikrofon)
% lavet med hvidstøjssignal
N = 2^19;
f = (0:N-1)*(fs/N);
n = 0:N-1;
Ts = 1/fs;

XNOISE = fft(noise,N);
XRNOISE = fft(x,N);

H = XRNOISE./XNOISE;
%INV_H = XNOISE./XRNOISE;

% figure;
% semilogx(f,20*log10(abs(Y)));
% title('Overføringsfunktion');
% xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

MIDY = smoothMag(abs(H'),499);
figure;
semilogx(f,20*log10(abs(MIDY)));
title('Overføringsfunktion (midlet hvidstøj)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

h = ifft(H);

figure;
plot(n*Ts,h);
title('Impulsrespons (hvidstøj)');
xlabel('[]'), ylabel('Tid[]');

%% Overføringsfunktion (højtaler/rum/mikrofon)
% lavet med chirp signal
Nchirp = 2^20;
fchirp = (0:Nchirp-1)*(fs/Nchirp);
nchirp = 0:Nchirp-1;

XCHIRP = fft(linchirp,Nchirp);
XRCHIRP = fft(z,Nchirp);

HCHIRP = XRCHIRP./XCHIRP;

% figure;
% semilogx(fchirp,20*log10(abs(YCHIRP)));
% title('Overføringsfunktion (chirp)');
% xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

mYCHIRP = smoothMag(abs(HCHIRP'),499);
figure;
semilogx(fchirp,20*log10(abs(mYCHIRP)));
title('Overføringsfunktion (midlet chirp)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

hchirp = ifft(HCHIRP);

figure;
plot(nchirp*Ts,hchirp);
title('Impulsrespons (chirp)');
xlabel('[]'), ylabel('[]');

%% Filter (hvidstøjs filter)

[orig,Fsorig] = audioread('Test_sample.wav');
ysound = filter(h,1,orig);
ynoise = filter(h,1,noise);

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
title('Amplitude plot (hvidstøjs filter [musik])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_noise,10*log10(mP_ynoise));
title('Amplitude plot (hvidstøjs filter [hvidstøjs])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

figure;
semilogx(f_rnoise,10*log10(mP_rnoise));
title('Amplitude plot (hvidstøjs filter [optaget hvidstøjs])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]');

%% Filter (chirp filter)

y2sound = filter(hchirp,1,orig);
yfchirp = filter(hchirp,1,linchirp);

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
%% Fixed prefiltering

Music_nim = audioread('Filtered_music_noise_impulse.wav');
Music_cim = audioread('Filtered_music_chirp_impulse.wav');

% test
% INV_H = H.^-1;
% inv_h = ifft(INV_H);
% Music = filter(inv_h,1,Music_nim);
% soundsc(Music,Fsorig);


%% test music
n = 0:Norig-1;
Mu = 0.01;
M = 150;
[Test,W,J,e,ylms] = lms(Music_nim,orig,Mu,M);
Music = filter(Test,1,Music_nim);
%soundsc(Music,Fsorig);

figure;
subplot(211),plot(n,W);
%subplot(211),plot(n,W(265,:),'-o',n,W(513,:),'-s');
xlabel('n');
title('Convergence of filter coefficients');
%legend('w_0(n)','w_1(n)','Location','NorthWest');
grid
subplot(212),plot(n,10*log10(J))
xlabel('n'),ylabel('J(w)')
title('MSE')
grid

%% test chirp
n = 0:length(linchirp)-1;
Mu = 0.01;
M = 150;
ztest = z(1:length(linchirp));
[Test,W,J,e,ylms] = lms(ztest,linchirp,Mu,M);
Music = filter(Test,1,ztest);
%soundsc(Music,fs);

figure;
subplot(211),plot(n,W);
%subplot(211),plot(n,W(265,:),'-o',n,W(513,:),'-s');
xlabel('n');
title('Convergence of filter coefficients');
%legend('w_0(n)','w_1(n)','Location','NorthWest');
grid
subplot(212),plot(n,10*log10(J))
xlabel('n'),ylabel('J(w)')
title('MSE')
grid
