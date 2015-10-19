%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all
% Recording/reading folder
path = '../songs/';

% Parameters
% filename = 'melody_3.wav'; % put filename = ''; to record your voice
    filename = '';
mute = 1; % Listen to the file or not

if ~strcmp(filename,'')
    [S Fs] = audioread(strcat(path,filename));
else
    % Record your voice for a few seconds.
    Fs=44200;
    recObj = audiorecorder(Fs, 16, 1);
    user = 'no';
    i=4;
    while strcmp(user, 'no')
        fprintf('Record in :: 3'); pause(1);
        fprintf('\b2'); pause(1);
        fprintf('\b1'); pause(1);
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!\n')
        recordblocking(recObj, 8);
        fprintf('End of Recording\n');

        Stmp = getaudiodata(recObj);
        Fstmp = recObj.SampleRate;
        recObj.play;
        S = getaudiodata(recObj);
        Fs = recObj.SampleRate;
        audiowrite(strcat(path,[int2str(i) '.wav']), S, Fs);
        user = input('Good ? ', 's');
        i=i+1;
    end
end
scaling_f = Fs; %scaling factor for the temporal plots::
                %Put Fs and the plots will be in seconds, put 1 to let the number of samples

nbSamples = sum(size(S))-1;


% % Fourier Transform
% Y = fft(S);
% figure(1),
% scaling_f = 1;
% plot(scaling_f*[0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2));% xlim([0 0.3]);
% xlabel('Frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot & (eventualy) Play the sound
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure, subplot(2,1,1)
spectrogram(S, 200, 50, 200, Fs, 'yaxis'); colorbar('off');
title([filename ':: Frequency vs time']);
subplot(2,1,2);
display_(S, Fs, scaling_f, mute);
%% 
window_size = 0;
if window_size 
    frIsequence = GetMusicFeatures(S, Fs, window_size);
else
    frIsequence = GetMusicFeatures(S, Fs);
end
nbFrames=size(frIsequence, 2);
frIsequence = clean_low_intensity(frIsequence, nbFrames, Fs);

%figure, display_frI(frIsequence, 1,0,0);
figure, plot(frIsequence(1,:)); title([filename ':: Pitch with a threshold on intensity']);

% Strong assumption here : 
% We consider that between two silences, the source is in the same
% state. It means that the recorded pitch correspond to the same state.
% The distribution of the pitch in the same semiton define the b_j(x)

%%
x = frIsequence(1,:);
m_ = zeros(1,nbFrames); %Will receive the result
flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
i=1;
j=1; %count the number of pitches


% Perform median between silences
while i<=nbFrames
    while (i<=nbFrames && x(1,i)~=0)
        if (~flag)  start = i; end
        flag = 1;
        i=i+1;
    end
    if flag
%         StateD = pDgen(j);
        stop = i-1; 
        m_(1,start:stop) = median(x(1,start:stop));
        pitch(j) = m_(1,start); %save the value of the pitch
        [b(j,:) xb(j,:)] = ksdensity(x(1,start:stop)); %b(i,:) contains the probability for the xb(i,:) values
        pDgen(j) = DiscreteD(b(j,:), xb(j,:));
        plot(xb(j,:), b(j,:)); hold on;
        j=j+1;
        flag = 0;
    end
i=i+1;
end

%% New try
% sounds = 
Sfreq
[features_vector, ref] = find_offset( unique(m_,'stable'));
figure, plot(features_vector); hold on;

xlabel('Frame number');
ylabel('Offset values');
title([filename ':: Results of the features extractor']);
%% Test train
nStates = sum(size(features_vector)) - 1;
for i = 1:nStates pD(i) = GaussD('Mean',[features_vector(i)], 'StDev', [1]); end
tmp = MarkovChain;
mc2 = tmp.initLeftRight(nStates, 1);
HMM1 = HMM(mc2, pD);
HMM1 = HMM1.init(features_vector, nStates);

TrainedHMM = HMM1.train(features_vector, nStates);
%%
% figure,
% plot(test_melody1, '-b', 'LineWidth', 1.5); hold on;
% plot(test_melody2, '-r', 'LineWidth', 1.5); hold on;
% % plot(test_melody3, '-k', 'LineWidth', 1.5); hold on;
% xlabel('Frame number');
% ylabel('Offset values');
% title('Comparison between the same melody recorded in two different ways');
% legend('Melody 1','Melody 2','Melody 3');
% 
%% This part compute the median of the pitch when the pitch is ~= 0
% Not to be used so far
% x = frIsequence(1,:);
% m_ = zeros(1,nbFrames); %Will receive the result
% flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
% i=1;
% j=1; %count the number of pitches
% figure, 
% while i<=nbFrames
%     while (i<=nbFrames && x(1,i)~=0)
%         if (~flag)  start = i; end
%         flag = 1;
%         i=i+1;
%     end
%     if flag
%         stop = i-1;
%         mean(x(1,start:stop));
%         m_(1,start:stop) = median(x(1,start:stop));
%         pitch(j) = m_(1,start);%save the value of the pitch
%         [b(j,:) xb(j,:)] = ksdensity(x(1,start:stop)); %b(i,:) contains the probability for the xb(i,:) values
%         plot(xb(j,:), b(j,:)); hold on;
%         j=j+1;
%         flag = 0;
%     end
% i=i+1;
% end
% 
% title('Plot all the distribution of the pitch gathered in the same state');
% 
% figure, plot(m_); title('Medianed pitches');
% plot_nb = 6;
% figure, plot(xb(plot_nb,:), b(plot_nb,:));