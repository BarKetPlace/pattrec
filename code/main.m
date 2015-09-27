%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
clf

% Test DiscreteD rand
A = DiscreteD([0.1,0.8,0.1]);
x = rand(1,4);


%% Test MarkovChain rand

T = 1000;
q = [0.75; 0.25];
A = [0.99 0.01; 0.03 0.97];
mc = MarkovChain(q,A);
% S = mc.rand(T);

% nb1 = sum( S == 1 );
% nb2 = sum( S == 2 );
% f1 = nb1/T;
% f2 = nb2/T;
%% Test HMM rand
clear all
nSamples = 100;
q = [0.75; 0.25];
A = [0.99 0.01; 0.03 0.97];
mc = MarkovChain(q,A);

pDgen(1)=GaussD('Mean',[0],'StDev',[1]);
pDgen(2)=GaussD('Mean',[3],'StDev',[2]);

h = HMM(mc, pDgen);
[X,S] = h.rand(nSamples);
i=1;
%%
clf
figure(3),
i1 = 4;
plot(1:500, X(i1,:), '-r'); hold on; plot(1:500, mean(X(i1,:))*zeros(500), '-r', 'LineWidth', 2); hold on;
i2 = 5;
plot(1:500, X(i2,:), '-b'); hold on; plot(1:500, mean(X(i2,:))*ones(500), '-b', 'LineWidth', 2);
xlabel('Sample number'); ylabel('Sample Value'); title('Output of HMM for two different state');
%legend(['State :: ' num2str(S(i1))],'Mu 1',['State :: ' num2str(S(i2))], 'Mu 2')
%% Mean/var 
nAtt = 1;
Att = 1:nAtt;
for i = Att
    [X,S] = h.rand(nSamples);
    v(i) =  var(X);
    m(i) = mean(X);
    i
end
figure(1), plot(Att,v); xlabel('Attempt number'); ylabel('Variance of the sample'); title('Estimated variance of several samples'); hold on
            plot(Att, mean(v)*ones(nAtt), '-r');
            
figure(2), plot(Att,m); xlabel('Attempt number'); ylabel('Mean of the sample'); title('Estimated mean of several samples'); hold on
            plot(Att, mean(m)*ones(nAtt), '-r');
%% Plots
OutputSize = size(X,2);
figure,
for i = 1:20
%     [x p] = ksdensity(X(i,:));
    plot3( 1:OutputSize, i*ones(OutputSize), X(i,:))
    xlabel('x values'); ylabel('y::Sample number'); zlabel('z::probability density');
    hold on
end
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

