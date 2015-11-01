% function [hmms, PathRes, probRes]=songreco(mode, file_name)
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

% clear all
% close all
% clc
 function [pathRes, probRes]=songreco(hmms, mode, file_name)

%% load or record the test song and extract features
test_path = '../songs/tests/';
% user = input('record or load ? ', 's');
if strcmp(mode, 'record')
    mute = 1;
    record_time = 10;
    [S Fs] = record_(record_time, mute, test_path, file_name);
    
else
%     file_name = 'hobbits.wav';
    [S Fs] = audioread([test_path, file_name]);
    fprintf('%s loaded\n', [test_path file_name]);
end
fprintf('Features extraction ...\n');
pitch_log = FeaturesExtractor(S, Fs, 0);
% plot(pitch_log, 'LineWidth',2); hold on; drawnow;
fprintf('\b\b\b\bcompleted.\n');
% figure, plot(pitch_log);

%% compute logprob for each hmm and figure out wich song was sung
probRes = hmms.logprob(pitch_log); keyboard;
[m imax] = max(probRes);
pathRes = hmms(imax).UserData;
%%
% hmms(1).rand(100)
end