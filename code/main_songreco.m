%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
clc


%% load or record the test song and extract features
test_path = '../songs/tests/';
user = input('record or load ? ', 's');
if strcmp(user, 'record')
    mute = 1;
    record_time = 10;
    [S Fs] = record_(record_time, mute, test_path);
    
else
    file_name = 'hobbits.wav';
    [S Fs] = audioread([test_path, file_name]);
    fprintf('%s loaded\n', [test_path file_name]);
end
fprintf('Features extraction ...\n');
pitch_log = FeaturesExtractor(S, Fs, 0);
fprintf('\b\b\b\bcompleted.\n');
% figure, plot(pitch_log);
%% load the different hmm from the available data base
fprintf('Loading hmms ...\n');
files_loc = '../songs/';
[ hmms ] = load_hmms( files_loc );
fprintf('\b\b\b\bcompleted (%d hmms are loaded).\n', length(hmms));
%% compute logprob for each hmm and figure out wich song was sung
res = hmms.logprob(pitch_log);
[m imax] = max(res);
hmms(imax).UserData
%%
% hmms(1).rand(100)