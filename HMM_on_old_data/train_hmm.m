%Function to read the session file and set up the values for y and n back

function [] = train_hmm()

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
B_list = cell(nSubs,1);

%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        [files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        for i=1:numel(files) %For each fie name
            C = strsplit(files(i).name,{'session','-'},'CollapseDelimiters',true);
            tmp =str2double(cell2mat(C(2)));
            files(i).Session_Order =deal(tmp);
        end
        
        %Arranging the files in order of sessions:
        [blah, order] = sort([files(:).Session_Order],'ascend');
        files = files(order);
        if(isempty(files) == 0)
            subList{k} =files;
            [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = R;
             rho=1.6;
             c=0.0;
             d=1;
                [B,X] =  compute_emission_prob(M,R,n_backs,rho,c,d); 
                B_list{k} = B;
        end
    end
    
end
save('B_list.mat','B_list');
log_P = zeros(5,1);
A_rr = cell(5,1);
Pi_rr = cell(5,1);
for i=1:5 %Random Restarts to avoid getting stuck in local maxima
    [A,Pi,loglik] = baum_welch_cont(X,B_list);
    A_rr{i} = A;
    Pi_rr{i} = Pi;
    log_P(i) = loglik;
end

[loglik,idx] =max(log_P);

A = A_rr{idx};
Pi = Pi_rr{idx};
     save('A.mat','A');
    save('Pi.mat','Pi');
    save('log_P.mat','log_P');
     save('loglik.mat','loglik');
    save('subList.mat','subList');
    save('n_backs.mat','n_backs_list');
    save('M.mat','M_list');
    save('R.mat','R_list');
    save('X.mat','X');
    save('rho.mat','rho');
    save('c.mat','c');


end