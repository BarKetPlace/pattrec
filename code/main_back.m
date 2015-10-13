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

mc = MarkovChain(q,A);
mu_1 = 0; sig_1 = 1;
mu_2 = 3; sig_2 = 2;
pDgen(1)=GaussD('Mean',[mu_1],'StDev',[sig_1]);
pDgen(2)=GaussD('Mean',[mu_2],'StDev',[sig_2]);
h = HMM(mc, pDgen);
% Observation
X = [-.2, 2.6, 1.3];
% Scale factor (from a forward algorithm)
c = [1, .1625, .8266, .0581];
[pX, tmp] = pDgen.prob(X);

betaHat = backward(mc, pX, c);
