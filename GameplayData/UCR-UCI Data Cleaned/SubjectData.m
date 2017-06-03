classdef SubjectData < handle
%Structure to contain all the data for one subject
    properties
        name
        assessmentSessions
    end

    methods
        function obj = SubjectData(val)
            if nargin > 0
                if ischar(val)
                    obj.name = val;
                    obj.assessmentSessions = AssessmentSession.empty;
                else
                    error('Name must be a string');
                end
            end
        end
    end
end