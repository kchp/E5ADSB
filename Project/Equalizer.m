%%  E5ADSB projekt
%%  Opgave beskrivelse
%  
%   
%% Setup
close all; clear; clc;

[noise, fs] = audioread('RecNoise.wav'); % indl�s hvidst�jssignal og samplerate
chirp = audioread('RecChirp.wav');       % indl�s chirp signal
linchirp = audioread('RecLinChirp.wav'); % indl�s chirp signal

N = fs;
n = 0:N-1;

%%