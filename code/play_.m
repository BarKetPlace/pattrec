function [] = play_(S,Fs,scaling_f)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nbSamples = sum(size(S))-1;
figure,
plot([0:1/scaling_f:nbSamples/scaling_f-1/scaling_f], S); xlabel(['Time']); ylabel('Sample value'); title('Signal');hold on;
player = audioplayer(S,Fs);
play(player);
while player.isplaying
    h1 = plot(get(player, 'CurrentSample')/scaling_f*ones(2), [-1 1], '-r'); hold on;
    drawnow
    delete(h1);
end

end

