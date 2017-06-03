%Script to rename old format files to the new, better format

%Formats for AssessmentSummary:
%Old: USERNAME_{DATETIME}_AssessmentSummary.txt
%New: USERNAME_SessionNumber_AssessmentSummary_{DATETIME}.txt

%Formats for Summary:
%Old: USERNAME_{DATETIME}_Summary.txt
%New: USERNAME_SessionNumber_Summary_{DATETIME}.txt

%Formats for Assessments:
%Old: USERNAME_AssessmentName_GameNum_{DATETIME}.txt
%New: USERNAME_SessionNumber_GameNum_AssessmentName_{DATETIME}.txt

%Formats for Lameback:
%Old: USERNAME_LameBack_GameNum_{DATETIME}.txt
%New: USERNAME_SessionNumber_GameNum_LameBack_{DATETIME}.txt


dataDir = 'CleanedData';

studyDirs = dir(dataDir);

PRINT_CHANGES = 1;
PRINT_COMMAND = 2;
EXECUTE_COMMAND = 3;

testStage = EXECUTE_COMMAND;


%Formats for AssessmentSummary:
%Old: USERNAME_{DATETIME}_AssessmentSummary.txt
%New: USERNAME_SessionNumber_AssessmentSummary_{DATETIME}.txt
display(' ');
display(' ');
display('Changing AssessmentSummaries');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end

        assessmentSummaryFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_AssessmentSummary.txt']);
        for j=1:length(assessmentSummaryFiles)
            targetFile=assessmentSummaryFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1) {'000'} {'AssessmentSummary'} splitName(2:end-1)];

            newName = [strjoin(splitName,'_') '.txt'];

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end

    end
end

%Formats for Summary:
%Old: USERNAME_{DATETIME}_Summary.txt
%New: USERNAME_SessionNumber_Summary_{DATETIME}.txt
display(' ');
display(' ');
display('Changing Summaries');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end

        summaryFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_Summary.txt']);
        for j=1:length(summaryFiles)
            targetFile=summaryFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1) {'000'} {'Summary'} splitName(2:end-1)];

            newName = [strjoin(splitName,'_') '.txt'];

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end

    end
end

%Formats for Lameback:
%Old: USERNAME_LameBack_GameNum_{DATETIME}.txt
%New: USERNAME_SessionNumber_GameNum_LameBack_{DATETIME}.txt
display(' ');
display(' ');
display('Changing LameBack');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end

        lamebackFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_LameBack_0*.txt']);
        for j=1:length(lamebackFiles)
            targetFile=lamebackFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1) {'000'} splitName(3) splitName(2) splitName(4:end)];

            newName = strjoin(splitName,'_');

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end
    end
end

%Formats for Assessments:
%Old: USERNAME_AssessmentName_GameNum_{DATETIME}.txt
%New: USERNAME_SessionNumber_GameNum_AssessmentName_{DATETIME}.txt
display(' ');
display(' ');
display('Changing Assessments');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end

        assessmentFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_SymmetrySpan_0*.txt']);
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_NearTransferTask_0*.txt'])];
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_MatrixReasoning_0*.txt'])];
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_LetterNumberSpan_0*.txt'])];
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_HeartsAndFlowers_0*.txt'])];
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_D2_0*.txt'])];
        assessmentFiles = [assessmentFiles; dir([dataDir '/' studyDir.name '/' subj.name '/*_CorsiBlocks_0*.txt'])];
        for j=1:length(assessmentFiles)
            targetFile=assessmentFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1) {'000'} splitName(3) splitName(2) splitName(4:end)];

            newName = strjoin(splitName,'_');

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end

    end
end

%Formats for Assessment Action Logs:
%Old: USERNAME_AssessmentName_Action_GameNum_{DATETIME}.txt
%New: USERNAME_SessionNumber_GameNum_AssessmentName_{DATETIME}.txt
display(' ');
display(' ');
display('Changing Assessment Action Logs');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end
        
        assessmentActionFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_D2_Action_0*.txt']);
        for j=1:length(assessmentActionFiles)
            targetFile=assessmentActionFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1) {'000'} splitName(4) splitName(2) splitName(3) splitName(5:end)];

            newName = strjoin(splitName,'_');

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end
    end
end

%Formats for Lameback:
%Old: USERNAME_SessionNumber_008_LameBack_{DATETIME}.txt
%New: USERNAME_SessionNumber_000_LameBack_{DATETIME}.txt
display(' ');
display(' ');
display('Correcting Sameday LameBack Non-Listeners');
display(' ');
display(' ');
for l=1:length(studyDirs)
    studyDir = studyDirs(l);

    if((studyDir.isdir ~= 1) || (strcmp(studyDir.name,'.') == 1) || (strcmp(studyDir.name,'..') == 1) )
        continue;
    end

    subjectFolders = dir([dataDir '/' studyDir.name ]);

    for i=1:length(subjectFolders)
        subj = subjectFolders(i);
        %Skip files, "this folder", and "parent folder"
        if((subj.isdir ~= 1) || (strcmp(subj.name,'.') == 1) || (strcmp(subj.name,'..') == 1) )
            continue;
        end

        lamebackFiles = dir([dataDir '/' studyDir.name '/' subj.name '/*_008_LameBack_*.txt']);
        for j=1:length(lamebackFiles)
            targetFile=lamebackFiles(j);
            %Skip non-files
            if(targetFile.isdir ~= 0)
                continue;
            end

            splitName = strsplit(targetFile.name,'_');

            if (length(splitName) < 4)
                error(['This filename does not make sense: ' targetFile.name]);
            end

            splitName = [splitName(1:2) {'000'} splitName(4:end)];

            newName = strjoin(splitName,'_');

            oldFileName = [dataDir '/' studyDir.name '/' subj.name '/' targetFile.name];
            newFileName = [dataDir '/' studyDir.name '/' subj.name '/' newName];

            switch testStage
            case PRINT_CHANGES
                display(['Old Name:   ' targetFile.name] );
                display(['  New Name: ' newName] );
            case PRINT_COMMAND
                display(['movefile(\"' oldFileName '\",\"' newFileName '\");'] );
            case EXECUTE_COMMAND
                movefile(oldFileName, newFileName)
            end
        end
    end
end



