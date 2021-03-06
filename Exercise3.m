%%  E5ADSB Exercise 3 - Image Processing
%%  Opgave beskrivelse
%  
%   �velse 1:
%   Arbejde med grey scale billeder i Matlab
%
%   �velse 2:
%   Arbejde med farve billeder i Matlab
%
%   �velse 3:
%   Billede forbedringer ved at bruge basis point transformation
%   
%% Setup
close all; clear; clc;

%% �velse 1
% 1. Indl�s billede
I = imread('cameraman.tif');

% 2. Hvad er st�rrelsen og data type af I og hvor mange bytes tager det i
%    hukommelsen? Forklar.
disp('Information om grey scale billedets original format');
whos I;

% Billedet er indl�st som et 256x256 matrix, med data typen uint8 - 8-bit
% unsigned intergers, det optager 65536 bytes i hukommelsen.

% 3. Vis billedet
% begge disse muligheder kan anvendes til at vise billedet
imshow(I);
title('Original image');
%imtool(I);

% 4. Find min og max pixel v�rdi i billedet

disp('Find minimum og maximum pixel v�rdi i billedet');
maximum = max(max(I));
[xmax,ymax] = find(I==maximum);
disp(['max v�rdi = ' num2str(maximum)]);
disp(['index = [' num2str(xmax) ',' num2str(ymax) ']']);

% find minimum
minimum = min(min(I));
[xmin,ymin] = find(I==minimum);
disp(['min v�rdi = ' num2str(minimum)]);
disp(['index = [' num2str(xmin(1)) ',' num2str(ymin(1)) ']'...
     ', [' num2str(xmin(2)) ',' num2str(ymin(2)) ']'...
     ', [' num2str(xmin(3)) ',' num2str(ymin(3)) ']'...
     ', [' num2str(xmin(4)) ',' num2str(ymin(4)) ']']);

% 5. Konverter billedet fra uint8 til doubles i range [0;1]
I2 = im2double(I);
disp('Information om billedet efter konvertering til double');
whos I2;

% 6. Hvad er resultatet af:
%   a. adderer en positiv konstant (skalar) til billedet?
I2add = I2 + 0.25;
figure;
subplot(1,2,1), imshow(I);
title('Original image');
subplot(1,2,2), imshow(I2add);
title('Increased brightness');
% Ved at adderer en skalar bliver billedet lysere.
% N�r en v�rdi ligges til/tr�kkes fra et billede �ndres ved billedets
% brigtness!

%   b. tr�kke en positiv konstant (skalar) fra billedet?
I2sub = I2 - 0.25;
figure;
subplot(1,2,1), imshow(I);
title('Original image');
subplot(1,2,2), imshow(I2sub);
title('Decreased brightness');
% Ved at tr�kke en skalar fra, bliver billedet m�rkere (brightness)

%   c. gange billedet med en positiv konstant st�rre end 1?
I2m1 = I2.*1.25;
figure;
subplot(1,2,1), imshow(I);
title('Original image');
subplot(1,2,2), imshow(I2m1);
title('Increased contrast');
% Ved at gange med en skalar st�rre end 1 �ges kontrasten i billedet, de lyse
% farver bliver tydeligere og de m�rke forbliver n�sten uber�rt.
% N�r et billede bliver ganget med en v�rdi �ndres ved billedets kontrast!

%   d. gange billedet med en positiv konstant mindre end 1?
I2m2 = I2.*0.25;
figure;
subplot(1,2,1), imshow(I);
title('Original image');
subplot(1,2,2), imshow(I2m2);
title('Decreased contrast');
% Ved at gange med en skalar mindre end 1 s�nkes kontrasten i billedet, de lyse
% farver bliver m�rkere og de m�rke forbliver n�sten uber�rt (kontrast)

% 7. Beregn billedets negativ. Vis det i samme figur som det originale med
%    subplot
I2neg = -I2 + 1.0;
figure;
subplot(1,2,1), imshow(I);
title('Original image');
subplot(1,2,2), imshow(I2neg);
title('Negative image');

% 8. Konverter det negative billede til uint8 og gem det som en fil med
%    imwrite()
Ineg = uint8(255*mat2gray(I2neg));
imwrite(Ineg,'cameraman_negative.tif','tiff');

