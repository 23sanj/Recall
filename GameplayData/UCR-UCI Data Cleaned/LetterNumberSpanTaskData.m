classdef LetterNumberSpanTaskData < AssessmentData 
%A class for storing information on the LetterNumberSpan Task
    properties
        hits
        misses
        practice
        trials
    end
    
    methods
        function obj = LetterNumberSpanTaskData(hits, misses)
            obj@AssessmentData(AssessmentType.LetterNumberSpan);
            if nargin > 0
                if isnumeric(hits) && isnumeric(misses)
                    obj.hits = hits;
                    obj.misses = misses;
                    obj.practice = LetterNumberSpanTrialData.empty;
                    obj.trials = LetterNumberSpanTrialData.empty;
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end

        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_LetterNumberSpan_*.txt' ]);
            
            if isempty(detailFiles)
                error('No LetterNumberSpan Detail files!');
            end

            if (length(detailFiles) > 1)
                error('More than one detail file!');
            end

            detailFile = detailFiles(1);

            fileName = [directory '/' detailFile.name];

            practice = true;
            lastTrialNum = -1;

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

                trialNum = str2double(splitString{1});
                sequence = splitString{2};
                letterInput = splitString{3};
                numberInput = splitString{4};
                %presentationStartTime = str2double(splitString{5});
                presentationEndTime = str2double(splitString{6});
                responseSubmitTime = str2double(splitString{7});

                if (practice && (trialNum > lastTrialNum))
                    lastTrialNum = trialNum;
                else
                    practice = false;
                end
                

                if (practice)
                    obj.practice(end+1) = LetterNumberSpanTrialData(sequence, letterInput, numberInput, presentationEndTime, responseSubmitTime);
                else
                    obj.trials(end+1) = LetterNumberSpanTrialData(sequence, letterInput, numberInput, presentationEndTime, responseSubmitTime);
                end
                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end