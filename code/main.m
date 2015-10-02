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
[S Fs] = wavread(strcat(path,filename));
nbSamples = sum(size(S))-1;

%%%%%%%%%%%%%%%%
% Plot & Play the sound
%%%%%%%%%%%%%%%%

%display_(S, Fs, 1, mute);

%%%%%%%%%%%%%%%%
% fft
%%%%%%%%%%%%%%%%

figure(1),
Y = fft(S);
plot([0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2)); xlim([0 0.3]);
xlabel('Normalized frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');

scaling_f = Fs;
figure(2); subplot(2,1,1)
spectrogram(S, 200, 50, 200, Fs, 'yaxis'); colorbar('off');
subplot(2,1,2);
display_(S, Fs, scaling_f, 0);
