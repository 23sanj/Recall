%Function to read the session file and set up the values for y and n back

function [] = train_hmm( )

DataDir = '/Users/sanjana/Documents/MATLAB/single model/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);

rhos= linspace(0.1,2,20);
c_values = linspace(0,1,20);
Models_rho = cell(20,20);
log_lik = zeros(20,20);

n_backs_list = cell(nSubs,numel(rhos),numel(c_values));
M_list = cell(nSubs,numel(rhos),numel(c_values));
R_list = cell(nSubs,numel(rhos),numel(c_values));
B_list = cell(nSubs,numel(rhos),numel(c_values));

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
            for rho=rhos %For each rho
                s=1;
                for c=c_values
                    subList{k} =files;
                    [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
                    n_backs_list{k,t} = n_backs;
                    M_list{k,t} = M;
                    R_list{k,t} = R;
             
             
                    [B,X] = compute_emission_prob(M,R,n_backs,rho,c); %Computing the emission prob for each training seq
                    B_list{k,t} = B;
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
        [A,loglik]=baum_welch_cont(X,B_list(:,t,s)); %Applying Baum Welch to re-estimate the parameters
        Models_rho{t,s} = A;
        log_lik(t,s) =loglik; %Matrix of liklihood for 20 rhos
        s=s+1;
    end
    t=t+1;
end  
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_rho{x,y};
picked_rho = rhos(x);
picked_c = c_values(y);

save('A.mat','A');
save('log_lik.mat','log_lik');
save('picked_rho.mat','picked_rho');
save('picked_c.mat','picked_c');
save('Models_rho.mat','Models_rho');

end