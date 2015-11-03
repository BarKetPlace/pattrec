%function [pathRes, probRes]=songreco(hmms, user_mode, file_name)
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

% clear all
% close all
% clc
 function [pathRes, probRes]=songreco(hmms, user_mode, file_name, en_plot)

%% load or record the test song and extract features
test_path = '../songs/tests/';
% user = input('record or load ? ', 's');
if strcmp(user_mode, 'record')
    mute = 1;
    record_time = 10;
    [S Fs] = record_(record_time, mute, test_path, file_name);
    
else

    [S Fs] = audioread([test_path, file_name]);
    fprintf('%s loaded\n', [test_path file_name]);
end

if en_plot
    figure, display_(S, Fs, Fs, 0);
    
end

% keyboard
fprintf('Features extraction ...\n');
[Rounded pitch_log] = FeaturesExtractor(S, Fs, 0);
% 
% plot(pitch_log, 'LineWidth',2); hold on; drawnow;
if en_plot 
    figure, subplot(2,1,1);
        plot(Rounded, 'LineWidth',2); title([ file_name ' :: Rounded']);
        subplot(2,1,2);
        plot(pitch_log,'LineWidth',2); title([ file_name ' :: Actual values']);
end
fprintf('\b\b\b\bcompleted.\n');
%% compute logprob for each hmm and figure out wich song was sung
probRes = hmms.logprob(Rounded); %keyboard;
[m imax] = max(probRes);
pathRes = hmms(imax).UserData;
%%
% hmms(1).rand(100)
end