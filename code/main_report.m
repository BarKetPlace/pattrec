%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all
% Recording/reading folder
path = '../songs/';

filename1 = 'melody_1.wav';
filename2 = 'melody_2.wav';
filename3 = 'melody_3.wav';

[S1, Fs1] = audioread(strcat(path,filename1));
[S2, Fs2] = audioread(strcat(path,filename2));
[S3, Fs3] = audioread(strcat(path,filename3));

frIsequence1 = GetMusicFeatures(S1, Fs1);
frIsequence2 = GetMusicFeatures(S2, Fs2);
frIsequence3 = GetMusicFeatures(S3, Fs3);

nbSamples1 = sum(size(S1))-1;
nbSamples2 = sum(size(S2))-1;
nbSamples3 = sum(size(S3))-1;

duree1 = nbSamples1/Fs1;
duree2 = nbSamples2/Fs2;
duree3 = nbSamples3/Fs3;

nb_Frames1 = size(frIsequence1, 2);
nb_Frames2 = size(frIsequence2, 2);
nb_Frames3 = size(frIsequence3, 2);

t1 = 0:duree1/nb_Frames1:duree1-1/nb_Frames1;
t2 = 0:duree2/nb_Frames2:duree2-1/nb_Frames2;
t3 = 0:duree3/nb_Frames3:duree3-1/nb_Frames3;


subplot(2,1,1)
plot(t1,frIsequence1(1,:));
hold on
plot(t2,frIsequence2(1,:),'r');
hold on
plot(t3,frIsequence3(1,:),'color','k','LineWidth',1);
title('Pitch');
xlabel('time (s)');
ylabel('pitch (Hz)');
legend('Melody1','Melody2','Melody3');
% axis([0 8 100 300]);

subplot(2,1,2)
plot(t1,frIsequence1(3,:));
hold on
plot(t2,frIsequence2(3,:),'r');
hold on
plot(t3,frIsequence3(3,:),'k');
title('Intensity');
xlabel('time (s)');
ylabel('Intensity');
axis([0 8 0 0.5]);
