%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
%   
%% Setup
close all; clear; clc;

%% Indlæs lydsamples

[noise, fs] = audioread('whitenoise.wav');  % indlæs hvidstøjssignal og samplerate
chirp = audioread('chirp.wav');       % indlæs chirp signal
linchirp = audioread('linchirp.wav');       % indlæs chirp signal

N = fs;
n = 0:N-1;

%% afspil og optag hvidstøj

recObj1 = audiorecorder(fs,24,1,1) % her defineres parametrene der optages udfra
% næst sidste variabel (1 nu), er hvilken kilde der optages fra

disp('Recording sound');
soundsc(noise,fs);
recordblocking(recObj1, 13); %her defineres tiden der optages
disp('Recording fisnihed');

%play(recObj);
x = getaudiodata(recObj1);

%% afspil og optag chirp

recObj2 = audiorecorder(fs,24,1,1) % her defineres parametrene der optages udfra
% næst sidste variabel (1 nu), er hvilken kilde der optages fra

disp('Recording sound');
soundsc(chirp,fs);
recordblocking(recObj2, 16); %her defineres tiden der optages
disp('Recording fisnihed');

%play(recObj);
y = getaudiodata(recObj2);


%% afspil og optag chirp

recObj3 = audiorecorder(fs,24,1,1) % her defineres parametrene der optages udfra
% næst sidste variabel (1 nu), er hvilken kilde der optages fra

disp('Recording sound');
soundsc(linchirp,fs);
recordblocking(recObj3, 13); %her defineres tiden der optages
disp('Recording fisnihed');

%play(recObj);
z = getaudiodata(recObj3);


%% Save recordings
% audiowrite('RecNoise.wav',x,fs);
% audiowrite('RecChirp.wav',y,fs);
% audiowrite('RecLinChirp.wav',z,fs);

%% analyse
% original signal
CH = fft(chirp);
Pch = CH.*conj(CH);
f = fs/N*n;
figure;
plot(f(1:N/2),Pch(1:N/2));
title('Power spectral density (chirp)');
xlabel('(n)');

% recorded signal
Y = fft(y,15*N);
Pyy = (abs(Y).^2)/N;
f = fs/N*n;
figure;
plot(f(1:N/2),Pyy(1:N/2));
title('Power spectral density (recording)');
xlabel('(n)');
