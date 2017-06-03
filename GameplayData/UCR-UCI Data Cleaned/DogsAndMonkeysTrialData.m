classdef DogsAndMonkeysTrialData
%A class for storing information on the DogsAndMonkeys Trials
    properties
        target
        stimPosition
        responsePosition
        correctResponse
        responseTime
    end
    
    methods
        function obj = DogsAndMonkeysTrialData(target, stimPosition, responsePosition, responseTime)
            if nargin > 0
                obj.target = target;
                obj.stimPosition = stimPosition;
                obj.responsePosition = responsePosition;
                obj.responseTime = responseTime;

                if responsePosition == -1
                    %Timeout
                    obj.correctResponse = 0;
                elseif (target==1)
                    if (stimPosition == responsePosition)
                        obj.correctResponse = 1;
                    else
                        obj.correctResponse = 0;
                    end
                else
                    if (stimPosition == responsePosition)
                        obj.correctResponse = 0;
                    else
                        obj.correctResponse = 1;
                    end
                end
            else
                error('Wrong argument count');
            end
        end
    end
end