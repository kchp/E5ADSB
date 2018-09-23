%%  E5ADSB Exercise 5 - Morphological image processing
%%  Opgave beskrivelse
%  
%   Øvelse 1 - Erosion
%   Arbejd med den fundamentale morphological operation "erosion"
%
%   Øvelse 2 - Dilation
%   Arbejd med den fundamentale morphological operation "dilation"
%
%   Øvelse 3 - Opening
%   Arbejd med den sammensatte morphological operation "opening", som er
%   erosion efterfulgt af dilation
%
%   Øvelse 4 - closing
%   Arbejd med den sammensatte morphological operation "closing", som er
%   dilation efterfulgt af erosion
%  
%   Øvelse 5 - Mophological filtering
%   Formålet med morphological filtering i denne øvelse, er at eliminere
%   støj i et binært billed og forvrænge det så lidt som muligt
%  
%   Øvelse 6 - Extraction and labelling of connected components
%   Morphological operation kan anvendes til at udtage og navngive
%   forbundne komponenter i et binært billed
%   
%% Setup
close all; clear; clc;

%% Øvelse 1
close all; clear; clc;
% 1. Skab et binært billed og struktur element (SE)
I = [0 0 0 0 0 0 0 0;...
     0 1 1 1 1 1 0 0;...
     0 1 1 1 1 1 0 0;...
     0 0 1 1 1 1 0 0;...
     0 0 1 1 1 1 0 0;...
     0 0 0 0 0 0 0 0];

SE = [0 1 0;1 1 1;0 1 0];

% 2. Erode billedet med SE, brug imerode(), og vis billedet og de eroderede
%    billede i samme figur med subplot(). 0 skulle være en sort pixel og 1
%    skulle være en hvid pixel. Bemærk hvordan erosion "shrinks" eller
%    "thins" objektet i billedet.
I2 = imerode(I,SE);
figure('Name','Image erosion 1');
subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(I2), title('Eroded image');

% 3. prøv nu med det kvadratiske SE 3x3 ones(3). Forklar forskellen.
I3 = imerode(I,ones(3));
figure('Name','Image erosion 2');
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(I2), title('Eroded image');
subplot(1,3,3), imshow(I3), title('Eroded (3x3, ones())');
% Denne form for erosion fjerne den lille "tap" der er i billedets venstre
% side, så det bliver til et kvadrat.

% 4. Indlæs billedet "wirebond-mask.tif" og vis det
J = imread('wirebond-mask.tif');
figure('Name','Billed øvelse 1');
imshow(J), title('Original');

% 5. Skab et kvadratisk SE på 11x11 (du kan bruge ones() eller
% strel('square',11)), og anvend det til at erodere det bilære billede. Vis
% resultatet og forklar.
SE2 = strel('square',11);
J2 = imerode(J,SE2);
figure('Name','SE = 11x11');
subplot(1,2,1), imshow(J), title('Original');
subplot(1,2,2), imshow(J2), title('Eroded (11x11, ones())');
% Alle de tynde/skræ linjer er forsvundet på det eroderede billede

% 6. Ændre størrelsen på SE til 15x15 og 45x45 og eroder igen. Forklar.
SE3 = strel('square',15);
SE4 = strel('square',45);
J3 = imerode(J,SE3);
J4 = imerode(J,SE4);
figure('Name','Different size SE');
subplot(2,2,1), imshow(J), title('Original');
subplot(2,2,2), imshow(J2), title('[11x11]');
subplot(2,2,3), imshow(J3), title('[15x15]');
subplot(2,2,4), imshow(J4), title('[45x45]');
% Ved at gøre SE større forminskes elementerne i billedet mere og
% forsvinder helt i det sidste billede.


%% Øvelse 2
close all; clear; clc;
% 1. Skab et binært billed og struktur element (SE)
I = [0 0 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0;...
     0 0 1 1 0 0 0 0;...
     0 0 1 1 0 0 0 0;...
     0 0 0 0 0 0 0 0];
%I = zeros(6); I(4:3,3:4)=1; % alternativ måde at skabe I

SE = [0 1 0;1 1 1;0 1 0];

% 2. Dilate billedet med SE, anvend imdilate(), vis billedet og det
% dilaterede billede i samme figur.
I2 = imdilate(I,SE);
figure('Name','Image dilation 1');
subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(I2), title('Dilated image');
% Dilate forøger størrelsen af billedet i alle retninger, hvilket kan ses
% da firkanten i original billedet er blevet til et kors.

% 3. Indlæs det binære billed "text_gaps_1_and_2_pixels.tif" og vis det
J = imread('text_gaps_1_and_2_pixels.tif');
figure('Name','Billed øvelse 2');
imshow(J), title('Original');

% 4. Dilate det nye billede med SE og vis resultatet
J2 = imdilate(J,SE);
figure('Name','Image 2, dilation');
subplot(1,2,1), imshow(J), title('Original');
subplot(1,2,2), imshow(J2), title('Dilated image');

