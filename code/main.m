%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all

path = '../songs/';
filename = 'melody_3.wav';
[S Fs] = audioread(strcat(path,filename));
nbSamples = sum(size(S))-1;

% Fourier Transform
Y = fft(S);

%%%%%%%%%%%%%%%%
% Plot & Play the sound
%%%%%%%%%%%%%%%%
figure(1),
plot(Fs*[0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2));% xlim([0 0.3]);
xlabel('Normalized frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');

scaling_f = Fs;
mute =1;

figure(2); subplot(3,1,1)
spectrogram(S, 200, 50, 200, Fs, 'yaxis'); colorbar('off');
subplot(3,1,2);
display_(S, Fs, scaling_f, mute);

%% 
%%%%%%%%%%%%%%%%
% features extraction
%%%%%%%%%%%%%%%%

wind_size_sample = 10000;
frIsequence = GetMusicFeatures(S, Fs, 0.03);%, wind_size_sample/Fs);
nbFrames=size(frIsequence,2);
max_intensity = max(frIsequence(3,:));
% figure(3),
% display_frI(frIsequence,1,0,1);
x=zeros(1,nbFrames);
for i=1:nbFrames
    if frIsequence(3,i)>0.2*max_intensity 
        x(1,i) = frIsequence(1,i);
    else
        x(1,i)=0;
    end   
end
m_tmp = zeros(1,nbFrames);
m_ = zeros(1,nbFrames);
figure(3), plot(x);
%% 
j=1; flag=0; i=1;
figure(4), clf

while i<=nbFrames
    while (x(1,i)~=0)
        if (~flag)  start = i; end
        flag = 1;
        i=i+1;
    end
    if flag
        stop = i-1;
        mean(x(1,start:stop));
        m_(1,start:stop) = mean(x(1,start:stop));
        flag = 0;
        j=j+1;
    end
    %m_(1, i) = 0;
i=i+1;
end

figure, plot(m_);

% %% record
% % Record your voice for 5 seconds.
% recObj = audiorecorder;
% disp('Start speaking.')
% recordblocking(recObj, 5);
% disp('End of Recording.');
% 
% % Play back the recording.
% play(recObj);
% 
% % Store data in double-precision array.
% myRecording = getaudiodata(recObj);
% 
% % Plot the waveform.
% figure,
% plot(myRecording);
% S2 = myRecording(5000:end);
% plot(S2)
% S=S2