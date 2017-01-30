function [files] = filter_files(files)
%Filtering the session files to remove incomplete entries-- causing descrepancy
 k=size(files,1);
while k > 0
fid = fopen(strcat(files(k).folder,'/',files(k).name),'r');
if fid == -1
    %removed_list =[removed_list; files.name];
    files =[]; %Removing Files
    return;
end
MyTextFile = textscan(fid,'%s','delimiter','\n'); %Scanning each file
fclose(fid);
MyTextFile = [MyTextFile{:}];
% extract the part containg only figures to read
enter=1;
for i =1: size(MyTextFile,1)
    if MyTextFile{i}(:,1) ~= '%' 
        if enter==1
            fields=strsplit(MyTextFile{i-1}); %Cell array of columns
            index_duration = find(strcmp(fields, 'Duration')) - 1; %duration index
            %index_nback = find(strcmp(fields, 'N-Back')) - 1; %duration index
            if isempty(index_duration == 1) %If there is no duration field
                break;
            end
            
        end
        values=str2double(strsplit([MyTextFile{i}]));
        
        if (gt(values(index_duration) ,10000))%checking if the entries are defect
            files(k) = [];
            break;
        end
        enter = enter +1;
    end
end
k=k-1;
end
end
