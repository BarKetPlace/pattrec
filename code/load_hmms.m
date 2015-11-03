% function [ hmms, song_name ] = load_hmms( files_loc )
%   Detailed explanation goes here
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

function [ hmms ] = load_hmms( files_loc,hmm_name )

files = dir(files_loc);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

subFolders.name;
    ifolder = 1;
%     song_name = cell( length(subFolders) );
for k = 1:length(subFolders)
    flag = 0;    
    folder = subFolders(k).name;
    if ~(strcmp('demo',folder)||strcmp(folder,'.') || strcmp(folder,'..') || strcmp(folder,'antoine') || strcmp(folder, 'tests') )
        hmm_path = sprintf('%s%s/%s',files_loc, folder, hmm_name);
%         try 
%         mat_path_tmp = cellstr( ls([hmm_path 'trained_hmm.mat']) );
%         catch
%             warning( sprintf('No .mat file in %s', hmm_path) );
%             flag = 1;
%         end
%         if ~flag
%         mat_path = mat_path_tmp{1,1};
            load(hmm_path);
            hmms(ifolder) = trained;
%             song_name{ifolder} = data_path;
            ifolder = ifolder + 1;
%         end
        
    end
end

end