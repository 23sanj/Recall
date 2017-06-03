classdef AssessmentSession < handle
%Holds a list of all the assessments performed in one session, as well as relevant metadata
    properties
        subjectName
        sessionNumber
        subjectDataDirectory
        cancellation = 0
        matrixReasoning = 0
        dogsAndMonkeys = 0
        letterNumberSpan = 0
        corsiBlocks = 0
        nearTransfer = 0
        symmetrySpan = 0
    end
    
    methods
        function obj = AssessmentSession(subjectName, sessionNumber, subjectDataDirectory)
            if nargin > 0
                if isnumeric(sessionNumber) && ischar(subjectName) && ischar(subjectDataDirectory)
                    obj.subjectName = subjectName;
                    obj.sessionNumber = sessionNumber;
                    obj.subjectDataDirectory = subjectDataDirectory;
                else
                    error('Wrong Datatypes!');
                end
            end
        end

        function obj = ParseSummaryLine(obj,summaryLine)
            if nargin < 2
                error('Need to pass in one summary Line');
            end

            if strcmp(summaryLine(1),'%')
                return;
            end

            splitString = strsplit(summaryLine,',');

            newAssessmentType = AssessmentType(str2double(splitString{1}));
            assessmentNum = str2double(splitString{2});

            switch newAssessmentType
                case AssessmentType.Cancellation
                    hits = str2double(splitString{3});
                    misses = str2double(splitString{4});
                    fa = str2double(splitString{5});
                    cr = str2double(splitString{6});
                    if (obj.cancellation ~= 0)
                        display(['Overwriting CancellationTaskData for user: ' obj.subjectName]);
                    end
                    obj.cancellation = CancellationTaskData(hits, misses, fa, cr);
                    obj.cancellation.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                case AssessmentType.MatrixReasoning
                    problemSet = splitString{3};
                    hits = str2double(splitString{4});
                    misses = str2double(splitString{5});
                    noresponse = str2double(splitString{6});
                    if (obj.matrixReasoning ~= 0)
                        display(['Overwriting MatrixReasoningTaskData for user: ' obj.subjectName]);
                    end
                    obj.matrixReasoning = MatrixReasoningTaskData(hits, misses, noresponse, problemSet);
                    obj.matrixReasoning.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                case AssessmentType.DogsAndMonkeys
                    hits = str2double(splitString{3});
                    misses = str2double(splitString{4});
                    noresponse = str2double(splitString{5});
                    if (obj.dogsAndMonkeys ~= 0)
                        display(['Overwriting DogsAndMonkeysTaskData for user: ' obj.subjectName]);
                    end
                    obj.dogsAndMonkeys = DogsAndMonkeysTaskData(hits, misses, noresponse);
                    obj.dogsAndMonkeys.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                case AssessmentType.LetterNumberSpan
                    hits = str2double(splitString{3});
                    misses = str2double(splitString{4});
                    if (obj.letterNumberSpan ~= 0)
                        display(['Overwriting LetterNumberSpanTaskData for user: ' obj.subjectName]);
                    end
                    obj.letterNumberSpan = LetterNumberSpanTaskData(hits, misses);
                    obj.letterNumberSpan.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                case AssessmentType.CorsiBlocks
                    forward = str2double(splitString{3});
                    reverse = str2double(splitString{4});
                    if (obj.corsiBlocks ~= 0)
                        display(['Overwriting CorsiBlocksTaskData for user: ' obj.subjectName]);
                    end
                    obj.corsiBlocks = CorsiBlocksTaskData(forward,reverse);
                    obj.corsiBlocks.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                case AssessmentType.NearTransfer
                    blockNum = str2double(splitString{3});
                    trials = str2double(splitString{4});
                    hits = str2double(splitString{5});
                    misses = str2double(splitString{6});
                    fa = str2double(splitString{7});
                    nlevel = str2double(splitString{8});
                    %Near transfer logs many lines in summary files
                    if (obj.nearTransfer == 0)
                        obj.nearTransfer = NearTransferTaskData(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                    end
                    obj.nearTransfer.AddSummaryRow(blockNum,trials,hits,misses,fa,nlevel);
                case AssessmentType.SymmetrySpan
                    longestSeq = str2double(splitString{3});
                    longestSeqCount = str2double(splitString{4});
                    symmetryAccuracy = str2double(splitString{5});
                    if (obj.symmetrySpan ~= 0)
                        display(['Overwriting SymmetrySpanTaskData for user: ' obj.subjectName]);
                    end
                    obj.symmetrySpan = SymmetrySpanTaskData(longestSeq,longestSeqCount,symmetryAccuracy);
                    obj.symmetrySpan.LoadDetailFile(obj.sessionNumber, assessmentNum, obj.subjectDataDirectory);
                otherwise
                    display('Not yet implemented');
            end
        end
    end
end