%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
%   
%% Setup
close all; clear; clc;

[noise, fs] = audioread('RecNoise.wav'); % indlæs hvidstøjssignal og samplerate
chirp = audioread('RecChirp.wav');       % indlæs chirp signal
linchirp = audioread('RecLinChirp.wav'); % indlæs chirp signal

N = fs;
n = 0:N-1;

%%