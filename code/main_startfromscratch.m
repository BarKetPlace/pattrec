clear all
close all
clc


nFiles = 9;
S_=1;
Fs_=1;
path = '../songs/';
filename = int2str(0:nFiles-1);
figure,
%% Load the different files
for k = 1:nFiles %Repet it as long as there is files
    [S Fs] = audioread(strcat(path, [int2str(k-1) '.wav']));
    %     S = S_(i);
    %     Fs = Fs_(i);
    
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
    
    m_ = zeros(1,nbFrames); %Will receive the result
    flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
    i=1;
    j=1; %count the number of pitches
    
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
            %         plot(xb(j,:), b(j,:)); hold on;
            j=j+1;
            flag = 0;
        end
        i=i+1;
    end
    x = m_;
    %Define the states
    lowest = 27.5;
    % highest = 260;
    
    nb_octave = 10;
    
    nb_semitons = 12*nb_octave;
    s = 0.0578;
    semitons = log(lowest)+ [0:nb_semitons].*s;
    
    pitch_log = log(x);
    Rounded_pitches = interp1(semitons, semitons, pitch_log, 'previous');
    tmp  = Rounded_pitches(~isnan(Rounded_pitches));
    ref = mean(tmp);
    Rounded_p = tmp - ref;
    pitch_log = pitch_log( ~isinf(pitch_log) ) - ref;
    X_tmp = Rounded_p;
    
    if k == 1
        X = pitch_log; % Will be used as a training data
        tab_mean = X_tmp; %Will be used to define the states
    else
        X = [X pitch_log]; % Concatenate with the previous ones
        tab_mean = union(tab_mean,X_tmp); % Merge it (we do not want two times the same state)
    end
    plot(X_tmp, 'LineWidth',2); hold on; drawnow;
    xSize(k) = length(pitch_log);%Save the size of the data
    
end
% sorted_mean = sort(tab_mean);
% tab_mean = sorted_mean(1:5:end);

%% Define the states
xx=[];
scale_factor = max(xSize); %scale the probability density
for l = 1:length(tab_mean)
    pDgen(l) = GaussD('Mean',tab_mean(l),'StDev',0.01);
    [f x] = ksdensity(pDgen(l).rand(100));
    %     xx = union(xx,x);
    plot(f/max(f)*scale_factor,x); hold on; % We plot that just to see which state will be represented inthe HMM
    
end
%% Training
fprintf('Debut training\n');
tic
nStates = length(tab_mean)+5;
trained = MakeLeftRightHMM(nStates, GaussD, X, xSize);
toc
fprintf('Fin training\n');
full(trained.StateGen.TransitionProb);
%% Now we want the most probable sequence of states for a given vector of features
[optS,logP] = trained.viterbi(X_tmp);
%% Try the best sequence and see if the pitches look like the song
for i = 1:length(optS)
    res(i) = trained.OutputDistr(optS(i)).rand(1); %Draw a sample from the b_j(x)
    %for each state of the sequence of states provided by the Viterbi Algorithm
end

figure, plot(res);
title(sprintf('Viterbi algorithm gave us a sequence of states i = (i1..iT)\nThis figure represents the vector of (x_t) where x_t follows N_i1'));
ylabel('Pitch values');
