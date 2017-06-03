classdef CorsiBlocksTrialData
%A class for storing information on a CorsiBlocks Trial
    properties
        sequence
        response
        forward
        correct
        clearCount
        responseTime
    end
    
    methods
        function obj = CorsiBlocksTrialData(sequence, response, forward, clearCount, responseTime)
            if nargin > 0
                obj.sequence = sequence;
                obj.response = response;
                obj.forward = forward;
                obj.clearCount = clearCount;
                obj.responseTime = responseTime;

                if (forward)
                    if (strcmp(sequence,response))
                        obj.correct = 1;
                    else
                        obj.correct = 0;
                    end
                else
                    if (strcmp(sequence,fliplr(response)))
                        obj.correct = 1;
                    else
                        obj.correct = 0;
                    end
                end
            else
                error('Wrong argument count');
            end
        end
    end
end