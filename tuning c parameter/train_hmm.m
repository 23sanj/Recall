%Function to read the session file and set up the values for y and n back

function [] = train_hmm( )

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);

c_values= linspace(0,1,20);
Models_c = cell(20,1);
log_lik = zeros(20,1);


%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        [files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        %Arranging the files in order of sessions:
        [blah, order] = sort([files(:).datenum],'ascend');
        files = files(order);
        if(isempty(files) == 0)
            t=1;
            for c=c_values %For each guessing parameter value
                subList{k} =files;
                [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
                n_backs_list{k,t} = n_backs;
                M_list{k,t} = M;
                R_list{k,t} = R;
             
             
                [B,X] = compute_emission_prob(M,R,n_backs,c); %Computing the emission prob for each training seq
                 B_list{k,t} = B;
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
for c=c_values %For each rho
   [A,loglik]=baum_welch_cont(X,B_list(:,t)); %Applying Baum Welch to re-estimate the parameters
    Models_c{t} = A;
    log_lik(t) =loglik; %Matrix of liklihood for 20 rhos
    t=t+1;
end  
%Find maximum log-likelihood and corresponding rho
[max_val,max_ind] = max(log_lik); %Find the index corresponding to max log-likelihood
A =  Models_c{max_ind};
picked_c = c_values(max_ind);

save('A.mat','A');
save('log_lik.mat','log_lik');
save('picked_c.mat','picked_c');
save('Models_c.mat','Models_c');
plot(c_values,log_lik);
title('Likelihood vs Guessing Parameter');
xlabel('c');
ylabel('Log-likelihood');
end