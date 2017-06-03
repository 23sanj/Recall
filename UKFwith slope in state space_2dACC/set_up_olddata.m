%Function to read the session file and set up the values for y and n back
%files is the list of session files for a subject

function [M1,R1,M2,R2,n_backs] = set_up_olddata(subList)
    f_size = numel(subList);
    n_backs = zeros(f_size,1);
    R1 = zeros(f_size,1);
    M1 = zeros(f_size,1);
    R2 = zeros(f_size,1);
    M2 = zeros(f_size,1);
    files = subList;
    total_TP=[];
    total_TN=[];
    total_FP=[];
    total_FN=[];
    total_n_back=[];
    total_TOTAL_STIMULUS1 =[];
    total_TOTAL_STIMULUS2 =[];
    
    for k=1:f_size
        fid = fopen(strcat(files(k).folder,'/',files(k).name),'r');
        
        MyTextFile = textscan(fid,'%s','delimiter','\n');
        fclose(fid);

        MyTextFile = [MyTextFile{:}];% extract the part containg only figures to read
        for i =1: size(MyTextFile,1)
            if MyTextFile{i}(:,1) ~= '%'
                fields=strsplit(MyTextFile{i-1}); %Cell array of columns
                index_nback = find(strcmp(fields, 'N-Back')) -1; %n back index
                index_TP = find(strcmp(fields, 'TP')) -1; %TP index    
                index_FP = find(strcmp(fields, 'FP')) -1; %FP index  
                index_TN = find(strcmp(fields, 'TN')) -1; %TN index    
                index_FN = find(strcmp(fields, 'FN')) -1; %FN index  
                index_TT = find(strcmp(fields, 'TaskType')) -1; %FN index  
                MatrixLines = MyTextFile(i:end);
                break;
            end
        end
        
        size(MyTextFile,1)
        m= size(MatrixLines,1);
        TP = zeros(m,1); %Zapped and Match-- for every event
        FP = zeros(m,1)
        TT= zeros(m,1); %Zapped and Non-Match 
        TN = zeros(m,1); %Missed and%Missed and Non-Match Match
        FN= zeros(m,1); %Missed and Non-Match
        TOTAL_STIMULUS1 = zeros(m,1); %Number of stimuli for each event
        TOTAL_STIMULUS2 = zeros(m,1); %Number of stimuli for each event
        N_BACK =zeros(m,1);


        for i=1:m
            c= MatrixLines{i};
            input = str2num(c);
            %if input(index_TT) == 0 %Getting only task-type 0 data
                N_BACK(i,1) = input(index_nback);%Getting the n-back
                TP(i,1) = input(index_TP); %tp 
                FP(i,1) = input(index_FP); %FP
                TN(i,1) = input(index_TN); %TN
                FN(i,1) = input(index_FN); %FN
                TT(i,1) = input(index_TT); %FN            
                TOTAL_STIMULUS1(i,1) = TP(i,1) + TN(i,1);
                TOTAL_STIMULUS2(i,1) = FN(i,1) + FP(i,1);
            %end
        end
        if index_TT
            foo=find(TT==0);
        else
            foo=find(TT==1);
        end
     
     total_n_back = [total_n_back;N_BACK];
     total_TP =[total_TP;TP];
     total_FP =[total_FP;FP];
     total_TN =[total_TN;TN];
     total_FN= [total_FN;FN];
     total_TOTAL_STIMULUS1 =[total_TOTAL_STIMULUS1;TOTAL_STIMULUS1];
     total_TOTAL_STIMULUS2 =[total_TOTAL_STIMULUS2;TOTAL_STIMULUS2];
     end
 

 M1= total_TOTAL_STIMULUS1;
 M2= total_TOTAL_STIMULUS2;
 R1= total_TP;
 R2= total_FN;
 
 n_backs = total_n_back;
 
 if isempty(find(M1 == 0)) ==0 
     rem_zer = find(M1 == 0);
     M1(rem_zer) = [];  %Removing 0 m values.
     R1(rem_zer) = [];
     M2(rem_zer) = [];  %Removing 0 m values.
     R2(rem_zer) = [];
     n_backs(rem_zer) = [];
 end
 
 if isempty(find(n_backs == 0)) ==0
     rem_zer = find(n_backs == 0);
     M1(rem_zer) = [];  %Removing 0 m values.
     R1(rem_zer) = [];
     M2(rem_zer) = [];  %Removing 0 m values.
     R2(rem_zer) = [];
     n_backs(rem_zer) = [];
 end

 

 
end