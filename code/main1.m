%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

clear all
clc
close all

% Test DiscreteD rand
A = DiscreteD([0.1,0.8,0.1]);
x = rand(1,4);


%% Test MarkovChain rand

T = 1000;
q = [0.75; 0.25];
A = [0.99 0.01; 0.03 0.97];
mc = MarkovChain(q,A);
S = mc.rand(T);

% nb1 = sum( S == 1 );
% nb2 = sum( S == 2 );
% f1 = nb1/T;
% f2 = nb2/T;
%% Test HMM rand
clear all
T = 100;
nSamples = 500;
q = [0.75; 0.25];
A = [0.99 0.01; 0.03 0.97];
mc = MarkovChain(q,A);

pDgen(1)=GaussD('Mean',[0],'StDev',[1]);
pDgen(2)=GaussD('Mean',[3],'StDev',[2]);

h = HMM(mc, pDgen);
figure(3), clf

X = h.rand(500);
plot(X); hold on;


xlabel('t = 1..500'); ylabel('X_t'); title('500 contiguous samples from the HMM specified in the book');

%% Mean/var 
nAtt = 20;
Att = 1:nAtt;
nSamples = 100;
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
%% Test finite duration
clear all

T = 1000;
q = [0.75; 0.25; 0];
A = [0.6 0.3 0.1; 0.5 0.4 0.1];
mc = MarkovChain(q,A);

pDgen(1)=GaussD('Mean',[0 0.1],'StDev',[13 2], 'Covariance', [2 1;1 4]);
pDgen(2)=GaussD('Mean',[34 13],'StDev',[2 1]);

h = HMM(mc, pDgen);
[X,S] = h.rand(T);