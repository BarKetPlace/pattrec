%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc

% Test DiscreteD rand
A = DiscreteD([0.1,0.8,0.1]);
x = rand(1,4);


%% Test MarkovChain rand

T = 1000;
t0 = [0.75; 0.25];
trans = [0.99 0.01; 0.03 0.97];
mc = MarkovChain(t0,trans);
S = mc.rand(T);

nb1 = sum( S == 1 );
nb2 = sum( S == 2 );
f1 = nb1/T;
f2 = nb2/T;
%% Test HMM
nSamples = 1000;

pDgen(1)=GaussD('Mean',[0 0],'StDev',[1 1]);
pDgen(2)=GaussD('Mean',[+1 0],'StDev',[3 1]);

h = HMM(mc, pDgen);

[X,S] = h.rand(nSamples);
%% testErgodicHMM


c='rbgk';%state color coding, max 4 states

%ergodic generator HMM:
% nStates=2;
% A=[.95 .05; .05 .95];
% p0=[0.5;0.5];
nStates=3;
A=[.95 .03 .02; .03 .95 .02;.03 0.02 0.95];
p0=[1;1;1];
mc=MarkovChain(p0,A);
%fairly difficult for ergodic HMM, because GaussD are highly overlapping
pDgen(1)=GaussD('Mean',[0 0],'StDev',[3 1]);
pDgen(2)=GaussD('Mean',[+1 0],'StDev',[1 3]);
pDgen(3)=GaussD('Mean',[-1 0],'StDev',[1 3]);
%hGen=HMM('MarkovChain',mc,'OutputDistr',pDgen);
hGen=HMM(mc,pDgen(1));

x = pDgen(1).rand(5);

%Make many training data sequences:
xTraining=zeros(2,0);%training data
lxT=[];%lengths of sub-sequences
sT=[];%generator states
for i=1:3
    [x,s]=rand(hGen,2000);
    xTraining=[xTraining,x];
    sT=[sT,s];
    lxT=[lxT,size(x,2)];
end;
return
hNew=InitErgodicHMM(nStates,[],GaussD,xTraining,lxT);
for nTraining=1:10
    figure;
    %plotTraining(xTraining,sT,c);
    %also plot error points, as classified by viterbi...
    plotCross(hNew.OutputDistr,[1 2],c);
 	axis([-10 10 -10 10]);
	hold off;
%	pause;
    %one training step:
    ixT=cumsum([1,lxT]);%start index for each sub-sequence
    aS=adaptStart(hNew);
    for r=1:length(lxT)
        aS=adaptAccum(hNew,aS,xTraining(:,ixT(r):(ixT(r+1)-1)));
    end;
    hNew=adaptSet(hNew,aS);
end;
hNew=setStationary(hNew);

% function plotTraining(xT,sT,c);
% nStates=max(sT);
% for s=1:nStates
%     plot(xT(1,sT==s),xT(2,sT==s),['o',c(s)],'MarkerSize',1.5);
%     hold on;
% end;

