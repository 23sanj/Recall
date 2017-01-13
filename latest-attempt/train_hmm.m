%Function to read the session file and set up the values for y and n back

function [removed_list] = train_hmm( )

DataDir = '/Users/sanjana/Documents/MATLAB/Aggregate_Recall_Data/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
Models = cell(nSubs, 1);%Constructing a cell array storing the models for each subject
err = cell(nSubs, 1);
nbacks = cell(nSubs, 1);
names = cell(nSubs,1);
removed_list=cell(0,0);%List of files removed
%Open all the session fles for a particular subject
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        %This gets the sequence of y and the 
         [removed_list,files]=remove_file(removed_list,files);%Function to get rid of files with lower than 81 entries
        if(not(isempty(files))) %Continue processing data
         [M R n_backs] = set_up(files);  %Getting the required values from all sessions
        %Eliminate 0-nbacks from model:
        if(isempty(find(n_backs == 0)) ~= 1)
            [removed_list,files]=remove_file(removed_list,files);
        end

        [P_SEQ,X] = compute_emission_prob(M,R,n_backs);     %Computing the emission prob required for a subject
        [A]=baum_welch_cont(P_SEQ); %Applying Baum Welch to re-estimate the parameters
        Models{k} = A;
        names{k} = subject_name;
        [Y_hat,rms] =forward(P_SEQ,A,R,M,X);
        err{k} = rms;
        nbacks{k} = n_backs;
        
        %Apply forward-backward to determine sequence
        else
            continue;
        end
    end
end
save('Models.mat','Models');
save('names.mat','names');
save('n_backs.mat','nbacks');
end