classdef SymmetrySpanTrialData
%A class for storing information on SymmetrySpan Trials
    properties
        sequence
        responseSequence
        symmetrySequence
        symmetryResponseSequence
        responseTime
        clearCount
        correctResponse
        symmPerc
    end
    
    methods
        function obj = SymmetrySpanTrialData(sequence, responseSequence, symmetrySequence, symmetryResponseSequence, responseTime, clearCount)
            if nargin > 0
                obj.sequence = sequence;
                obj.responseSequence = responseSequence;
                obj.symmetrySequence = symmetrySequence;
                obj.symmetryResponseSequence = symmetryResponseSequence;
                obj.responseTime = responseTime;
                obj.clearCount = clearCount;

                if (strcmp(sequence,responseSequence))
                    obj.correctResponse = 1;
                else
                    obj.correctResponse = 0;
                end

                obj.symmPerc = sum(~(symmetrySequence-symmetryResponseSequence))/length(symmetrySequence);
            else
                error('Wrong argument count');
            end
        end
    end
end