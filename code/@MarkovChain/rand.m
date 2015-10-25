function S=rand(mc,T)
%S=rand(mc,T) returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    a single MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return shorter sequence,
%   if END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%---------------------------------------------
%Code Authors:
%---------------------------------------------

S=zeros(1,T);%space for resulting row vector
size(mc.TransitionProb);
% nS=mc.nStates;

% error('Method not yet implemented');
% continue code from here, and erase the error message........
A = DiscreteD( mc.InitialProb );
S(1) = A.rand(1);

i=2;

if (mc.finiteDuration)
%finite
    while( S(1,i-1) ~= size(mc.TransitionProb,2) && i<T+1)
        A = DiscreteD( mc.TransitionProb(S(1,i-1),:) );
        S(1,i) = A.rand(1);
        i = i + 1;
    end
else
%Inifinite
    for i = 2:T
        A = DiscreteD( mc.TransitionProb(S(1,i-1),:) );
        S(1,i) = A.rand(1);
    end
end
