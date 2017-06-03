classdef SymmetrySpanTaskData < AssessmentData 
%A class for storing information on the SymmetrySpan Task
    properties
        longestSeq
        longestSeqHitCount
        symmetryAccuracy
        sequencePractice
        taskPractice
        task
        symmetryPracticePattern
        symmetryPracticeResponse
        symmetryPracticeResponseTime
    end
    
    methods
        function obj = SymmetrySpanTaskData(longestSeq, longestCount, symmetryAccuracy)
            obj@AssessmentData(AssessmentType.SymmetrySpan);
            if nargin > 0
                if isnumeric(longestSeq) && isnumeric(longestCount) && isnumeric(symmetryAccuracy)
                    obj.longestSeq = longestSeq;
                    obj.longestSeqHitCount = longestCount;
                    obj.symmetryAccuracy = symmetryAccuracy;
                    obj.sequencePractice = SymmetrySpanTrialData.empty;
                    obj.taskPractice = SymmetrySpanTrialData.empty;
                    obj.task = SymmetrySpanTrialData.empty;
                    obj.symmetryPracticePattern = '';
                    obj.symmetryPracticeResponse = '';
                    obj.symmetryPracticeResponseTime = [];
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end
        
        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_SymmetrySpan_*.txt' ]);
            
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
                splitString = strsplit(tline,',', 'CollapseDelimiters', false);

                stage = str2double(splitString{1});
                %trialNum = str2double(splitString{2});
                %seqLength = str2double(splitString{3});
                targetSequence = splitString{4};
                responseSequence = splitString{5};
                symmetrySequence = splitString{6};
                symmetryResponseSequence = splitString{7};
                clearCount = str2double(splitString{8});
                timeOfSymmetryPresentation = str2double(splitString{10});
                timeOfResponsePrompt = str2double(splitString{11});
                timeOfResponseSubmission = str2double(splitString{12});

                responseTime = timeOfResponseSubmission - timeOfResponsePrompt;
                symmetryResponseTime = timeOfResponseSubmission - timeOfSymmetryPresentation;
                
                %Just need to update values on NavDir of 0.
                if (stage == 3)
                    %SequencePractice
                    obj.sequencePractice(end+1) = SymmetrySpanTrialData(targetSequence, responseSequence, symmetrySequence, symmetryResponseSequence, responseTime, clearCount);
                elseif (stage == 10)
                    %SymmetryPractice
                    obj.symmetryPracticePattern = [obj.symmetryPracticePattern symmetrySequence];
                    obj.symmetryPracticeResponse = [obj.symmetryPracticeResponse symmetryResponseSequence];
                    obj.symmetryPracticeResponseTime(end+1) = symmetryResponseTime;
                elseif (stage == 13)
                    %TaskPractice
                    obj.taskPractice(end+1) = SymmetrySpanTrialData(targetSequence, responseSequence, symmetrySequence, symmetryResponseSequence, responseTime, clearCount);
                elseif (stage == 14)
                    %Task
                    obj.task(end+1) = SymmetrySpanTrialData(targetSequence, responseSequence, symmetrySequence, symmetryResponseSequence, responseTime, clearCount);
                end

                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end