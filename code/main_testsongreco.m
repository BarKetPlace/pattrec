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

% load the different hmm from the available data base
fprintf('Loading hmms ...\n');
files_loc = '../songs/';
[ hmms ] = load_hmms( files_loc );
fprintf('\b\b\b\bcompleted (%d hmms are loaded).\n', length(hmms));
% launch recognition system
[pathRes, probRes] = songreco(hmms, user_mode, file_name);
fprintf('Result :: %s\n',pathRes);

% is it the right result
if strcmp(user_mode,'load')
    res = findstr(file_name(1:end-7), pathRes);
    if res
        good = good + 1;
    end
end


