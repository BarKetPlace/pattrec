clear all
close all
clc
%% Go for the processing if the entire database
files_loc = '../songs/';

files = dir(files_loc);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

subFolders.name;

for ifolder = 1:length(subFolders)
    folder = subFolders(ifolder).name;
    if ~(strcmp(folder,'.') || strcmp(folder,'..') || strcmp(folder,'antoine') )
        data_path = sprintf('%s%s/',files_loc, folder);
        [X, xSize, trained] = trainfromfiles(data_path);
        save(strcat(data_path,sprintf('%dfiles_%3fwsize.mat',nfiles, round(window_size, 3,'significant'))), 'data_path', 'X', 'xSize', 'trained');
    end
end

%% Just train some folders

data_path = '../songs/highwaytohell';
[X, xSize, trained] = trainfromfiles( data_path );


