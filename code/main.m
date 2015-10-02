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
nbSamples/Fs
figure(1);
% Time
% plot(nbSamples/Fs*[0:1/nbSamples:1-1/nbSamples], S); xlabel('Time (s)'); ylabel('Sample value'); title('Signal');
% Sample numbers


hold on;
Y = fft(S);
figure(2);
plot([0:1/nbSamples:0.5-1/nbSamples],Y(1:nbSamples/2)); xlim([0 0.3]); xlabel('Normalized frequencies'); ylabel('|FT(signal)|^2'); title('Fourier transform');
%%%%%%%%%%%%%%%%
% Play the sound
%%%%%%%%%%%%%%%%
scaling_f = 1; %x axis will be displayin sec if the scaling = Fs

play_(S, Fs, scaling_f);


% elts = GetMusicFeatures(S, Fs);









