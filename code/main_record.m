%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all

data_path = '../songs/highwaytohell/';% Recording folder
mute = 1; % Listen to the recording or not
record_time = 10;% How long do you want to record? (in seconds)

nfiles = length(dir(fullfile([data_path '*.wav'])));
starting_point = nfiles; %The first saved file will have this number

Fs=44200;
recObj = audiorecorder(Fs, 16, 1);
user = 'yes';
i=starting_point;
while strcmp(user, 'yes')
    recObj = audiorecorder(Fs, 16, 1);
    fprintf('Recording in :: 3'); pause(1);
    fprintf('\b2'); pause(1);
    fprintf('\b1'); pause(1);
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!\n');
    recordblocking(recObj, record_time);

    S = getaudiodata(recObj);
    Fs = recObj.SampleRate;
    if ~mute
        recObj.play;
    end

    audiowrite(strcat(data_path,[sprintf('%0.2i',i), '.wav']), S, Fs);
    fprintf('You just saved %s%02i.wav \n',data_path, i);
    user = input('You want to record another one ? yes or no :: ', 's');
    i=i+1;
    clc
end