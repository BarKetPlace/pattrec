clear all
clc

nbMelody = 2;

path = '../songs/marseillaise/';
filename = '17';

[S Fs] = audioread(strcat(path, filename, '.wav'));

scaling_f = Fs; %scaling factor for the temporal plots::
%Put Fs and the plots will be in seconds, put 1 to let the number of samples
mute  =1;
nbSamples = sum(size(S))-1;

%Extract features
window_size = 0.08;
if window_size
    frIsequence = GetMusicFeatures(S, Fs, window_size);
else
    frIsequence = GetMusicFeatures(S, Fs);
end
nbFrames=size(frIsequence, 2);
frIsequence = clean_low_intensity(frIsequence, nbFrames, Fs);
x = frIsequence(1,:);

% if size(x,1)==1
%     x=x';
% end


for i = 1:nbMelody
    load(strcat('Melody', int2str(i)));
    
    hmm(i)=trained;
    
end

logP = logprob(hmm,x);
