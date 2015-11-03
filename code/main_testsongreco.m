%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
clc

test_path = '../songs/tests/';
database = '../songs/';
user_mode = 'load';
record_name = 'whatever.wav';
%Usefull if user_mode = 'record',
%the file name MUST have the same name as the folder in the database
%followed by _xx.wav where xx is a double digit integer (00,
%01,02,03...10,11,...files = dir(files_loc);
files_loc = '../songs/';

files = dir(files_loc);
% Get a logical vector that tells which one is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolders = {subFolders.name};
j=1;
for i = 1:length(subFolders)
    if (strcmp(subFolders(i),'.') || strcmp(subFolders(i),'..') || strcmp(subFolders(i),'demo')|| strcmp( subFolders(i),'tests') )
    else
        subF(j) = subFolders(i); j = j + 1;
    end
end
nfiles = length(dir(fullfile([test_path '*_*.wav'])));
list_file = dir(fullfile(test_path));
list_file = {list_file.name};
%% load the different hmm from the available data base
fprintf('Loading hmms ...\n');
files_loc = '../songs/';
hmm_name = 'trained_hmm3.mat';
[ hmms ] = load_hmms( files_loc,hmm_name );
fprintf('\b\b\b\bcompleted (%d hmms are loaded).\n', length(hmms));
%% Record or load all the test data

if strcmp(user_mode,'record')%% record & test mode
    % launch recognition system
    [pathRes, probRes] = songreco(hmms, user_mode, record_name, 1);
    fprintf('Result :: %s\n',pathRes);
%     figure,
elseif strcmp(user_mode,'load') %%load  & test mode
     good = 0;
    confusion_matrix = zeros(length(subF));
    for ifiles = 1:nfiles
        file_name = list_file{2+ifiles};
        % launch recognition system
        [pathRes, probRes] = songreco(hmms, user_mode, file_name,0);
        
        for search = 1:length(subF)
            if strcmp( subF{search}, pathRes(10:end-1 ))
                Idex = search; break;
            end
        end

        confusion_matrix(round(ifiles/5)+1, Idex) = confusion_matrix(round(ifiles/5)+1, Idex) + 1;
%         fprintf('Result :: %s\n\n',pathRes);
%         % is it the right result
         if findstr(file_name(1:end-7), pathRes)
             good = good + 1;
         end
    end
     fprintf('Correct :: %2d%%\n', round(good/nfiles*100));
end

