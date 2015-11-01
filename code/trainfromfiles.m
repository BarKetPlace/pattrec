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
        nStates=0;
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
%             if window_size
%                 frIsequence = GetMusicFeatures(S, Fs, window_size);
%             else
%                 frIsequence = GetMusicFeatures(S, Fs);
%             end
%             nbFrames = size(frIsequence, 2);
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
            
%             x = frIsequence(1,:);
%             window_size =0;
            [ X_tmp ] = FeaturesExtractor( S, Fs ,window_size);
            
            X = [X X_tmp]; % Concatenate with the previous ones
            nStates = max(nStates, length(union(X_tmp,[])));
%             tab_mean = union(tab_mean, X_tmp); % Merge it (we do not want two times the same state)
            xSize(ifile) = length(X_tmp);
%             plot(X_tmp, 'LineWidth',2); hold on; drawnow;
        end
        
%         nStates = round(length(tab_mean)); %reduce the number of states
        fprintf('Start training with %d states\n', nStates);
        trained = MakeLeftRightHMM(nStates, GaussD, X, xSize);
        %Avoid errors with sparse matrix
        trained.StateGen.InitialProb = full(trained.StateGen.InitialProb);
        trained.StateGen.TransitionProb = full(trained.StateGen.TransitionProb);
        %Store the name
        trained.UserData = data_path;
        
%         save(strcat(data_path,sprintf('%dfiles_%3fwsize.mat',nfiles, round(window_size, 3,'significant'))), 'data_path', 'X', 'xSize', 'trained');
        fprintf('Done processing %s\n', data_path);
end

