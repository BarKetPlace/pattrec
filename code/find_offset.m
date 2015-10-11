function [ offset_semitons, ref ] = find_offset( x )
%find_offset from the vector of pitches, this function return a vector of
% offset from the semiton ref
% INPUT
%     x :: vector of pitches
% OUTPUT
%     offset_semitons :: vector representing an offset of semiton from the semiton ref
%     ref :: reference of the semitons
%
lowest = 27.5;
% highest = 260;

nb_octave = 10;

nb_semitons = 12*nb_octave;
s = 0.0578;
semitons = log(lowest)+[0:nb_semitons].*s;

pitch_log = log(x);
Rounded_pitches = interp1(semitons, semitons, pitch_log,'previous');
tmp  = Rounded_pitches(~isnan(Rounded_pitches));
ref = tmp(1,1);
Rounded_p = Rounded_pitches - ref;
offset_semitons = Rounded_p/s;

end

