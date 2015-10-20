%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all

path = '../songs/';% Recording folder
mute = 1; % Listen to the recording or not
record_time = 8;% How long do you want to record? (in seconds)
starting_point = 10; %The first saved file will have this number

Fs=44200;
recObj = audiorecorder(Fs, 16, 1);
user = 'no';
i=starting_point;
while strcmp(user, 'no')
    recObj = audiorecorder(Fs, 16, 1);
    fprintf('Record in :: 3'); pause(1);
    fprintf('\b2'); pause(1);
    fprintf('\b1'); pause(1);
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!\n')
    recordblocking(recObj, record_time);

    S = getaudiodata(recObj);
    Fs = recObj.SampleRate;
    if ~mute
        recObj.play;
    end
    audiowrite(strcat(path,[int2str(i) '.wav']), S, Fs);
    user = input('You want to record another one ? yes or no :: ', 's');
    i=i+1;
end
