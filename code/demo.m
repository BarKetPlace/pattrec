clear all
close all
clc



test_path = '../songs/tests/';

% user_mode = 'load';
% record_name = 'delete.wav';
%Usefull if user_mode = 'record',
%the file name MUST have the same name as the folder in the database
%followed by _xx.wav where xx is a double digit integer (00,
%01,02,03...10,11,...

nfiles = length(dir(fullfile([test_path '*_*.wav'])));
list_file = dir(fullfile(test_path));
list_file = {list_file.name};

%%load the different hmms from the available data base
fprintf('Loading hmms ...\n');
files_loc = '../songs/';
hmm_name = 'trained_hmm3.mat';
[ hmms ] = load_hmms( files_loc,hmm_name );
fprintf('\b\b\b\bcompleted (%d hmms are loaded).\n', length(hmms));

%% All files From the same melody
good = 0;

melody = 'concerninghobbits';
nfiles = length(dir(fullfile([test_path melody '*.wav'])));
list_file = dir(fullfile([test_path melody '*.wav']));
list_file = {list_file.name};

for ifile = 1:nfiles
   [pathRes, probRes] = songreco(hmms,'load',list_file{ifile},0);
   if findstr(melody, pathRes)
       good=good+1;
   end
   fprintf('Result :: %s\n',pathRes);
end
fprintf('\nResult :: %d/%d\n\n', good, ifile);
%% One file

file_name = 'concerninghobbits_04.wav';
% nfiles = length(dir(fullfile([test_path melody '*.wav'])));
% list_file = dir(fullfile([test_path melody '*.wav']));
% list_file = {list_file.name};


[pathRes, probRes] = songreco(hmms, 'load', file_name, 1);

fprintf('Result :: %s\n', pathRes);
