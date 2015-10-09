function [ offset_semitons ] = find_offset( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lowest = 27.5;
% highest = 260;

nb_octave = 10;

nb_semitons = 12*nb_octave;
s = 0.0578;
semitons = log(lowest)+[0:nb_semitons].*s;
%semitons(sum(size(semitons))) = log(eps)-1;

pitch_log = log(x);
Rounded_pitches = interp1(semitons, semitons, pitch_log,'previous');
tmp  = Rounded_pitches(~isnan(Rounded_pitches));
ref = tmp(1,1);


Rounded_p = Rounded_pitches - ref;
offset_semitons = Rounded_p/s

end

