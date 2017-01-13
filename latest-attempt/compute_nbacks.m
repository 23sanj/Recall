function [N_BACK] = compute_nbacks()

nbacks= load('n_backs.mat');
%Find models with 0 nbcaks
idx = cellfun(@(x) nnz(0 == x) > 0 ,nbacks);
find(idx);
end

