clear all
close all
clc
nFiles = 4;
S_=1;
Fs_=1;
path = '../songs/';
filename = int2str(0:nFiles-1);
for k = 1:2
    [S Fs] = audioread(strcat(path, [int2str(k-1) '.wav']));
%     S = S_(i);
%     Fs = Fs_(i);
    
    scaling_f = Fs; %scaling factor for the temporal plots::
    %Put Fs and the plots will be in seconds, put 1 to let the number of samples
    mute  =1;
    nbSamples = sum(size(S))-1;

    %%
    window_size = 0;
    if window_size
        frIsequence = GetMusicFeatures(S, Fs, window_size);
    else
        frIsequence = GetMusicFeatures(S, Fs);
    end
    nbFrames=size(frIsequence, 2);
    frIsequence = clean_low_intensity(frIsequence, nbFrames, Fs);
     
    %%
    x = frIsequence(1,:);
    
    [X_tmp, ref, pitch_log] = find_offset( x );%unique(m_,'stable'));
    if k == 1
        X = pitch_log;
        tab_mean = X_tmp;
    else
        X = [X pitch_log];
        tab_mean = union(tab_mean,X_tmp);
    end
    
    xSize(k) = length(pitch_log);
    
%     X_tmp = unique(X_tmp,'stable');   
end
%% Training of the HMM

    for l = 1:length(tab_mean)
        pDgen(l) = GaussD('Mean',tab_mean(l),'StDev',1);
    end

tmp = MarkovChain;
mc2 = tmp.initLeftRight(length(pDgen), 1);
HMM1 = HMM(mc2, pDgen);
HMM1 = HMM1.init(X, xSize);

TrainedHMM = HMM1.train(X, xSize);
%%
logpX = log(TrainedHMM.OutputDistr.prob(X) );
[optS,logP]=TrainedHMM.viterbi(logpX(~isinf(logpX)))

