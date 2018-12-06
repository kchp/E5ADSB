% Når der er nogen der skal lytte til filerne, skal hver enkelt blok blot
% afvikles individuelt

[Recorded_chirp,Fschirp] = audioread('RecLinChirp.wav');
LMS_chirp = audioread('LMS_chirp.wav');
[Simulated_music,Fsmusic] = audioread('Simulated_music.wav');
LMS_music = audioread('LMS_music.wav');

%% Afspil optaget chirp

soundsc(Recorded_chirp,Fschirp);

%% Afspil LMS filtreret chirp

soundsc(LMS_chirp,Fschirp);

%% Afspil simuleret musik

soundsc(Simulated_music,Fsmusic);

%% Afspil LMS filtreret musik

soundsc(LMS_music,Fsmusic);
