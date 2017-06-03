function [] = test_KF_new_data(A,B,C,D,Q,R,x0,V0)

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/UCR-UCI Data Cleaned/CleanedData/RLB/'; % Directory name
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
t=0;
%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*_*_*_LameBack_*.txt'])]; 
         subList{k} =files;
        %[files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        max_file_count  =0; %Maximum session number in list
        for i=1:numel(files) %For each fie name
            Cs = strsplit(files(i).name,{'Rlb*_','_'},'CollapseDelimiters',true);
            session_number =str2double(cell2mat(Cs(2))); %Session number
            game_number = str2double(cell2mat(Cs(3))); %Game number
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
                [M,Rt,n_backs,data] = set_up2(subList{k});  %Getting the required values from all sessions
                if isempty(M) == 1 || isempty(data) == 1
                    continue;
                end
                 n_backs_list{k} = n_backs;
                 M_list{k} = M;
                 R_list{k} = Rt;
                 
                 Test_Actual_Values{k} = (Rt./M);
                 y = Test_Actual_Values{k};
                [xf,Vf,Pf,loglik,err,Predicted_Value]= kalman_filter(A,C,B,D,n_backs,Q,R,y,x0,V0,dim);
                test_residuals{k} = err';
                Test_Predicted_Values{k} = Predicted_Value';
            end
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

