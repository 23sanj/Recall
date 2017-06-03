%Script to analyze Recollect/Lameback assessment data from UCI Study


dataDir = 'CleanedData/RLB';

subjectFolders = dir(dataDir);

subjectData = SubjectData.empty;


for i=1:length(subjectFolders)
    targetedData = {};
    
    subj = subjectFolders(i);
    %Skip files, "this folder", and "parent folder"
    if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
        continue;
    end

    summaryFiles = dir([dataDir '/' subj.name '/*_Summary_*.txt']);
    assessmentSummaryFiles = dir([dataDir '/' subj.name '/*_AssessmentSummary_*.txt']);

    if (isempty(summaryFiles) && isempty(assessmentSummaryFiles))
        % because no summary files Skipping
        continue;
    end

    subjectData(end+1) = SubjectData(subj.name);

    for j=1:length(assessmentSummaryFiles)
        assessmentSummaryFile=assessmentSummaryFiles(j);
        %Skip non-files
        if(assessmentSummaryFile.isdir ~= 0)
            continue;
        end

        splitName = strsplit(assessmentSummaryFile.name,'_');

        if (length(splitName) < 4)
            %Something Odd.... Skipping...
            continue;
        end

        assessmentNumber = str2double(splitName{2});
        
        subjectDataDirectory = [dataDir '/' subj.name];
        fileName = [dataDir '/' subj.name '/' assessmentSummaryFile.name];

        assessmentIndex = length(subjectData(end).assessmentSessions) + 1;
        matchingAssessmentFound = false;

        for k=1:length(subjectData(end).assessmentSessions)
            if (subjectData(end).assessmentSessions(k).sessionNumber == assessmentNumber)
                assessmentIndex = k;
                matchingAssessmentFound = true;
                display(['Appending Assessment for subject: ' subj.name]);
            end
        end

        if ~matchingAssessmentFound
            subjectData(end).assessmentSessions(assessmentIndex) = AssessmentSession(subj.name,assessmentNumber, subjectDataDirectory);
        end

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
            subjectData(end).assessmentSessions(assessmentIndex).ParseSummaryLine(tline);
            
            tline = fgetl(fid);
        end

        fclose(fid);
    end

end


save subjectData;

