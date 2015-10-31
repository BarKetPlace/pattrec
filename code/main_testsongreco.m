%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
clc


files_loc = '../songs/';

files = dir(files_loc);
% Get a logical vector that tells which one is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
file_name = 'concerninghobbits_00.wav';
user_mode = 'load';
good=0;
% launch recognition system
[hmms, pathRes, probRes] = songreco(user_mode, file_name);

% is it the right result
if strcmp(user_mode,'load')
    res = findstr(file_name(1:end-7), pathRes);
    if res
        good = good+1;
    end
end


