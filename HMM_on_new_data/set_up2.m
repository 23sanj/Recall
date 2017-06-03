%Function to read the session file and set up the values for y and n back
%files is the list of session files for a subject

function [M,R,n_back,data] = set_up2(subList)
    f_size = numel(subList);
    files = subList;
    M=[];
    R=[];
    Pattern=[];
     data =[];
     n_back=[];
    for k=1:f_size
        blocks =0;
        fid = fopen(strcat(files(k).folder,'/',files(k).name),'r');
        
        MyTextFile = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
        MatrixLines=[];
        MyTextFile = [MyTextFile{:}];% extract the part containg only figures to read
        for i =1: size(MyTextFile,1)
            if MyTextFile{i}(:,1) ~= '%'
                %fields=strsplit(MyTextFile{i-1}); %Cell array of columns
                index_trial = 2; 
                index_nlevel = 3;  
                index_sttype = 6;  
                index_color = 7;
                index_iscorrect = 5;
                MatrixLines = MyTextFile(i:end);
                break;
            end
        end
       
        if isempty(MatrixLines) == 1
           return;
        end
        
        size(MyTextFile,1)
        m= size(MatrixLines,1);
        
        block_index_list =[];
         %Counting the number of blocks:
         for i=1:m
            c= MatrixLines{i};
            input = str2num(c);
            if input(index_trial) == 1
               block_index_list = [block_index_list,i];
               blocks = blocks +1; %Increament the block count
            end
            if i == m
               block_index_list = [block_index_list,i+1];  
            end
         end
        
        targets_block = zeros(blocks,1); %Missed and%Missed and Non-Match Match
        total_stimuli_block= zeros(blocks,1); %Missed and Non-Match
        n_back_block =zeros(blocks,1);
        colors_block = cell(blocks,1);
        i=1;
        %for i=1:m
            for k=1: blocks %For all blocks
                block= block_index_list(k+1) -block_index_list(k);
                targets = zeros(block,1); %All targets for a specific block
                non_targets = zeros(block,1);
                n_backs = zeros(block,1);
                colors = zeros(block,1);
                for b=1: block %For each block
                    c= MatrixLines{i};
                    input = str2num(c);
                    
                    if  input(index_sttype) == 1 && input(index_iscorrect) == 1 %TP -- correct misses
                        targets(b,1) = 1;
                    elseif input(index_sttype) == 1 && input(index_iscorrect) == 0 %FN -- incorrect rejections
                        non_targets(b,1) = 1;
                    elseif input(index_sttype) ~= 1 && input(index_iscorrect) == 0 %FP -- incorrect identifications
                         non_targets(b,1) = 1;
                   % else if input(index_sttype) ~= 1 && input(index_iscorrect) == 1 %TN -- correct rejections
                    %     targets(b,1) = 1;
                    end
                    colors(b,1) = input(index_color);
                    n_backs(b,1) = input(index_nlevel);
                    i =i+1;
                end
                 if all(n_backs == n_backs(1))
                    n_back_block(k,1) = n_backs(1);
                 end
                  colors_block{k} = num2str(colors);
                  targets_block(k,1) = sum(targets);
                  total_stimuli_block(k,1) = sum(targets) + sum(non_targets);
                  
            end
         Pattern = [Pattern;colors_block];  
         M= [M;total_stimuli_block];
         R= [R;targets_block] ;
         n_back = [n_back;n_back_block];
         %end
    end
 data = [Pattern,num2cell(n_back)];
 
 if isempty(find(M == 0)) ==0 
     rem_zer = find(M == 0);
     M(rem_zer) = [];  %Removing 0 m values.
     R(rem_zer) = [];
     n_back(rem_zer) = [];
 end
 
 if isempty(find(n_backs == 0)) ==0
     rem_zer = find(n_backs == 0);
     M(rem_zer) = [];  %Removing 0 m values.
     R(rem_zer) = [];
     n_back(rem_zer) = [];
 end

 
end