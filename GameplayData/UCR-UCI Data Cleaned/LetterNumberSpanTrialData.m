classdef LetterNumberSpanTrialData
%A class for storing information on a LetterNumberSpan Trial
    properties
        sequence
        letterInput
        numberInput
        responseTime
        correctResponse
    end
    
    methods
        function obj = LetterNumberSpanTrialData(sequence, letterInput, numberInput, presentationEndTime, responseSubmitTime)
            if nargin > 0
                obj.sequence = sequence;
                obj.letterInput = letterInput;
                obj.numberInput = numberInput;
                obj.responseTime = responseSubmitTime - presentationEndTime;

                correctLetterSeq = '';
                correctNumSeq = '';

                for i=1:length(sequence)
                    if (sequence(i) >= 'A' && sequence(i) <= 'Z' )
                        correctLetterSeq(end+1) = char(sequence(i));
                    elseif (sequence(i) >= '0' && sequence(i) <= '9' )
                        correctNumSeq(end+1) = char(sequence(i));
                    end
                end

                correctLetterSeq = sort(correctLetterSeq);
                correctNumSeq = sort(correctNumSeq);

                if (strcmp(correctLetterSeq,letterInput) && strcmp(correctNumSeq,numberInput))
                    obj.correctResponse = 1;
                else
                    obj.correctResponse = 0;
                end
            else
                error('Wrong argument count');
            end
        end
    end
end