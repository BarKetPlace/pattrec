% function [ X, xSize, trained ] = trainfromfiles( data_path )
%   Detailed explanation goes here
%----------------------------------------------------
%Code Authors:
% Antoine Honoré
% Audrey Brouard
%----------------------------------------------------
function [ X, xSize, trained ] = trainfromfiles( data_path )
fprintf('Start processing %s\n',data_path);
        %path = '../songs/igetaround/';
        nfiles = length(dir(fullfile([data_path '/*.wav'])));
        
        tab_mean = [];
        X=[];
        xSize = [];
        fprintf('File 00/00\n');
        for ifile = 1:nfiles
            fprintf('\b\b\b\b\b\b%02d/%02d\n',ifile,nfiles);
            
            [S Fs] = audioread(strcat(data_path, sprintf('%02d.wav',ifile-1)));
            
            scaling_f = Fs; %scaling factor for the temporal plots::
            %Put Fs and the plots will be in seconds, put 1 to let the number of samples
            mute  =1;
            nbSamples = sum(size(S))-1;
            
            %Extract features
            window_size = 0;
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
            j=1; %count the number of pitches
            
            while i<=nbFrames
                while (i<=nbFrames && x(1,i)<=900)
                    if (~flag)  start = i; end
                    flag = 1;
                    i=i+1;
                end
                if flag
                    stop = i-1;
                    mean(x(1,start:stop));
                    m_(1,start:stop) = median(x(1,start:stop));
                    pitch(j) = m_(1,start);%save the value of the pitch
                    [b(j,:) xb(j,:)] = ksdensity(x(1,start:stop)); %b(i,:) contains the probability for the xb(i,:) values
                    %         plot(xb(j,:), b(j,:)); hold on;
                    j=j+1;
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
            
            X = [X pitch_log]; % Concatenate with the previous ones
            tab_mean = union(tab_mean, X_tmp); % Merge it (we do not want two times the same state)
            xSize(ifile) = length(pitch_log);
%             plot(X_tmp, 'LineWidth',2); hold on; drawnow;
        end
        nStates = round(length(tab_mean)/2); %reduce the number of states
        fprintf('Start training with %d states\n', nStates);
        trained = MakeLeftRightHMM(nStates, GaussD, X, xSize);
        save(strcat(data_path,sprintf('%dfiles_%3fwsize.mat',nfiles, round(window_size, 3,'significant'))), 'data_path', 'X', 'xSize', 'trained');
        fprintf('Done processing %s\n', data_path);
end

