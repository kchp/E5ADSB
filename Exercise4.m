%%  E5ADSB - Exercise 4 - Image processing
%%  Opgave beskrivelse
%   
%   Øvelse 1:
%   Billed smoothing med 2D lavpas filtre
%
%   Øvelse 2:
%   Billed sharpening ved brug af "the Laplacian" and "unsharp masking"
%
%   Øvelse 3:
%   Non-liniar filtrering - the Median Filter
%   
%% Setup
close all; clear; clc;

%% Øvelse 1
% 1. Indlæs billedet "test_pattern_blurring_orig.tif"
close all; clear; clc;
I = imread('test_pattern_blurring_orig.tif');

% 2. Prøv at smoothe med mean-filtre str. 3x3, 5x5, 9x9, 15x15 og 35x35.
% Brug imfilter().
I2 = im2double(I);

% 3x3 filter
I2a = imfilter(I2,ones(3)/9);

% 5x5 filter
I2b = imfilter(I2,ones(5)/25);

% 9x9 filter
I2c = imfilter(I2,ones(9)/81);

% 15x15 filter
I2d = imfilter(I2,ones(15)/225);

% 35x35 filter
I2e = imfilter(I2,ones(25)/1225);

% Vis resultater
figure;
subplot(2,3,1), imshow(I2), title('Original');
subplot(2,3,2), imshow(I2a), title('3 x 3');
subplot(2,3,3), imshow(I2b), title('5 x 5');
subplot(2,3,4), imshow(I2c), title('9 x 9');
subplot(2,3,5), imshow(I2d), title('15 x 15');
subplot(2,3,6), imshow(I2e), title('35 x 35');

% 3. Hvordan påvirker de forskellige filtre billedet?
% Jo større filtret er des mere bliver billedet "blurred"

% 4. Forklar hvad der sker ved kanten, og prøv de forskellige metoder til
% behandling af kanter, som beskrevet i Marques s. 212
% Ved billedets kant ligger en del af det anvendte filter udenfor selve
% billedet, dette resulterer i kant rundt om billedet der bliver bredere jo
% større filtret er. imfilter() har nogle indbyggede funktioner til at
% behandle kanten af billedet:

% Boundary options
I2X = imfilter(I2,ones(9)/81,0.5,'full');
I2rep = imfilter(I2,ones(9)/81,'replicate','full');
I2cir = imfilter(I2,ones(9)/81,'circular','full');
I2sym = imfilter(I2,ones(9)/81,'symmetric','full');

figure;
subplot(2,3,1), imshow(I2), title('Original');
subplot(2,3,2), imshow(I2c), title('9 x 9 (X = 0)');
subplot(2,3,3), imshow(I2X), title('X = 0.5');
subplot(2,3,4), imshow(I2rep), title('replicate');
subplot(2,3,5), imshow(I2cir), title('circular');
subplot(2,3,6), imshow(I2sym), title('symmetric');

% 5. Prøv at smoothe billedet med Gausian-Blur filter str. 3x3, 5x5, 9x9,
% 15x15 og 35x35. Brug forskellige værdier for sigma indenfor [1;10] og
% sammenlign med mean-flitre. Funktionen gauss_mask.m returnerer Gaussian
% mask koefficienterne.

% Implementer guassian filter
% 3x3 gaussian filter, sigma = 3
G1 = fspecial('gaussian',[3 3],2);
I2aG = imfilter(I2,G1,'replicate');

% 5x5 gaussian filter, sigma = 4
G2 = fspecial('gaussian',[5 5],4);
I2bG = imfilter(I2,G2,'replicate');

% 9x9 gaussian filter, sigma = 5
G3 = fspecial('gaussian',[9 9],5);
I2cG = imfilter(I2,G3,'replicate');

figure;
subplot(2,3,1), imshow(I2a), title('3 x 3');
subplot(2,3,2), imshow(I2b), title('5 x 5');
subplot(2,3,3), imshow(I2c), title('9 x 9');
subplot(2,3,4), imshow(I2aG), title('3 x 3, gaussian, sigma=3');
subplot(2,3,5), imshow(I2bG), title('5 x 5, gaussian, sigma=4');
subplot(2,3,6), imshow(I2cG), title('9 x 9, gaussian, sigma=5');


