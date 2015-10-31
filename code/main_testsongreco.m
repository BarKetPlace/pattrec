%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
clc

test_path = '../songs/tests/'
file_name = 'marseillaise_04.wav';
user_mode = 'load';
nfiles = length(dir(fullfile([test_path '*_*.wav'])));
list_file = dir(fullfile(test_path));
list_file = {list_file.name};
%% load the different hmm from the available data base
fprintf('Loading hmms ...\n');
files_loc = '../songs/';
[ hmms ] = load_hmms( files_loc );
fprintf('\b\b\b\bcompleted (%d hmms are loaded).\n', length(hmms));
%% Record or load all the test data
if strcmp(user_mode,'record')%% record & test mode
    % launch recognition system
    [pathRes, probRes] = songreco(hmms, user_mode, file_name);
    fprintf('Result :: %s\n',pathRes);
    
elseif strcmp(user_mode,'load') %%load  & test mode
    good = 0;
    for ifiles = 1:nfiles
        file_name = list_file{2+ifiles};
        % launch recognition system
        [pathRes, probRes] = songreco(hmms, user_mode, file_name);
        fprintf('Result :: %s\n',pathRes);
        % is it the right result
        if findstr(file_name(1:end-7), pathRes)
            good = good + 1;
        end
    end
    fprintf('Correct :: %2d%%\n', round(good/nfiles*100));
end

