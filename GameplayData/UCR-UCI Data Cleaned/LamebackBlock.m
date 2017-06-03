classdef LamebackBlock < handle
%Structure to contain all the data for one Lameback Block
    properties
        trials = 0
        hits = 0
        misses = 0
        fa = 0
        nLevel = 0
        lureRate = 0
    end

    methods
        function obj = LamebackBlock(trials, hits, misses, fa, nLevel, lureRate)
            if nargin > 0
                if isnumeric(trials) && isnumeric(hits) && isnumeric(misses) && ...
                isnumeric(fa) && isnumeric(nLevel) && isnumeric(lureRate)
                    obj.trials = trials;
                    obj.hits = hits;
                    obj.misses = misses;
                    obj.fa = fa;
                    obj.nLevel = nLevel;
                    obj.lureRate = lureRate;
                else
                    error('Wrong argument type');
                end
            end
        end
    end
end