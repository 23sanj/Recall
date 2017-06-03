classdef MatrixReasoningTaskData < AssessmentData 
%A class for storing information on the Matrix Reasoning Task
    properties
        hits
        misses
        noresponse
        problemSet
        responses
        correctResponses
    end
    
    methods
        function obj = MatrixReasoningTaskData(hits, misses, noresponse, problemSet)
            obj@AssessmentData(AssessmentType.MatrixReasoning);
            if nargin > 0
                if isnumeric(hits) && isnumeric(misses) && isnumeric(noresponse) && ischar(problemSet)
                    obj.hits = hits;
                    obj.misses = misses;
                    obj.noresponse = noresponse;
                    obj.problemSet = problemSet;
                    obj.responses = zeros(1,hits+misses+noresponse);
                    obj.correctResponses = zeros(1,hits+misses+noresponse);
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end

        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_MatrixReasoning_*.txt' ]);
            
            if isempty(detailFiles)
                error('No MatrixReasoning Detail files!');
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

                probNum = str2double(splitString{2});
                currentResponse = str2double(splitString{3});
                correctResponse = str2double(splitString{4});
                navigationDirection = str2double(splitString{5});

                %Just need to update values on NavDir of 0.
                if (navigationDirection == 0)
                    obj.responses(probNum+1) = currentResponse;
                    if (currentResponse == correctResponse)
                        obj.correctResponses(probNum+1) = 1;
                    else
                        obj.correctResponses(probNum+1) = 0;
                    end
                end

                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end