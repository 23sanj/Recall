function [] = test_hmm(A,Pi)

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/3 Recall(NonHoldout)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
B_list = cell(nSubs,1);
test_residuals = cell(nSubs,1);
Test_Predicted_Values = cell(nSubs,1);
Test_Actual_Values = cell(nSubs,1);

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
            subList{k} =files;
            [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = R;
             Test_Actual_Values{k} = R./M;
             rho=1.2;
             c=0.2105;
             d=1;
             [B,X] = compute_emission_prob(M,R,n_backs,rho,c,d); %Computing the emission prob for each training seq
        
             [Y_hat,residuals]= forward2(Pi,B,A,R,M,n_backs,rho,c);
             test_residuals{k} = residuals;
             Test_Predicted_Values{k}= Y_hat;
             B_list{k} = B;
         end
    end
end
test_residuals = cell2mat(test_residuals);

test_rmse = sqrt(sum(test_residuals.*test_residuals)/length(test_residuals));


save('test_rmse.mat','test_rmse');
save('test_residuals.mat','test_residuals');
save('test_sublist.mat','subList');
save('test_B.mat','B_list');
save('test_R.mat','R_list');
save('test_M.mat','M_list');
save('test_n_backs_list.mat','n_backs_list');
save('Test_Actual_Values.mat','Test_Actual_Values');
save('Test_Predicted_Values.mat','Test_Predicted_Values');
end

