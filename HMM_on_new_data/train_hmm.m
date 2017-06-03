%Function to read the session file and set up the values for y and n back

function [A,Pi,subList] = train_hmm()

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/UCR-UCI Data Cleaned/CleanedData/RLB/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
B_list = cell(nSubs,1);
t=0;

%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*_*_*_LameBack_*.txt'])]; 
        %[files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        max_file_count  =0; %Maximum session number in list
        for i=1:numel(files) %For each fie name
            C = strsplit(files(i).name,{'Rlb*_','_'},'CollapseDelimiters',true);
            session_number =str2double(cell2mat(C(2))); %Session number
            game_number = str2double(cell2mat(C(3))); %Game number
            files(i).Session_Order =deal(session_number);
            files(i).Game_number = deal(game_number);
             if i == numel(files)
               max_file_count = files(i).Session_Order; 
            end
        end
        
        
        f=0;
        %Processing duplicates:
        kk = numel(files);
        for i= 1:kk
             if i>1 & i < kk
                n1 = files(i-1).Session_Order;
                n2 = files(i).Session_Order
                if n1 == n2
                    files(i-1) =[];
                    kk= numel(files);
                end
            end
        end
        
        %List doesn't have all session files
         
        for i=1:max_file_count %Sessions numbered from 1 to max count
            list =[files().Session_Order];
            list_g = [files().Game_number];
           if any(list == i) == 0 
                f=1;
                break;
           end
                
        end
        
        %Arranging the files in order of sessions:
        if k ~=0
            [blah, order] = sort([files(:).Session_Order],'ascend');
            files = files(order);
        end
        
        
        
        if f ~=1 %All session files must be present in order
            if(isempty(files) == 0)
                subList{k} =files;
                
                 subject_name= strsplit(files(1).name,{'Rlb*_','_'},'CollapseDelimiters',true);
                 subject_name= subject_name{1};
                t= t+1;
                [M,R,n_backs,data] = set_up2(subList{k});  %Getting the required values from all sessions
                if isempty(M) == 1 || isempty(data) == 1
                    continue;
                end
                 n_backs_list{k} = n_backs;
                 M_list{k} = M;
                 R_list{k} = R;
                 
                 %Write Pattern and n-back to a file
                 
                % filename = ['/home/csgrads/ssand024/Desktop/n-back/lameback-data/PatternFiles/Subject:' subject_name '.dat'];
                 %fileID = fopen(filename,'w');
                 %formatSpec = '%s %d \n';
                 %[nrows,ncols] = size(data);
                %for row = 1:nrows
                %    fprintf(fileID,formatSpec,data{row,:});
                %end
                %fclose(fileID);
                    rho = 1.9;
                    c= 0.3684;
                    d=1;
                    [B,X] =  compute_emission_prob(M,R,n_backs,rho,c,d); 
                    B_list{k} = B;
            end
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
    save('log_P.mat','log_P');
     save('loglik.mat','loglik');
    save('subList.mat','subList');
    save('n_backs.mat','n_backs_list');
    save('M.mat','M_list');
    save('R.mat','R_list');
    save('X.mat','X');
    save('rho.mat','rho');
    save('c.mat','c');
    save('A.mat','A');
save('Pi.mat','Pi');

end