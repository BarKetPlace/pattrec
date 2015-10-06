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
fromfile = 1; % Read a prerecorded file (1) or record one (0)
    filename = 'melody_3.wav'; % Which one
    mute = 0; % Listen to the file
    
scaling_f = Fs; % Put Fs and the plot will be in seconds, put 1 to let the number of samples


if fromfile
    [S Fs] = audioread(strcat(path,filename));
    
else
    % Record your voice for 5 seconds.
    recObj = audiorecorder;
    fprintf('record in :: ')
    fprintf('3'); pause(1); fprintf('\b2'); pause(1); fprintf('\b1'); pause(1);
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\bStart speaking!')
    recordblocking(recObj, 5);
    disp('End of Recording.');
    S = getaudiodata(recObj)
    Fs = recObj.SampleRate;
    audiowrite(strcat(path,'highwaytohell.wav'), S, Fs);
end
nbSamples = sum(size(S))-1;

% Fourier Transform
Y = fft(S);
figure(1),
scaling_f = 1;
plot(scaling_f*[0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2));% xlim([0 0.3]);
xlabel('Normalized frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');

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
frIsequence = GetMusicFeatures(S, Fs, 0.03);
nbFrames=size(frIsequence,2);
max_intensity = max(frIsequence(3,:));
% Perform a threshold on the intensity, the pitch of the frame with an ...
%   intensity >= alpha*max_intensity are copied, the other pitch are
%   discarded(put to 0)
x=zeros(1,nbFrames); % Will receive the new pitches

for i=1:nbFrames
    if frIsequence(3,i)>0.2*max_intensity
        x(1,i) = frIsequence(1,i);
    else
        x(1,i)=0;
    end   
end
figure(3), plot(x); title('Pitch with a threshold on intensity');
%% This part compute the median of the pitch when the pitch is ~=0
m_tmp = zeros(1,nbFrames);
m_ = zeros(1,nbFrames); %Will receive the result
flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
i=1;

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
        flag = 0;
    end
i=i+1;
end

figure, plot(m_); title('Medianed pitches');
