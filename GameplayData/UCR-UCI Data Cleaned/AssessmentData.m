classdef AssessmentData < handle
%A base class for storing information on perfomance on an individual assessment
    properties
        assessmentType
    end

    methods
        function obj = AssessmentData(assessmentType)
            if nargin > 0
                if isa(assessmentType, 'AssessmentType')
                    obj.assessmentType = assessmentType;
                else
                    error('Wrong value types');
                end
            else
                error('Wrong argument count');
            end
        end
    end
end