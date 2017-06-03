function [] = check_d()

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/UCR-UCI Data Cleaned/CleanedData/RLB/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);

d_values = linspace(0,1,20);
Models_A_d = cell(20,1);
Models_Pi_d = cell(20,1);
log_lik_d = zeros(20,1);
n_backs_list =cell(nSubs,1);

B_list_d = cell(nSubs,numel(d_values));

%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*_*_*_LameBack_*.txt'])]; 
        %[files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        max_file_count  =0; %Maximum session number in list
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
             [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
             if isempty(M) == 1 
                  continue;
             end
                s=1;
                for d=d_values

                        [B,X] = compute_emission_prob(M,R,n_backs,2,0.1579,d); %Computing the emission prob for each training seq
                        B_list_d{k,s} = B;
                        s=s+1;
                end
            
        end
        end
    end
    
end

save('B_list_d.mat','B_list_d');
save('subList.mat','subList');
save('n_backs.mat','n_backs_list');
t=1;
%Performing grid search
    for d=d_values
        for rr=1:5
           [A,Pi,ll] = baum_welch_cont(X,B_list_d(:,t));%Applying Baum Welch to re-estimate the parameters
            A_rr{rr} = A;
            Pi_rr{rr} = Pi;
            ll_rr(rr) = ll;
        end
            [loglik idx] = max(ll_rr(:));
        
            Models_A_d{t,1} = A_rr{idx};
            Models_Pi_d{t,1} = Pi_rr{idx};
            log_lik_d(t,1) =loglik; %Matrix of liklihood for 20 rhos
        t=t+1;
    end  
save('log_lik_d.mat','log_lik_d');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik_d(:));
[z] = ind2sub(size(log_lik_d),idx); %Find the index corresponding to max log-likelihood

A =  Models_A_d{z};
Pi =  Models_Pi_d{z};
picked_d = d_values(z);
%picked_d = d_values(y);

save('picked_d.mat','picked_d');
end

