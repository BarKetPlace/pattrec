%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

%clear all
clc
close all
% Recording/reading folder
path = '../songs/';

% Parameters
fromfile = 1; % Read a pre-recorded file (1) or record one (0)
    filename = 'melody_2.wav';

    mute = 0; % Listen to the file

Fs=0; %We do not know the value so far
scaling_f = Fs; %caling factor for the temporal plots::
                %Put Fs and the plots will be in seconds, put 1 to let the number of samples

if fromfile
    [S Fs] = audioread(strcat(path,filename));
else
    % Record your voice for 5 seconds.
    Fs=44200;
    recObj = audiorecorder(Fs,16,1);
    fprintf('Record in :: ');
    fprintf('3'); pause(1); fprintf('\b2'); pause(1); fprintf('\b1'); pause(1);
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!\n')
    recordblocking(recObj, 8);
    fprintf('End of Recording\n');
    S = getaudiodata(recObj);
    Fs = recObj.SampleRate;
%     audiowrite(strcat(path,'tnt.wav'), S, Fs);
end
nbSamples = sum(size(S))-1;

% Fourier Transform
Y = fft(S);
figure(1),
scaling_f = 1;
plot(scaling_f*[0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2));% xlim([0 0.3]);
xlabel('Frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');

%%%%%%%%%%%%%%%%
% Plot & (eventualy) Play the sound
%%%%%%%%%%%%%%%%
figure(2); subplot(2,1,1)
spectrogram(S, 200, 50, 200, Fs, 'yaxis'); colorbar('off');
title('Frequency vs time');
subplot(2,1,2);
display_(S, Fs, scaling_f, mute);
%% 
%%%%%%%%%%%%%%%%
% Features extraction
%%%%%%%%%%%%%%%%

frIsequence = GetMusicFeatures(S, Fs, 0.02);
nbFrames=size(frIsequence,2);
max_intensity = max(frIsequence(3,:));
figure, display_frI(frIsequence, 0,1,0);

%Removing the noise (~1000Hz) during the silence
threshold = 0.2;%We assume that sounds with intensity >= threshold*max_intensity contains information
% Perform a threshold on the intensity, the pitch of the frame with an ...
%   intensity >= alpha*max_intensity are copied, the other pitch are
%   discarded(put to 0)
x=zeros(1,nbFrames); % Will receive the new pitches

for i=1:nbFrames
    if frIsequence(3,i)>=threshold*max_intensity
        x(1,i) = frIsequence(1,i); %Save it !
%          if (i>1 && x(1,i) < 0.5*x(1,i-1) ) keyboard; x(1,i) = 0; end
    else
        x(1,i) = 0; %Discard it !
    end
end
%Correction
x(x>1000) = 0;
figure(3), plot(x); title('Pitch with a threshold on intensity');

% Strong assumption here : 
% We consider that between two silences, the source is in the same
% state. It means that the recorded pitch correspond to the same state.% The distribution of the pitch then define the b_j(x) for the state%

% TODO :: Consider a high variation of pitch (1 semiton) as a change of
% state, semiton are defined in the book page 226 (in the middle).


%% This part compute the median of the pitch when the pitch is ~= 0
% Useless but sometimes the variance is huge

m_ = zeros(1,nbFrames); %Will receive the result
flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
i=1;
j=1; %count the number of pitches
figure, 
while i<=nbFrames
    while (i<=nbFrames && x(1,i)~=0)
        if (~flag)  start = i; end
        flag = 1;
        i=i+1;
    end
    if flag
        stop = i-1;
        mean(x(1,start:stop));
        m_(1,start:stop) = median(x(1,start:stop));
        pitch(j) = m_(1,start);%save the value of the pitch
        [b(j,:) xb(j,:)] = ksdensity(x(1,start:stop)); %b(i,:) contains the probability for the xb(i,:) values
        plot(xb(j,:), b(j,:)); hold on;
        j=j+1;
        flag = 0;
    end
i=i+1;
end

title('Plot all the distribution of the pitch gathered in the same state');

figure, plot(m_); title('Medianed pitches');
% plot_nb = 6;
% figure, plot(xb(plot_nb,:), b(plot_nb,:));
%% New try

% test_melody2 = find_offset(x);

