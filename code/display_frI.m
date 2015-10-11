function [] = display_frI( frIsequence, pitch, r, Intensity )
%display_frI 
% % This function plots some lines of the GetMusicFeatures output. with a
% normalization
% INPUT
%     frIsequence :: Output of GetMusicFeatures
%     pitch       :: Put 1 to plot the first row (0 otherwize)
%     r           :: Put 1 to plot the second row (0 otherwize)
%     Intensity   :: Put 1 to plot the third row (0 otherwize)
%%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------


if pitch 
plot( frIsequence(1,:)/max(frIsequence(1,:)) ); hold on
end
if r
plot( frIsequence(2,:)/max(frIsequence(2,:)) ); hold on
end
if Intensity
plot( frIsequence(3,:)/max(frIsequence(3,:)) );
end

% legend('Pitch', 'Corr', 'Intensity');
xlabel('Frame number'); ylabel('Normalized values');

end

