%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

%Launch specific sections

%% Go for the processing of the entire database

clear all
close all
clc
tic
files_loc = '../songs/';

files = dir(files_loc);
% Get a logical vector that tells which one is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

subFolders.name;

for ifolder = 1:length(subFolders)
    
    folder = subFolders(ifolder).name;
    if ~(strcmp('demo',folder)|| strcmp(folder,'.') || strcmp(folder,'..') || strcmp(folder, 'tests') )
        data_path = sprintf('%s%s/',files_loc, folder);
        [X, xSize, trained] = trainfromfiles(data_path);
        save(strcat(data_path, sprintf('trained_hmm3.mat')), 'X', 'xSize', 'trained');
    end
end
elapsed = toc;

h = floor( elapsed/60/60 );
m = floor( elapsed/60 - h*60 );
s = round( elapsed - m*60 - h*60*60 );
fprintf('Database processing (%d songs) :: %d h %d min %d s\n\n\n',ifolder-3, h, m, s);

main_testsongreco

%% Just train on specified folders
clear all
clc
figure
data_path = '../songs/highwaytohell/';%do not forget / at the end
[X, xSize, trained] = trainfromfiles( data_path );
save(strcat(data_path,sprintf('trained_hmm3.mat')), 'X', 'xSize', 'trained');
%% see Output distributions result
% load ../songs/highwaytohell/trained_hmm_withoutsilence.mat
figure,
for id = 1:hmms(1).nStates
    [pD x] = ksdensity(hmms(1).OutputDistr(id).rand(200));
    plot(x,pD); hold on;    
end
