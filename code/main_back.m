%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
% Definition of the HMM
q = [1;0];
A = [0.9 0.1 0; 0 0.9 0.1];
nStates = sum(size(q))-1;
mc = MarkovChain(q,A);
mu_1 = 0; sig_1 = 1;
mu_2 = 3; sig_2 = 2;
pDgen(1)=GaussD('Mean',[mu_1],'StDev',[sig_1]);
pDgen(2)=GaussD('Mean',[mu_2],'StDev',[sig_2]);
h = HMM(mc, pDgen);
%simple test of forward/backward

% c = [1, .1625, .8266, .0581];
xTest = [-.2, 2.6, 1.3];
[pX, tmp] = pDgen.prob(xTest);
[alfaHat, c]=forward(mc,pX);
betaHat = backward(mc, pX, c);

%% Generate training data
nAttempts = 150;
x_training = [];
xSize = [];
for i = 1:nAttempts
    States = mc.rand(1000);
    States = States(States~=0);
%     X_training = zeros(1,T*nAttempts);
    T = length(States)-1;
    xSize = [xSize T];
    for k =1:length(States)-1
        x_training(1,T*(i-1)+k) = pDgen( States(k) ).rand(1);
    end
end

%% Training, the trained hmm should converge to the hmm h 
nStates = 2; % Assumption
trained = MakeLeftRightHMM(nStates, GaussD, x_training, xSize);
full(trained.StateGen.TransitionProb);

%% Logprob
xTest = [-.2, 2.6, 1.3];
logprob([h, trained], xTest)

%% Generate observation and test viterbi
% ntest_obs = 10;
% X_obs = pDgen(1).rand(ntest_obs);
% X_obs = [X_obs pDgen(2).rand(ntest_obs)];
% X_obs=X_obs(randperm(length(X_obs)));
% X_obs=X_obs(randperm(length(X_obs)));
% 
% nX_obs = sum(size(X_obs))-1;
% logpX = log(trainedhmm.OutputDistr.prob(X_obs));
% [optS, logP] = trainedhmm.viterbi(X_obs);


% trainedhmm.StateGen.TransitionProb
%%


% for j=1:nStates
%     for t = 1:T
%         gam(j,t) = alfaHat(j,t)*betaHat(j,t)*c(t);
%     end
% end
