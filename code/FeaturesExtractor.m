% function [ pitch_log ] = FeaturesExtractor( S, Fs ,window_size)
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------

function [ X_tmp ] = FeaturesExtractor( S, Fs ,window_size)
nbSamples = sum(size(S))-1;
            
            %Extract features
            
            if window_size
                frIsequence = GetMusicFeatures(S, Fs, window_size);
            else
                frIsequence = GetMusicFeatures(S, Fs);
            end
            nbFrames=size(frIsequence, 2);
            %     % Clean low intensity
            %     max_intensity = max(frIsequence(3,:));
            %     threshold = 0.2;%We assume that sounds with intensity >= threshold*max_intensity contains information
            %     % Perform a threshold on the intensity, the pitch of the frame with an ...
            %     %   intensity >= alpha*max_intensity are copied, the other pitch are
            %     %   discarded(put to 0)
            %
            %     pitch = frIsequence(1,:);
            %      irrelevant = frIsequence(3,:)<=threshold*max_intensity;
            % %      pitch(irrelevant) = 0;
            %      %Correct the very strong noises
            %     pitch(pitch>=900) = 0;
            
            x = frIsequence(1,:);
            
            m_ = zeros(1,nbFrames); %Will receive the result
            flag=0; %The flag = 1 when the x(1,i) ~=0 (the intensity was reasonable, see previous section)
            i=1;
%             j=1; %count the number of pitches
            
            while i<=nbFrames
                while (i<=nbFrames && x(1,i)<=900)
                    if (~flag)  start = i; end
                    flag = 1;
                    i=i+1;
                end
                if flag
                    stop = i-1;
%                     mean(x(1,start:stop));
                    m_(1,start:stop) = median(x(1,start:stop));
%                     pitch(j) = m_(1,start);%save the value of the pitch
%                     [b(j,:) xb(j,:)] = ksdensity(x(1,start:stop)); %b(i,:) contains the probability for the xb(i,:) values
                    %         plot(xb(j,:), b(j,:)); hold on;
%                     j=j+1;
                    flag = 0;
                end
                i=i+1;
            end
            
            x = m_;
            %Define the states
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
            X_tmp = Rounded_p;
end

