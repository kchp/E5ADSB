%%  E5ADSB Exercise 5 - Morphological image processing
%%  Opgave beskrivelse
%  
%   �velse 1 - Erosion
%   Arbejd med den fundamentale morphological operation "erosion"
%
%   �velse 2 - Dilation
%   Arbejd med den fundamentale morphological operation "dilation"
%
%   �velse 3 - Opening
%   Arbejd med den sammensatte morphological operation "opening", som er
%   erosion efterfulgt af dilation
%
%   �velse 4 - closing
%   Arbejd med den sammensatte morphological operation "closing", som er
%   dilation efterfulgt af erosion
%  
%   �velse 5 - Mophological filtering
%   Form�let med morphological filtering i denne �velse, er at eliminere
%   st�j i et bin�rt billed og forvr�nge det s� lidt som muligt
%  
%   �velse 6 - Extraction and labelling of connected components
%   Morphological operation kan anvendes til at udtage og navngive
%   forbundne komponenter i et bin�rt billed
%   
%% Setup
close all; clear; clc;

%% �velse 1
close all; clear; clc;
% 1. Skab et bin�rt billed og struktur element (SE)
I = [0 0 0 0 0 0 0 0;...
     0 1 1 1 1 1 0 0;...
     0 1 1 1 1 1 0 0;...
     0 0 1 1 1 1 0 0;...
     0 0 1 1 1 1 0 0;...
     0 0 0 0 0 0 0 0];

SE = [0 1 0;1 1 1;0 1 0];

% 2. Erode billedet med SE, brug imerode(), og vis billedet og de eroderede
%    billede i samme figur med subplot(). 0 skulle v�re en sort pixel og 1
%    skulle v�re en hvid pixel. Bem�rk hvordan erosion "shrinks" eller
%    "thins" objektet i billedet.
I2 = imerode(I,SE);
figure('Name','Image erosion 1');
subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(I2), title('Eroded image');

% 3. pr�v nu med det kvadratiske SE 3x3 ones(3). Forklar forskellen.
I3 = imerode(I,ones(3));
figure('Name','Image erosion 2');
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(I2), title('Eroded image');
subplot(1,3,3), imshow(I3), title('Eroded (3x3, ones())');
% Denne form for erosion fjerne den lille "tap" der er i billedets venstre
% side, s� det bliver til et kvadrat.

% 4. Indl�s billedet "wirebond-mask.tif" og vis det
J = imread('wirebond-mask.tif');
figure('Name','Billed �velse 1');
imshow(J), title('Original');

% 5. Skab et kvadratisk SE p� 11x11 (du kan bruge ones() eller
% strel('square',11)), og anvend det til at erodere det bil�re billede. Vis
% resultatet og forklar.
SE2 = strel('square',11);
J2 = imerode(J,SE2);
figure('Name','SE = 11x11');
subplot(1,2,1), imshow(J), title('Original');
subplot(1,2,2), imshow(J2), title('Eroded (11x11, ones())');
% Alle de tynde/skr� linjer er forsvundet p� det eroderede billede

% 6. �ndre st�rrelsen p� SE til 15x15 og 45x45 og eroder igen. Forklar.
SE3 = strel('square',15);
SE4 = strel('square',45);
J3 = imerode(J,SE3);
J4 = imerode(J,SE4);
figure('Name','Different size SE');
subplot(2,2,1), imshow(J), title('Original');
subplot(2,2,2), imshow(J2), title('[11x11]');
subplot(2,2,3), imshow(J3), title('[15x15]');
subplot(2,2,4), imshow(J4), title('[45x45]');
% Ved at g�re SE st�rre forminskes elementerne i billedet mere og
% forsvinder helt i det sidste billede.


%% �velse 2
close all; clear; clc;
% 1. Skab et bin�rt billed og struktur element (SE)
I = [0 0 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0;...
     0 0 0 0 0 0 0 0;...
     0 0 1 1 0 0 0 0;...
     0 0 1 1 0 0 0 0;...
     0 0 0 0 0 0 0 0];
%I = zeros(6); I(4:3,3:4)=1; % alternativ m�de at skabe I

SE = [0 1 0;1 1 1;0 1 0];

% 2. Dilate billedet med SE, anvend imdilate(), vis billedet og det
% dilaterede billede i samme figur.
I2 = imdilate(I,SE);
figure('Name','Image dilation 1');
subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(I2), title('Dilated image');
% Dilate for�ger st�rrelsen af billedet i alle retninger, hvilket kan ses
% da firkanten i original billedet er blevet til et kors.

% 3. Indl�s det bin�re billed "text_gaps_1_and_2_pixels.tif" og vis det
J = imread('text_gaps_1_and_2_pixels.tif');
figure('Name','Billed �velse 2');
imshow(J), title('Original');

% 4. Dilate det nye billede med SE og vis resultatet
J2 = imdilate(J,SE);
figure('Name','Image 2, dilation');
subplot(1,2,1), imshow(J), title('Original');
subplot(1,2,2), imshow(J2), title('Dilated image');

% 5. Bem�rk hvordan dilation kan anvendes til at lukke huller i bogstaver.
%    Et lignenden resultat kunne opn�s ved at lavpas filtrering efterfulgt
%    af thresholding.


%% �velse 3
close all; clear; clc;
% 1. Indl�s det st�jfyldte test billede "opening_testimage1.tif". Vis
%    billedet. Hvormange objekter er der i billedet?
I = imread('opening_testimage1.tif');
figure('Name','Billed �velse 3');
imshow(I), title('Original');
% Der er 2 objekter i billedet

% 2. �ben billedet med et kvadratisk SE og vis resultatet. Su skulle f� et
%    billed som det viste. Hvad er den mindste st�rrelse af SE?
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
% Et 4x4 SE er det mindste der kan anvendes til at fjerne st�jen og
% linjerne.

% 3. Forklar hvorfor opening, �bner huller eller forbindelser mellem
%    objekter og fjerne tynde afstikkere.


% 4. Pr�v et cirkul�rt SE og forklar forskellen. Tip: brug strel('disk',R).
Icir = imopen(I,strel('disk',4));

figure('Name','Cirkul�rt vs. Square SE');
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(I4), title('Square 4x4');
subplot(1,3,3), imshow(Icir), title('Circular R=4');
% Det cirkul�re SE g�r alle skarpe kanter runde, dette kan ses i alle
% hj�rnerne af de 2 objekter.


%% �velse 4
close all; clear; clc;
% 1. Indl�s billedet "closing_testimage1.tif". Vis billedet.
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
% Som det kan ses p� billedet skal der mindst anvendes et 5x5 SE for at f�
% lukket linjen i h�jre side (husk at s�tte figuren i fuldsk�rm!)

% 3. Forklar hvorfor closing har tendens til at udfylde sm� huller og lukke
%    tynde streger uden at �ndre objektets st�rrelse.


%% �velse 5
close all; clear; clc;
% 1. Indl�s billedet "noisy_fingerprint.tif" og vis det
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
% F�rst eroderes billedet dette fjerner st�jen der ses rundt om
% fingeraftrykket men linjerne fra finger aftrykket g�res samtidigt mindre.
% Andet skridt forst�rre linjerne i fingeraftrykket tilbage til oprindelig
% st�rrelse og udfylder samtigt nogle af hullerne i disse. Tredje skridt
% for�ger igen fingeraftrykkets linjer og udfylder hullerne i disse
% fuldst�ndigt, men nu er linjerne dobbelt tykkelse. Sidste skridt bringer
% fingeraftrykkets linjer tilbage til oprindelig st�rrelse igen.


%% �velse 6
close all; clear; clc;


