function [] = tuning_parameters( )

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/UCR-UCI Data Cleaned/CleanedData/RLB/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);

rhos= linspace(0.1,2,20);
c_values = linspace(0,1,20);
d_values = linspace(0,1,20);
Models_A = cell(20,20);
Models_Pi = cell(20,20);
log_lik = zeros(20,20);
n_backs_list =cell(nSubs,1);

B_list = cell(nSubs,numel(rhos),numel(c_values));

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
            t=1;
            for rho=rhos %For each rho
                s=1;
                for c=c_values
                  [B,X] = compute_emission_prob(M,R,n_backs,rho,c,1); %Computing the emission prob for each training seq
                  B_list{k,t,s} = B;
                  s=s+1;
                 end
                t=t+1;
            end 
            
        end
        end
    end
    
end

save('B_list.mat','B_list');
save('subList.mat','subList');
save('n_backs.mat','n_backs_list');
t=1;
%Performing grid search
for rho=rhos %For each rho
    s=1;
    for c=c_values
        %u=1;
       % for d=d_values
         A_rr = cell(5,1);
         Pi_rr = cell(5,1);
         ll_rr = zeros(5,1);
        for rr=1:5
           [A,Pi,ll] = baum_welch_cont(X,B_list(:,t,s));%Applying Baum Welch to re-estimate the parameters
            A_rr{rr} = A;
            Pi_rr{rr} = Pi;
            ll_rr(rr) = ll;
        end
            [loglik idx] = max(ll_rr(:));
        
            Models_A{t,s} = A_rr{idx};
            Models_Pi{t,s} = Pi_rr{idx};
            log_lik(t,s) =loglik; %Matrix of liklihood for 20 rhos
         %   u=u+1;
        %end
        s=s+1;
    end
    t=t+1;
end  
save('log_lik.mat','log_lik');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_A{x,y};
Pi =  Models_Pi{x,y};
picked_rho = rhos(x);
picked_c = c_values(y);
%picked_d = d_values(y);

save('A.mat','A');

save('picked_rho.mat','picked_rho');
save('picked_c.mat','picked_c');
save('Models_A.mat','Models_A');
save('Models_Pi.mat','Models_Pi');
end