function [] = writeObjectsToFile(mycell)
 outfile = 'myTextFile';
filename = [outfile,'.txt'];
% initialize/open the file
fid = fopen(filename, 'w');

% write each cell to the text file
[nrows,ncols]= size(mycell);
for row=1:nrows
     if (isempty(mycell{row}) == 1)
       continue;
    end
    fprintf(fid, 'Subject#%d :',row);
    %for r=1:length(mycell{row})
        fprintf(fid, '%s,', mycell{row,1}.name);
    %end
     fprintf(fid, '\n\n');
end

% close file when done
fclose(fid);

end

