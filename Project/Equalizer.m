%%  E5ADSB projekt
%%  Opgave beskrivelse
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

% Indlæsning af originale og optagede lydsignaler samt samplerate
[noise, Fs] = audioread('whitenoise.wav');
chirp = audioread('linchirp.wav');
Rec_noise = audioread('RecNoise.wav');
Rec_chirp = audioread('RecLinChirp.wav');

% Indlæsning af musik sample og samplerate
[music,Fsmusic] = audioread('Test_sample.wav');

%% Signal delay
% For at kunne bruge LMS algoritmen senere i scriptet, er det nødvendigt at
% have de originale og optage signaler synkroniseret. For at synkronisere
% signalerne findes først korrelationen mellem signalerne, indekset for
% korrelationen minus længden af det originale signal svare til
% forsinkelsen mellem signalerne.
XCORRnoise = xcorr(Rec_noise,noise);
XCORRchirp = xcorr(Rec_chirp,chirp);
[~,DInoise] = max(XCORRnoise);
[~,DIchirp] = max(XCORRchirp);
Delay_noise = DInoise - length(Rec_noise);
Delay_chirp = DIchirp - length(Rec_chirp);


%%
% Tilpas signaler
% De original signalerne er skabt med en indlagt forsinkelse på 1 sekund i
% starten, dette sekund skæres væk ved at starte signalet 1 sekund inde.
noise = noise(44100:end);
chirp = chirp(44100:end);


%%
% De optagede signaler indeholder forsinkelsen på 1 sekund samt
% forsinkelsen mellem signalerne, ligeledes kørte optagelserne i længere
% tid end original signalerne blev afspillet. For kunne bruge LMS
% algoritmen skal de anvendte signaler have samme længde, derfor kortes
% optagede signaler af til at have samme længde som de originale afspillede
% signaler.
Rec_noise = Rec_noise(44100+Delay_noise:length(noise)+44100+Delay_noise-1);
Rec_chirp = Rec_chirp(44100+Delay_chirp:length(chirp)+44100+Delay_chirp-1);

%% Analyse af signaler
% Indledende analyse af de originale og optagede signaler

% Originale signaler
% find længden af signalerne
n_noise = length(noise);
n_chirp = length(chirp);

% Beregn FFT 
NOISE = fft(noise);
CHIRP = fft(chirp);

% Beregn amplitude spektret af signalerne
P_noise = abs(NOISE).^2/n_noise;
P_chirp = abs(CHIRP).^2/n_chirp;


% Optagede signaler
n_rec_noise = length(Rec_noise);
n_rec_chirp = length(Rec_chirp);

X = fft(Rec_noise);
Z = fft(Rec_chirp);

P_rec_noise = abs(X).^2/n_rec_noise;
P_rec_chirp = abs(Z).^2/n_rec_chirp;


%% Sektion til formatering
% Linje til formatering

% Plot
% Normaliser af x-aksen så signalerne kan plottes som frekvens
f_noise = (0:n_noise-1)*(Fs/n_noise);
f_chirp = (0:n_chirp-1)*(Fs/n_chirp);
f_rnoise = (0:n_rec_noise-1)*(Fs/n_rec_noise);
f_rchirp = (0:n_rec_chirp-1)*(Fs/n_rec_chirp);

