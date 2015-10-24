function [frIsequence] = clean_low_intensity(frIsequence, nbFrames, Fs)
% %clean_noise put all pitches>1000Hz to zero (critical frequency 900Hz)
% INPUT
%     frIsequence :: output of GetMusicFeatures
%     nbFrames    :: number of columns of frIsequence
%     Fs :: Sampling Frequency
% OUTPUT
%      The pitch of the silences is set to 0

max_intensity = max(frIsequence(3,:));
threshold = 0.2;%We assume that sounds with intensity >= threshold*max_intensity contains information
% Perform a threshold on the intensity, the pitch of the frame with an ...
%   intensity >= alpha*max_intensity are copied, the other pitch are
%   discarded(put to 0)

pitch = frIsequence(1,:);
irrelevant = frIsequence(3,:)<=threshold*max_intensity;
pitch(irrelevant) = 0;
%Correct the very strong noises
pitch(pitch>=900) = 0;
% smooth = conv(pitch, [1 0.5 1]); 
%pitch = smooth(2:end-1)
frIsequence(1,:) = pitch;



end