% 5. Bemærk hvordan dilation kan anvendes til at lukke huller i bogstaver.
%    Et lignenden resultat kunne opnås ved at lavpas filtrering efterfulgt
%    af thresholding.


%% Øvelse 3
close all; clear; clc;
% 1. Indlæs det støjfyldte test billede "opening_testimage1.tif". Vis
%    billedet. Hvormange objekter er der i billedet?
I = imread('opening_testimage1.tif');
figure('Name','Billed øvelse 3');
imshow(I), title('Original');
% Der er 2 objekter i billedet

% 2. Åben billedet med et kvadratisk SE og vis resultatet. Su skulle få et
%    billed som det viste. Hvad er den mindste størrelse af SE?
I2 = imopen(I,strel('square',15));
I3 = imopen(I,strel('square',10));
I4 = imopen(I,strel('square',5));
I5 = imopen(I,strel('square',4));
I6 = imopen(I,strel('square',3));
figure('Name','Opening med foskellige SE');
subplot(2,3,1), imshow(I), title('Original');
subplot(2,3,2), imshow(I2), title('SE = 15x15');
subplot(2,3,3), imshow(I3), title('SE = 10x10');
subplot(2,3,4), imshow(I4), title('SE = 5x5');
subplot(2,3,5), imshow(I5), title('SE = 4x4');
subplot(2,3,6), imshow(I6), title('SE = 3x3');
% Et 4x4 SE er det mindste der kan anvendes til at fjerne støjen og
% linjerne.

% 3. Forklar hvorfor opening, åbner huller eller forbindelser mellem
%    objekter og fjerne tynde afstikkere.


% 4. Prøv et cirkulært SE og forklar forskellen. Tip: brug strel('disk',R).
Icir = imopen(I,strel('disk',4));

figure('Name','Cirkulært vs. Square SE');
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(I4), title('Square 4x4');
subplot(1,3,3), imshow(Icir), title('Circular R=4');
% Det cirkulære SE gør alle skarpe kanter runde, dette kan ses i alle
% hjørnerne af de 2 objekter.


%% Øvelse 4
close all; clear; clc;
% 1. Indlæs billedet "closing_testimage1.tif". Vis billedet.
I = imread('closing_testimage1.tif');
figure('Name','Original');
imshow(I), title('Original');

% 2. Close billeder med et kvadratist SE og vis resultatet
I2 = imclose(I,strel('square',15));
I3 = imclose(I,strel('square',10));
I4 = imclose(I,strel('square',5));
I5 = imclose(I,strel('square',4));
I6 = imclose(I,strel('square',3));
figure('Name','Closing med foskellige SE');
subplot(2,3,1), imshow(I), title('Original');
subplot(2,3,2), imshow(I2), title('SE = 15x15');
subplot(2,3,3), imshow(I3), title('SE = 10x10');
subplot(2,3,4), imshow(I4), title('SE = 5x5');
subplot(2,3,5), imshow(I5), title('SE = 4x4');
subplot(2,3,6), imshow(I6), title('SE = 3x3');
% Som det kan ses på billedet skal der mindst anvendes et 5x5 SE for at få
% lukket linjen i højre side (husk at sætte figuren i fuldskærm!)

% 3. Forklar hvorfor closing har tendens til at udfylde små huller og lukke
%    tynde streger uden at ændre objektets størrelse.


%% Øvelse 5
close all; clear; clc;
% 1. Indlæs billedet "noisy_fingerprint.tif" og vis det
I = imread('noisy_fingerprint.tif');
figure('Name','noisy_fingerprint.tif');
subplot(2,3,1), imshow(I), title('Original');

% 2. Skab et 3x3 SE af ones()
SE = ones(3);

% 3. Eroder billedet med SE og vis det
I2 = imerode(I,SE);
subplot(2,3,2), imshow(I2), title('Eroded');

% 4. Dilate det eroderede billed (opening af original billedet) og vis det
I2open = imdilate(I2,SE);
subplot(2,3,3), imshow(I2open), title('Eroded/Dilated');

% 5. Dilate det dilaterede billede (dilation af opening) og vis det
I2dil = imdilate(I2open,SE);
subplot(2,3,4), imshow(I2dil), title('Eroded/Dilated/Dilated');

% 6. Erode det dilaterede billede (closing af opening) og vis det
I2ero = imerode(I2dil,SE);
subplot(2,3,5), imshow(I2ero), title('Eroded/Dilated/Dilated/Eroded');

% 7. Forklar
% Først eroderes billedet dette fjerner støjen der ses rundt om
% fingeraftrykket men linjerne fra finger aftrykket gøres samtidigt mindre.
% Andet skridt forstørre linjerne i fingeraftrykket tilbage til oprindelig
% størrelse og udfylder samtigt nogle af hullerne i disse. Tredje skridt
% forøger igen fingeraftrykkets linjer og udfylder hullerne i disse
% fuldstændigt, men nu er linjerne dobbelt tykkelse. Sidste skridt bringer
% fingeraftrykkets linjer tilbage til oprindelig størrelse igen.


%% Øvelse 6
close all; clear; clc;


