%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
clc

test_path = '../songs/tests/';
%% load or record the test song
user = input('record or load ? ', 's');
if strcmp(user, 'record')
    Fs = 44100;
    record_time = 10;
    mute = 1;
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
    name = input('name the file (without extension) :: ', 's');
    audiowrite(strcat(test_path,[name, '.wav']), S, Fs);
else
    file_name = 'satisfaction.wav';
    [S Fs] = audioread([test_path, file_name]);
end

%% load the different hmm from the data base
files_loc = '../songs/';
files = dir(files_loc);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

subFolders.name;
    ifolder = 1;
    song_name = cell( length(subFolders) );
for k = 1:length(subFolders)
    flag = 0;    
    folder = subFolders(k).name;
    if ~(strcmp(folder,'.') || strcmp(folder,'..') || strcmp(folder,'antoine') || strcmp(folder, 'tests') )
        hmm_path = sprintf('%s%s/',files_loc, folder);
        try 
        mat_path_tmp = cellstr( ls([hmm_path '*.mat']) );
        catch
            warning( sprintf('No .mat file in %s', hmm_path) );
            flag = 1;
        end
        if ~flag
        mat_path = mat_path_tmp{1,1};
            load(mat_path);
            hmms(ifolder) = trained;
            song_name{ifolder} = data_path;
            ifolder = ifolder + 1;
        end
        
    end
end
 

%% compute logprob for each hmm and figure out wich song was sung
hmms.logprob()
