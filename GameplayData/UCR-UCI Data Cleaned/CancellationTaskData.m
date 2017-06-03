classdef CancellationTaskData < AssessmentData 
%A class for storing information on the Cancellation Task
    properties
        hits
        misses
        fa
        cr
        rowData
    end
    
    methods
        function obj = CancellationTaskData(hits, misses, fa, cr)
            obj@AssessmentData(AssessmentType.Cancellation);
            if nargin > 0
                if isnumeric(hits) && isnumeric(misses) && isnumeric(fa) && isnumeric(cr)
                    obj.hits = hits;
                    obj.misses = misses;
                    obj.fa = fa;
                    obj.cr = cr;
                    obj.rowData = CancellationTaskRowData.empty;
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end

        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_D2_17*.txt' ]);
            
            if isempty(detailFiles)
                error('No D2 Detail files!');
            end

            if (length(detailFiles) > 1)
                error('More than one detail file!');
            end

            detailFile = detailFiles(1);

            fileName = [directory '/' detailFile.name];

            fid = fopen(fileName);
            %Skip Headers
            tline = fgetl(fid);
            while (ischar(tline))
                if(~strcmp(tline(1),'%'))
                    break;
                end
                tline = fgetl(fid);
            end

            %Now at the end of the headers
            while (ischar(tline))
                if(strcmp(tline,''))
                    continue;
                end
                splitString = strsplit(tline,',');

                lastChar = str2double(splitString{2});
                rowhits = str2double(splitString{3});
                rowmisses = str2double(splitString{4});
                rowfa = str2double(splitString{5});
                rowcr = str2double(splitString{6});
                sequence = splitString{7};
                responses = splitString{8};
                
                obj.rowData(end+1) = CancellationTaskRowData(lastChar, rowhits, rowmisses, rowfa, rowcr, sequence, responses);

                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end