clear all
close all
clc
nFiles = 4;
S_=1;
Fs_=1;
path = '../songs/';
filename = int2str(0:nFiles-1);
for k = 1:nFiles %Repet it as long as there is files
    [S Fs] = audioread(strcat(path, [int2str(k-1) '.wav']));
%     S = S_(i);
%     Fs = Fs_(i);
    
    scaling_f = Fs; %scaling factor for the temporal plots::
    %Put Fs and the plots will be in seconds, put 1 to let the number of samples
    mute  =1;
    nbSamples = sum(size(S))-1;

    
    window_size = 0.08;
    if window_size
        frIsequence = GetMusicFeatures(S, Fs, window_size);
    else
        frIsequence = GetMusicFeatures(S, Fs);
    end
    nbFrames=size(frIsequence, 2);
    frIsequence = clean_low_intensity(frIsequence, nbFrames, Fs);
     
    
    x = frIsequence(1,:);
    
    [X_tmp, ref, pitch_log] = find_offset( x );%unique(m_,'stable'));
    %X_tmp contains the offset of semitons fromthe mean of all semitons
    if k == 1
        X = pitch_log; % Will be used as a training data
        tab_mean = X_tmp; %Will be used to define the states
    else
        X = [X pitch_log]; % Concatenate with the previous ones
        tab_mean = union(tab_mean,X_tmp); % Merge it (we do not want two times the same state)
    end
    
    xSize(k) = length(pitch_log);%Save the size of the data
    
end
%% Training of the HMM
%  We assume that b_j(x) is a gaussian around the value of the offset

    for l = 1:length(tab_mean)
        pDgen(l) = GaussD('Mean',tab_mean(l),'StDev',1);
    end
nStates = length(pDgen);
tmp = MarkovChain;
mc2 = tmp.initLeftRight(nStates, 1);% Initiate a finite Markovchain of nStates
HMM1 = HMM(mc2, pDgen); 
HMM1 = HMM1.init(X, xSize); % Initiate a HMM 

TrainedHMM = HMM1.train(X, xSize); % train it here I use again X, we should use more training data
%% Now we want the more probable sequence of state
logpX = log(TrainedHMM.OutputDistr.prob(X) );
[optS,logP]=TrainedHMM.viterbi(logpX(~isinf(logpX)))

