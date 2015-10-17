%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
close all
% Definition of the HMM
q = [1;0];
A = [.9, .1, 0; 0, .9, .1];
nStates = sum(size(q))-1;
mc = MarkovChain(q,A);
mu_1 = 0; sig_1 = 1;
mu_2 = 3; sig_2 = 2;
pDgen(1)=GaussD('Mean',[mu_1],'StDev',[sig_1]);
pDgen(2)=GaussD('Mean',[mu_2],'StDev',[sig_2]);
h = HMM(mc, pDgen);


% Observation
ntest = 50;
X = pDgen(1).rand(ntest);
X = [X pDgen(2).rand(ntest)];
X=X(randperm(length(X)));
nX = sum(size(X))-1;

%training
nStates = 2;

tmp = MarkovChain;
mc2 = tmp.initLeftRight(nStates, 1);
trainedhmm = HMM(mc2, pDgen);
trainedhmm = trainedhmm.init(X, [ntest ntest]);
trainedhmm = trainedhmm.train(X, [ntest ntest]);
trainedhmm.StateGen.TransitionProb
%%
% Scale factor (from a forward algorithm)
% % c = [1, .1625, .8266, .0581];
% [pX, tmp] = pDgen.prob(X);
% 
% [alfaHat, c]=forward(mc,pX);
% betaHat = backward(mc, pX, c);
% for j=1:nStates
%     for t = 1:T
%         gam(j,t) = alfaHat(j,t)*betaHat(j,t)*c(t);
%     end
% end
