classdef CancellationTaskRowData
%A class for storing information on the Cancellation Task Row Data
    properties
        lastChar
        hits
        misses
        fa
        cr
        sequence
        responses
    end
    
    methods
        function obj = CancellationTaskRowData(lastChar, hits, misses, fa, cr, sequence, responses)
            if nargin > 0
                obj.lastChar = lastChar; 
                obj.hits = hits; 
                obj.misses = misses; 
                obj.fa = fa; 
                obj.cr = cr; 
                obj.sequence = sequence; 
                obj.responses = responses; 
            else
                error('Wrong argument count');
            end
        end
    end
end