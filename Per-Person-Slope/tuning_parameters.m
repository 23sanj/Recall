function [] = tuning_parameters( )

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);

rhos= linspace(0.1,2,20);
c_values = linspace(0,1,20);
d_values = linspace(0,1,20);
Models_A = cell(20,20,20);
Models_Pi = cell(20,20,20);
log_lik = zeros(20,20,20);

n_backs_list = cell(nSubs,numel(rhos),numel(c_values),numel(d_values));
M_list = cell(nSubs,numel(rhos),numel(c_values),numel(d_values));
R_list = cell(nSubs,numel(rhos),numel(c_values),numel(d_values));
B_list = cell(nSubs,numel(rhos),numel(c_values),numel(d_values));

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
            t=1;
            for rho=rhos %For each rho
                s=1;
                for c=c_values
                    u=1;
                    for d=d_values
                        subList{k} =files;
                        [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
                        n_backs_list{k,t,s,u} = n_backs;
                        M_list{k,t,s,u} = M;
                        R_list{k,t,s,u} = R;

                        [B,X] = compute_emission_prob(M,R,n_backs,rho,c,d); %Computing the emission prob for each training seq
                        B_list{k,t,s,u} = B;
                        u=u+1;
                    end
                  s=s+1;
                end
                t=t+1;
            end 
            
        end
    end
    
end

save('B_list.mat','B_list');
save('subList.mat','subList');
save('n_backs.mat','n_backs_list');
save('M.mat','M_list');
save('R.mat','R_list');
t=1;
%Performing grid search
for rho=rhos %For each rho
    s=1;
    for c=c_values
        u=1;
        for d=d_values
             A_rr = cell(5,1);
             Pi_rr = cell(5,1);
             ll_rr = zeros(5,1);
            for rr=1:5
               [A,Pi,ll] = baum_welch_cont(X,B_list(:,t,s,u));%Applying Baum Welch to re-estimate the parameters
                A_rr{i} = A;
                Pi_rr{i} = Pi;
                ll_rr(i) = ll;
            end
                [loglik idx] = max(ll_rr(:));

                Models_A{t,s,u} = A_rr{idx};
                Models_Pi{t,s,u} = Pi_rr{idx};
                log_lik(t,s,u) =loglik; %Matrix of liklihood for 20 rhos
                u=u+1;
        end
        s=s+1;
    end
    t=t+1;
end  
save('log_lik.mat','log_lik');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y z] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_A{x,y,z};
Pi =  Models_Pi{x,y,z};
picked_rho = rhos(x);
picked_c = c_values(y);
picked_d = d_values(z);

save('A.mat','A');

save('picked_rho.mat','picked_rho');
save('picked_c.mat','picked_c');
save('picked_d.mat','picked_d');
save('Models_A.mat','Models_A');
save('Models_Pi.mat','Models_Pi');
end