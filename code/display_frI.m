function [] = display_frI( frIsequence, pitch, r, Intensity )
%display_frI 

if pitch 
plot( frIsequence(1,:)/max(frIsequence(1,:)) ); hold on
end
if r
plot( frIsequence(2,:)/max(frIsequence(2,:)) ); hold on
end
if Intensity
plot( frIsequence(3,:)/max(frIsequence(3,:)) );
end

legend('Pitch', 'Corr', 'Intensity');
xlabel('Frame number'); ylabel('Normalized values');

end

