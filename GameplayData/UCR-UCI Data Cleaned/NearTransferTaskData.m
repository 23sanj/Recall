classdef NearTransferTaskData < AssessmentData 
%A class for storing information on the NearTransfer Task
    properties
        bestNoLure = 0
        bestLure = 0
        trucks = false
        practiceBlocks = LamebackBlock.empty
        noLureBlocks = LamebackBlock.empty
        lureBlocks = LamebackBlock.empty
    end

    properties (Access = private)
        lure = false
    end
    
    methods
        function obj = NearTransferTaskData(sessionNumber, assessmentNum, subjectDataDirectory)
            obj@AssessmentData(AssessmentType.NearTransfer);
            if (nargin > 0)
                detailFiles = dir([subjectDataDirectory '/*_' sprintf('%03d',sessionNumber) '_' sprintf('%03d',assessmentNum) '_NearTransferTask_*.txt' ]);
                
                if isempty(detailFiles)
                    error('No NearTransfer Detail files!');
                end

                if (length(detailFiles) > 1)
                    error('More than one detail file!');
                end

                detailFile = detailFiles(1);

                fileName = [subjectDataDirectory '/' detailFile.name];

                fid = fopen(fileName);
                %Look through headers
                tline = fgetl(fid);
                while (ischar(tline))
                    if(~strcmp(tline(1),'%'))
                        error('Didnt locate descriptor');
                    elseif (~isempty(strfind(tline, 'FireTruck')))
                        obj.trucks = true;
                        break;
                    elseif (~isempty(strfind(tline, 'Elephant')))
                        obj.trucks = false;
                        break;
                    end
                    tline = fgetl(fid);
                end

                fclose(fid);

            else
                error('Wrong argument count');
            end

        end

        function obj = AddSummaryRow(obj,block,trials,hits,misses,fa,nLevel)
            if nargin > 0
                if (~obj.lure)
                    if (nLevel >= obj.bestNoLure)
                        obj.bestNoLure = nLevel;
                        if (trials == 10 + nLevel)
                            obj.practiceBlocks(end+1) = LamebackBlock(trials, hits, misses, fa, nLevel, 0);
                        else
                            obj.noLureBlocks(end+1) = LamebackBlock(trials, hits, misses, fa, nLevel, 0);
                        end
                    else
                        obj.lure = true;
                    end
                end

                %Separated rather than else'd so that it can flow here when lure changes
                if(obj.lure)
                    if (nLevel >= obj.bestLure)
                        obj.bestLure = nLevel;
                        obj.lureBlocks(end+1) = LamebackBlock(trials, hits, misses, fa, nLevel, 0.3);
                    else
                        error('Stepped Down?!');
                    end
                end
            else
                error('Wrong argument count');
            end
        end
    end
end