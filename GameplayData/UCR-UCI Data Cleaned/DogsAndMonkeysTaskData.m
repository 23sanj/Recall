classdef DogsAndMonkeysTaskData < AssessmentData 
%A class for storing information on the DogsAndMonkeys Task
    properties
        hits
        misses
        noresponse
        dogIntro
        dogPractice
        monkeyIntro
        monkeyPractice
        mixedPractice
        mixedFull
    end
    
    methods
        function obj = DogsAndMonkeysTaskData(hits, misses, noresponse)
            obj@AssessmentData(AssessmentType.DogsAndMonkeys);
            if nargin > 0
                if isnumeric(hits) && isnumeric(misses) && isnumeric(noresponse)
                    obj.hits = hits;
                    obj.misses = misses;
                    obj.noresponse = noresponse;
                    obj.dogIntro = DogsAndMonkeysTrialData.empty;
                    obj.dogPractice = DogsAndMonkeysTrialData.empty;
                    obj.monkeyIntro = DogsAndMonkeysTrialData.empty;
                    obj.monkeyPractice = DogsAndMonkeysTrialData.empty;
                    obj.mixedPractice = DogsAndMonkeysTrialData.empty;
                    obj.mixedFull = DogsAndMonkeysTrialData.empty;
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end

        function LoadDetailFile(obj, sessionNum, assessmentNum, directory)
            detailFiles = dir([directory '/*_' sprintf('%03d',sessionNum) '_' sprintf('%03d',assessmentNum) '_HeartsAndFlowers_*.txt' ]);
            
            if isempty(detailFiles)
                error('No DogsAndMonkeys Detail files!');
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

                stage = str2double(splitString{1});
                trial = str2double(splitString{2});
                target = str2double(splitString{3});
                targetPos = str2double(splitString{4});
                choicePos = str2double(splitString{5});
                timeOfPresentation = str2double(splitString{6});
                timeOfResponse = str2double(splitString{7});

                responseTime = timeOfResponse - timeOfPresentation;
                
                if(stage==1)
                    obj.dogIntro(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                elseif(stage==2)
                    obj.dogPractice(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                elseif(stage==3)
                    obj.monkeyIntro(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                elseif(stage==4)
                    obj.monkeyPractice(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                elseif(stage==5)
                    obj.mixedPractice(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                elseif(stage==6)
                    obj.mixedFull(end+1) = DogsAndMonkeysTrialData(target,targetPos,choicePos,responseTime);
                end

                tline = fgetl(fid);
            end

            fclose(fid);
        end
    end
end