% 6. Indlæs billedet "noisyimage1.tif" og reducer støjen ved at anvende
% smoothing.
J = imread('noisyimage1.tif');
J2 = im2double(J);
JG1 = fspecial('gaussian',[5 5],1);
JG2 = fspecial('gaussian',[13 13],1);

J2G1 = imfilter(J2,JG1,'replicate');
J2G2 = imfilter(J2,JG2,'replicate');
J2G3 = imfilter(J2,ones(13)/169,'replicate');

figure;
subplot(2,2,1), imshow(J2), title('Original');
subplot(2,2,2), imshow(J2G1), title('Gaussian 5 x 5');
xlabel('\sigma = 1');
subplot(2,2,3), imshow(J2G3), title('Mean 13 x 13');
subplot(2,2,4), imshow(J2G2), title('Gaussian 13 x 13');
xlabel('\sigma = 1');


%% Øvelse 2
% 1. Indlæs billedet "moon.tif"
close all; clear; clc;
K = imread('moon.tif');


% 2. Implementer masken brugt til the Laplacian i Marques kap. 10.4.1 s.
% 219 (prøv begge, hvad er forskellen?).
lap1 = [0 -1 0;-1 4 -1;0 -1 0];     % Filter 1
lap2 = [-1 -1 -1;-1 8 -1;-1 -1 -1]; % Filter 2
clap = [0 -1 0;-1 5 -1;0 -1 0];     % Filter 3

% 3. Sharpen måne billedet ved at adderer the Laplacian af billedet til det
% originale billede: g(x,y)=f(x,y)+c*V^2(x,y), hvor c=+-1, V=the laplacian
% (Marques formel 10.16).
K2 = im2double(K);
K2L1 = K2+imfilter(K2,lap1,'replicate');
K2L_1 = K2+(-1)*imfilter(K2,lap1,'replicate');
K2L2 = K2+imfilter(K2,lap2,'replicate');
K2L_2 = K2+(-1)*imfilter(K2,lap2,'replicate');
K2CL = K2+imfilter(K2,clap,'replicate');
K2CL_ = K2+(-1)*imfilter(K2,clap,'replicate');

% 4. Vis resultaterne
figure('Name','Original Image');
imshow(K), title('Original');
figure('Name','The Laplacian');
subplot(2,3,1), imshow(K2L1), title('Filter 1 (c = 1)');
xlabel('4 neighbours');
subplot(2,3,4), imshow(K2L_1), title('Filter 1 (c = -1)');
subplot(2,3,2), imshow(K2L2), title('Filter 2 (c = 1)');
xlabel('8 neighbours');
subplot(2,3,5), imshow(K2L_2), title('Filter 2 (c = -1)');
subplot(2,3,3), imshow(K2CL), title('Filter 3 (c = 1)');
xlabel('Composite Laplacian');
subplot(2,3,6), imshow(K2CL_), title('Filter 3 (c = -1)');

% 5. Prøv at sharpening billedet med "unsharp-masking". Teknikken til dette:
%    a. Slør original billedet
%    b. Træk det slørede billede fra original billedet. Resultatet kaldes
%       masken: g_mask(x,y) = f(x,y)-f_slør(x,y)
%    c. Adder masken til original billedet: g(x,y) = f(x,y)+k*g_mask(x,y),
%       hvor k er en vægtet faktor. Prøv først med k=1.
hG = fspecial('gaussian',[7 7],1);
K2blur = imfilter(K2,hG,'replicate');
K2mask = K2-K2blur;
K2u1 = K2+1*K2mask;
K2u2 = K2+0.5*K2mask;
K2u3 = K2+2*K2mask;

% 6. Vis resultaterne. Prøv med forskellige værdier af k
figure('Name','Unsharp-masking');
subplot(2,2,1), imshow(K2), title('Original');
subplot(2,2,2), imshow(K2u1), title('k = 1');
subplot(2,2,3), imshow(K2u2), title('k = 0.5');
subplot(2,2,4), imshow(K2u3), title('k = 2');


%% Øvelse 3
% 1. Implementer et 3x3 eller 5x5 (eller MxM) median filter som en function
% i Matlab.
close all; clear; clc;


% 2. Brug filtret til at reducere "salt & pepper noise" i billedet
% "noisyimage2.tif".
L = imread('noisyimage2.tif');


% 3. Sammenlign median filtret med smoothign filtret til reducering af
% "salt & pepper noise".


