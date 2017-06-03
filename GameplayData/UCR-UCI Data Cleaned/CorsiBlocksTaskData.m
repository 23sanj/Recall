classdef CorsiBlocksTaskData < AssessmentData 
%A class for storing information on the CorsiBlocks Task
    properties
        longestForward
        longestReverse
        forwardPractice
        forwardTrials
        reversePractice
        reverseTrials
    end
    
    methods
        function obj = CorsiBlocksTaskData(forward, reverse)
            obj@AssessmentData(AssessmentType.CorsiBlocks);
            if nargin > 0
                if isnumeric(forward) && isnumeric(reverse)
                    obj.longestForward = forward;
                    obj.longestReverse = reverse;
                    obj.forwardPractice = CorsiBlocksTrialData.empty;
                    obj.forwardTrials = CorsiBlocksTrialData.empty;
                    obj.reversePractice = CorsiBlocksTrialData.empty;
                    obj.reverseTrials = CorsiBlocksTrialData.empty;
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end

        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_CorsiBlocks_*.txt' ]);
            
            if isempty(detailFiles)
                error('No CorsiBlocks Detail files!');
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
                splitString = strsplit(tline,',', 'CollapseDelimiters', false);

                stage = str2double(splitString{1});
                %trialNum = str2double(splitString{2});
                targetSequence = splitString{3};
                inputSequence = splitString{4};
                clearCount = str2double(splitString{5});
                presentationEndTime = str2double(splitString{6});
                responseSubmitTime = str2double(splitString{7});

                responseTime = responseSubmitTime - presentationEndTime;
        
                if (stage == 1)
                    obj.forwardPractice(end+1) = CorsiBlocksTrialData(targetSequence, inputSequence, true, clearCount, responseTime);
                elseif(stage == 2)
                    obj.forwardTrials(end+1) = CorsiBlocksTrialData(targetSequence, inputSequence, true, clearCount, responseTime);
                elseif(stage == 3)
                    obj.reversePractice(end+1) = CorsiBlocksTrialData(targetSequence, inputSequence, false, clearCount, responseTime);
                elseif(stage == 4)
                    obj.reverseTrials(end+1) = CorsiBlocksTrialData(targetSequence, inputSequence, false, clearCount, responseTime);
                end

                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end