figure;
subplot(3,1,1), plot(noise);
title('Original hvidstøj');
xlabel('tid [s]'), ylabel('Amplitude'), grid;
subplot(3,1,2), plot(f_noise,10*log10(P_noise));
title('Amplitude plot (hvidstøj)');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;
subplot(3,1,3), plot(f_rnoise,10*log10(P_rec_noise));
title('Amplitude plot (optaget hvidstøj)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

figure;
subplot(3,1,1), plot(chirp);
title('Original chirp');
xlabel('tid [s]'), ylabel('Amplitude'), grid;
subplot(3,1,2), plot(f_chirp,10*log10(P_chirp));
title('Amplitude plot (chirp)');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;
subplot(3,1,3), plot(f_rchirp,10*log10(P_rec_chirp));
title('Amplitude plot (optaget chirp)');
xlabel('Frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

%% Overføringsfunktion (højtaler/rum/mikrofon)
% Lavet med hvidstøjssignal
N = 2^19;
n = 0:N-1;
Ts = 1/Fs;

% Beregn overføringsfunktion
TF_NOISE = fft(noise,N);
TF_RECNOISE = fft(Rec_noise,N);
H_NOISE = TF_RECNOISE./TF_NOISE;

% Bereng impulsrespons
h_noise = ifft(H_NOISE);


%% Sektion til formatering
% Linje til formatering

% Plot
% Normalisering af x-aksen så signalerne kan plottes som frekvens
f_TF_noise = (0:N-1)*(Fs/N);

% Midling af overføringsfunktion for at give en pænere graf
MID_H_NOISE = smoothMag(abs(H_NOISE'),499);

figure;
semilogx(f_TF_noise,20*log10(abs(MID_H_NOISE)));
title('Overføringsfunktion (midlet hvidstøj)'), xlim([20 20e3]);
xlabel('Frekvens [Hz]'), ylabel('Amplitude [dB]'), grid;

figure;
plot(n*Ts,h_noise);
title('Impulsrespons (hvidstøj)'), xlabel('[]'), ylabel('Tid[]'), grid;

%% Overføringsfunktion (højtaler/rum/mikrofon)
% Lavet med chirp signal
Nchirp = 2^20;
nchirp = 0:Nchirp-1;

TF_CHIRP = fft(chirp,Nchirp);
TF_RECCHIRP = fft(Rec_chirp,Nchirp);
H_CHIRP = TF_RECCHIRP./TF_CHIRP;

h_chirp = ifft(H_CHIRP);


%% Sektion til formatering
% Linje til formatering

% Plot
f_TF_chirp = (0:Nchirp-1)*(Fs/Nchirp);
mYCHIRP = smoothMag(abs(H_CHIRP'),499);

figure;
semilogx(f_TF_chirp,20*log10(abs(mYCHIRP)));
title('Overføringsfunktion (midlet chirp)'), xlim([20 20e3]);
xlabel('Frekvens [Hz]'), ylabel('Amplitude [dB]'), grid;

figure;
plot(nchirp*Ts,h_chirp);
title('Impulsrespons (chirp)'), xlabel('[]'), ylabel('[]'), grid;

%% Filtrering (Hvidstøjs filter)
% Filtrering af hhv. musik sample og hvidstøjssignal med impulsrespons
% genereret udfra hvidstøjssignalet. Dette giver en simulering af at optage
% signalerne i det samme rum som de originale optagelser er lavet i.
Sim_music_noise = filter(h_noise,1,music);
Sim_noise = filter(h_noise,1,noise);

N_music = length(music);
SIM_MUSIC_NOISE = fft(Sim_music_noise);
P_SIM_MUSIC_NOISE = abs(SIM_MUSIC_NOISE).^2/N_music;

SIM_NOISE = fft(Sim_noise);
P_SIM_NOISE = abs(SIM_NOISE).^2/n_noise;


%% Sektion til formatering
% Linje til formatering

% Plot
% Normaliser af x-aksen så signalerne kan plottes som frekvens
f_sim_music = (0:N_music-1)*(Fsmusic/N_music);

% Midling af amplitude spektret, for at give en pænere graf
mid_P_SIM_MUSIC = smoothMag(P_SIM_MUSIC_NOISE',499);
mid_P_SIM_NOISE = smoothMag(P_SIM_NOISE',499);
mid_P_REC_NOISE = smoothMag(P_rec_noise',499);

figure;
semilogx(f_sim_music,10*log10(mid_P_SIM_MUSIC));
title('Amplitude plot (hvidstøjs filter [musik])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

figure;
semilogx(f_noise,10*log10(mid_P_SIM_NOISE));
title('Amplitude plot (hvidstøjs filter [hvidstøjs])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

figure;
semilogx(f_rnoise,10*log10(mid_P_REC_NOISE));
title('Amplitude plot (hvidstøjs filter [optaget hvidstøjs])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

%% Filtrering (Chirp filter)
% Filtrering af hhv. musik sample og chirpsignal med impulsrespons
% genereret udfra chirpsignalet. Dette giver en simulering af at optage
% signalerne i det samme rum som de originale optagelser er lavet i.
Sim_music_chirp = filter(h_chirp,1,music);
Sim_chirp = filter(h_chirp,1,chirp);

SIM_MUSIC_CHIRP = fft(Sim_music_chirp);
P_SIM_MUSIC_CHIRP = abs(SIM_MUSIC_CHIRP).^2/N_music;

SIM_CHIRP = fft(Sim_chirp);
P_SIM_CHIRP = abs(SIM_CHIRP).^2/n_chirp;


%% Sektion til formatering
% Linje til formatering

% Plot
mid_P_SIM_MUSIC_CHIRP = smoothMag(P_SIM_MUSIC_CHIRP',499);
mid_P_SIM_CHIRP = smoothMag(P_SIM_CHIRP',499);
mid_P_REC_CHIRP = smoothMag(P_rec_chirp',499);

figure;
semilogx(f_sim_music,10*log10(mid_P_SIM_MUSIC_CHIRP));
title('Amplitude plot (chirp filter [musik])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

figure;
semilogx(f_noise,10*log10(mid_P_SIM_CHIRP));
title('Amplitude plot (chirp filter [chirp])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

figure;
semilogx(f_rnoise,10*log10(mid_P_REC_CHIRP));
title('Amplitude plot (chirp filter [optaget chirp])');
xlabel('frekvens [Hz]'), xlim([20 20e3]), ylabel('Amplitude [dB]'), grid;

%% Fixed prefiltering
% Gemmer de simulerede musik samples, så de kan bruges senere uden at kører
% hele scriptet igennem. 
% audiowrite('Filtered_music_noise_impulse.wav',Sim_music_noise,Fsmusic);
% audiowrite('Filtered_music_chirp_impulse.wav',Sim_music_chirp,Fsmusic);

%% LMS på simuleret optagelse
% LMS algoritmen udført på simuleret musik optagelse lavet med hvidstøj
n = 0:N_music-1;
Mu = 0.01;  % Stepsize
M = 20;     % Antal koefficienter
[koef_music,W,J,~,~] = lms(Sim_music_noise,music,Mu,M);
LMS_music = filter(koef_music,1,Sim_music_noise);
% soundsc(LMS_music,Fsmusic);


%% Sektion til formatering
% Linje til formatering

% Plot
figure;
subplot(211), plot(n,W);
xlabel('n'), title('Convergence of filter coefficients');
grid;
subplot(212),plot(n,10*log10(J));
xlabel('n'), ylabel('J(w)'), title('MSE'), grid;

%% LMS på chirp signal
% LMS algoritmen udført på optaget chirp signal
n = 0:length(chirp)-1;
Mu = 0.01;
M = 20;
[koef_chirp,W,J,~,~] = lms(Rec_chirp,chirp,Mu,M);
LMS_chirp = filter(koef_chirp,1,Rec_chirp);
% soundsc(LMS_chirp,Fs);


%% Sektion til formatering
% Linje til formatering

% Plot
figure;
subplot(211), plot(n,W);
xlabel('n'), title('Convergence of filter coefficients');
grid;
subplot(212), plot(n,10*log10(J));
xlabel('n'), ylabel('J(w)'), title('MSE'), grid;
