%test training of a discrete-valued HMM
%similar to test example in the PattRec course project.
clear all
%source model 1
mc=MarkovChain([1 0],[0.9 0.1 0;0 0.9 0.1]);
pD(1)=DiscreteD([0.5 0.45 0.05]);%state 1
pD(2)=DiscreteD([0.6 0.35 0.05]);%state 2
%h(1)=HMM('MarkovChain',mc,'OutputDistr',pD);
h(1)=HMM(mc,pD);

%source model 2
mc=MarkovChain([1 0],[0.95 0.05 0;0 0.8 0.2]);
pD(1)=DiscreteD([0.2 0.6 0.2]);%state 1
pD(2)=DiscreteD([0.4 0.2 0.4]);%state 2

%pD2(1)=GaussD;
%pD2(2)=GaussD;

%h(2)=HMM('MarkovChain',mc,'OutputDistr',pD);
h(2)=HMM(mc,pD);

%test models:
nSamples = 10000;
for r=1:5
    [x1,zTest1]=rand(h(1),nSamples);
    [x2,zTest2]=rand(h(2),nSamples);
    %test1=logprob(h,zTest1)
    %test2=logprob(h,zTest2)
end;
mx1 = mean(x1,2);
mx2 = mean(x2,2);
t1 = size(zTest1,2); t2 = size(zTest2,2);
figure(1), plot(1:t1, mx1);
