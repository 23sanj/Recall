%Function to read the session file and set up the values for y and n back

function [] = nonlinearKalman_olddata(tune_param, varargin)

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
data_list = cell(nSubs,1);   
%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
   if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        [files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        %Arranging the files in order of sessions: By introducing a new
        %field
        for i=1:numel(files) %For each fie name
            C = strsplit(files(i).name,{'session','-'},'CollapseDelimiters',true);
            tmp =str2double(cell2mat(C(2)));
            files(i).Session_Order =deal(tmp);
        end
        [blah, order] = sort([files(:).Session_Order],'ascend');
        files = files(order);
        if(isempty(files) == 0)
            subList{k} =files;
            [M,R,n_backs] = set_up_olddata(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = R;
           data_list{k} = (R./M);
        end
    end
    
end
        
save('data_list.mat','data_list');
save('n_backs_list.mat','n_backs_list');
save('R_list.mat','R_list');
save('M_list.mat','M_list');

log_P = zeros(5,1);
A_rr = cell(5,1);
C_rr = cell(5,1);
B_rr = cell(5,1);
D_rr = cell(5,1);
Q_rr = cell(5,1);
R_rr = cell(5,1);
x0_rr = cell(5,1);
V0_rr = cell(5,1);
LL = [];
A_L=[];
B_L=[];
Q_L=[];
R_L=[];
x0_L=[];
V0_L=[];

if nargin == 0
    tune_param = 0;
    a= 1.6842;
end

if tune_param == 1
    tune_hyperparam(data_list,n_backs_list,M_list,R_list);
    return;
end

dim=3
for i=1:10 %Random Restarts to avoid getting stuck in local maxima
    [A, B, Q, R,x0, V0, loglik] = learn_kalman(data_list,n_backs_list,M_list,R_list,LL,A_L,B_L,Q_L,R_L,x0_L,V0_L,a,dim);
    A_rr{i} = A;
    B_rr{i} = B;
    Q_rr{i} = Q;
    R_rr{i} = R;
    x0_rr{i} = x0;
    V0_rr{i} = V0;
    log_P(i) = loglik;
end
 
[loglik,idx] =max(log_P);
 
A = A_rr{idx};
B = B_rr{idx};
Q = Q_rr{idx};
R = R_rr{idx};

x0 = x0_rr{idx};
V0 = V0_rr{idx};
 save('log_P.mat','log_P');
 save('loglik.mat','loglik');
 save('A.mat','A');
 save('B.mat','B');
 save('Q.mat','Q');
 save('R.mat','R');
 save('x0.mat','x0');
 save('V0.mat','V0');
 save('subList.mat','subList');
end