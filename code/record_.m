% function [ S Fs ] = record_( record_time, mute,test_path)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

function [ S Fs ] = record_( record_time, mute,test_path, name)

    Fs = 44100;
    
    recObj = audiorecorder(Fs, 16, 1);
    
    fprintf('Recording in :: 3\n'); pause(1);
    fprintf('\b\b2\n'); pause(1);
    fprintf('\b\b1\n'); pause(1);
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!\n');
    recordblocking(recObj, record_time);
    S = getaudiodata(recObj);
    Fs = recObj.SampleRate;
    if ~mute
        recObj.play;
    end
%     name = input('name the file (without extension) :: ', 's');
    audiowrite(strcat(test_path,name), S, Fs);

end

