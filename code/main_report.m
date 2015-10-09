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

scaling_f = Fs1;
t = 0:1/Fs1:nbSamples1/Fs1-1/Fs1;


subplot(3,1,1)
plot(t,frIsequence1(1,1:nbSamples1/2));