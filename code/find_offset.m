function [ offset_semitons, ref ,pitch_log] = find_offset( x )
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
semitons = log(lowest)+ [0:nb_semitons].*s;

pitch_log = log(x);
Rounded_pitches = interp1(semitons, semitons, pitch_log, 'previous');
tmp  = Rounded_pitches(~isnan(Rounded_pitches));
ref = mean(tmp);
Rounded_p = tmp - ref;
pitch_log = pitch_log( ~isinf(pitch_log) ) - ref;
offset_semitons = Rounded_p/s;

endend

