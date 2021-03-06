function [] = test_KF(A,B,C,D,Q,R,x0,V0)

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
test_residuals = cell(nSubs,1);
Test_Predicted_Values = cell(nSubs,1);
Test_Actual_Values = cell(nSubs,1);
dim=1;
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
            [M,Rt,n_backs] = set_up_olddata(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = Rt;
             Test_Actual_Values{k} = Rt./M;
             y = Test_Actual_Values{k};
            [xf,Vf,Pf,loglik,err,Predicted_Value]= kalman_filter(A,C,B,D,n_backs,Q,R,y,x0,V0,dim);
             test_residuals{k} = err';
             Test_Predicted_Values{k} = Predicted_Value';
         end
    end
end
test_residuals = cell2mat(test_residuals);

test_rmse = sqrt(sum(test_residuals.*test_residuals)/length(test_residuals));


save('test_rmse.mat','test_rmse');
save('test_residuals.mat','test_residuals');
save('test_sublist.mat','subList');
save('test_R.mat','R_list');
save('test_M.mat','M_list');
save('test_n_backs_list.mat','n_backs_list');
save('Test_Actual_Values.mat','Test_Actual_Values');
save('Test_Predicted_Values.mat','Test_Predicted_Values');
end

