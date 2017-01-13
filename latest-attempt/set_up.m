%Function to read the session file and set up the values for y and n back
%files is the list of session files for a subject

function [M R n_backs] = set_up(files)

 f_size = numel(files);
 n_backs = zeros(f_size,1);
 R = zeros(f_size,1);
 M = zeros(f_size,1);
 
for k=1:f_size%For each session
fid = fopen(strcat(files(k).folder,'/',files(k).name),'r');
MyTextFile = textscan(fid,'%s','delimiter','\n');
fclose(fid);

MyTextFile = [MyTextFile{:}];
% extract the part containg only figures to read

for i =1: size(MyTextFile,1)
    if MyTextFile{i}(:,1) ~= '%'
        fields=strsplit(MyTextFile{i-1}); %Cell array of columns
        index_nback = find(strcmp(fields, 'N-Back')) -1; %n back index
        index_TP = find(strcmp(fields, 'TP')) -1; %TP index    
        index_FP = find(strcmp(fields, 'FP')) -1; %FP index  
        index_TN = find(strcmp(fields, 'TN')) -1; %TN index    
        index_FN = find(strcmp(fields, 'FN')) -1; %FN index  
        
        MatrixLines = MyTextFile(i:end);
        break;
    end
end
size(MyTextFile,1)
m= size(MatrixLines,1);
TP = zeros(m,1); %Zapped and Match-- for every event
FP = zeros(m,1); %Zapped and Non-Match 
TN = zeros(m,1); %Missed and Match
FN= zeros(m,1); %Missed and Non-Match
TOTAL_STIMULUS = zeros(m,1); %Number of stimuli for each event
N_BACK =zeros(m,1);

%The n back is the weighted average across all stimuli:
for i=1:m
    c= MatrixLines{i};
    input = str2num(c);
    N_BACK(i,1) = input(index_nback) %Getting the n-back
    TP(i,1) = input(index_TP); %tp 
    FP(i,1) = input(index_FP); %FP
    TN(i,1) = input(index_TN); %TN
    FN(i,1) = input(index_FN); %FN
    TOTAL_STIMULUS(i,1) = TP(i,1) + FP(i,1) + TN(i,1) + FN(i,1);
end

 n_back =sum(N_BACK.*TOTAL_STIMULUS)/sum(TOTAL_STIMULUS); %n-back for the session
 n_backs(k,1)=round(n_back); %Rounding nbacks
 %Calculating y for the session: y=(r,m) , r= #TP + TN m=TP+TN+FP+FN
 R(k,1) = sum(TP+TN); % # right for the session
 M(k,1)= sum(TOTAL_STIMULUS);% total stimuli for session 
 end 
end