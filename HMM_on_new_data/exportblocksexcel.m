function [diff] = exportblocksexcel(subject_name)
%The function writes the patterns and n-level for each subject into a
%seperate excel file
diff=[];
DataDir = '/home/csgrads/ssand024/Desktop/n-back/AccuracyFiles/'; % Directory name
%Creating a list of directories for the subjects:
file_name=strcat('Accuracy_Subject_',subject_name,'.txt');
file = [dir([DataDir file_name])]; 
if(isempty(file) == 0)
    fid = fopen(strcat(file.folder,'/',file.name),'r');
    fgetl( fid );
    content = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    content=content{1};
    diff= cell(size(content,1),2);
    for i=1:size(content,1)
        res=strsplit(content{i},',');
        diff{i,1}=res{1};
        diff{i,2}=res{2}
    end
end

end