% 9. Lav et udsnit af billedet I (50x50 pixels), der indeholder
%    kameramandens hoved
Iface = I2(35:85,90:140);
figure, imshow(Iface);
title('Cropped image');

% 10. Formindsk det originale billede til halv st�rrelse i begge retninger,
%     ved at tage hver anden pixel i begge retninger. Vis og gem billedet
Ismall = I2(1:2:end,1:2:end);
figure, imshow(Ismall);
title('Half-sized image');


%% �velse 2
% 1. Indl�s billed
J = imread('pepperswithsquares.bmp');

% 2. Hvad er st�rrelse og data type for billedet?
disp('Information om farve billedets original format');
whos J;
% Billedet er et matrix med st�rrelse 384x512x3 af data typen uint8.

% 3. Tr�k r�d gr�n og bl� komponenter fra billedet og vis dem som grey
%    scale billeder i subplots som i figur 2.4, s. 25 i Marques. Forklar.
Jred = J(:,:,1);
Jgreen = J(:,:,2);
Jblue = J(:,:,3);
figure, subplot(2,2,1); imshow(J), title('Original image');
subplot(2,2,2); imshow(Jred), title('Red');
subplot(2,2,3); imshow(Jgreen), title('Green');
subplot(2,2,4); imshow(Jblue), title('Blue');
% Arrayet for hver farve indeholder en 8-bit v�rdi for hvormeget af farven
% der skal anvendes i det punkt, angivet i skalen [0:255]. Da det er 8-bit
% l�ses dette som gr�skala farve. F�rst n�r alle 3 farver kombineres til
% 24-bit angiver de en v�rdi der svare til 16M farve scalaen.

% 4. Konverter det originale billede til gr�skala ved at tage
%    middelv�rdien (mean) af alle tre farve lag.
%Jgrey = rgb2gray(J); % indbygget RGB-til-gr�skala
Jgrey = mean(double(J)/255,3);
figure, imshow(Jgrey), title('Grey scale convertion');


%% �velse 3
% 1. Indl�s billed
K = imread('washed_out_aerial_image.tif');

% 2. Vis billedet
figure, imshow(K), title('Original image');

% 3. Find og vis histogrammet for billedet med imhist(). Forklar.
figure, imhist(K), title('Image histogram');
% Histogrammet viser at der er en tydelig overv�gt af lyse farver i
% billedet.

% 4. Anvend Power Law Tranformation (ogs� kaldet gamma korrektion), se
%    Marques kapitel 8.3.3. Eksperimenter med forskellige v�rdier af y
%    indenfor [1:10]. Hvilken er bedst?
Kd = im2double(K);

Kd1 = Kd.^2.5;
Kd2 = Kd.^4.8;
Kd3 = Kd.^7.3;
figure, subplot(2,2,1), imshow(Kd), title('Original');
subplot(2,2,2), imshow(Kd1), title('\gamma = 2.5');
subplot(2,2,3), imshow(Kd2), title('\gamma = 4.8');
subplot(2,2,4), imshow(Kd3), title('\gamma = 7.3');
% Det bedste resultat af gamme korrektion ser ud til at v�re mellem
% [2.5:4.8]
Kdoptimum = Kd.^3.3;
figure, imshow(Kdoptimum), title('Bedste gamme korrektion');

% 5. Vis histogrammet for det forbedrede billede
figure, imhist(Kdoptimum), title('Image histogram');
% Histogrammet for det optimerede billede viser at farverne nu er mere
% lige fordelt over hele farve spektret.

% 6. Pr�v ogs� v�rdier af y indenfor [0:1]. Forklar.
Kdl1 = Kd.^0.2;
Kdl2 = Kd.^0.5;
Kdl3 = Kd.^0.8;
figure, subplot(2,2,1), imshow(Kd), title('Original');
subplot(2,2,2), imshow(Kdl1), title('\gamma = 0.2');
subplot(2,2,3), imshow(Kdl2), title('\gamma = 0.5');
subplot(2,2,4), imshow(Kdl3), title('\gamma = 0.8');
% N�r der anvendes en gamma v�rdi der er lavere end 1 �ges intensiteten af
% de lyse farve jo lavere v�rdi der anvendes, som det kan ses giver v�rdien
% p� 0.2 det v�rste resultat

