%% Wiener Exercise 2 - Channel equalization
% KPL 2018-09-06
clear; close all; clc; format compact

%% the input signal
signal = 2; % choose 1 or 2
switch signal
    case 1
        % Random white noise signal ---
        N   = 10000;
        ss2 = 1; % variance of s(n)
        s   = sqrt(ss2)*randn(1,N);
    case 2
        % Music signal ---
        [s,Fs] = audioread('03 When It Comes To You_11s.wav');
        s = s';
        N = length(s);
    otherwise
        why
end

n=0:N-1;

%% the channel:
alpha = 0.8;
a = [1 -alpha];
gain = 1;
x = filter(gain,a,s);

d = s; % desired signal

%% Wiener solution
M = 3; % Filter size

rx = xcorr(x,M-1)/N;
Rx = toeplitz(rx(M:end)); % autocorrelation matrix

rdx = xcorr(d,x,M-1)/N;
pdx = rdx(M:end)';        % cross-correlation vector

wo = Rx\pdx;              % Optimum Wiener filter cooefficients

%% apply equalizer
y = filter(wo,1,x);       % Filter "received" signal 

disp('Wiener coefficients for equalizer:'), disp(wo)

Jmin=var(d)-pdx'*wo;
disp('MMSE = '), disp(Jmin)

%% Power spectrum
if signal == 1
    [Sx,~]=pwelch(x',512,256);
    [Sy,w]=pwelch(y',512,256);
    figure
    plot(w,10*log10(Sx/2),w,10*log10(Sy/2))
    xlim([0 pi])
    title('PSD estimate, Welch''s method')
    xlabel('\omega'), ylabel('dB')
    legend('S_x(\omega)','S_y(\omega)')
    grid
    disp('Note the equalization (whitening) effect')
end

%% play sound
if signal == 2
    soundsc(x,Fs);
    pause(N/Fs)
    soundsc(y,Fs);
%     figure
%     plot(n/Fs,s,n/Fs,x,n/Fs,y,'--')
%     legend('Original','Received','Equalized')    
end


