function [rmse] = compute_rmse(subList,B_list,A,Pi,R_list,M_list,n_backs_list,rho_subject,c_subject,d_subject)
%This function calculates the rmse over the entire dataset for the given A for all subjects:
nSubs = numel (M_list);
Y_hat_list = cell(nSubs,1);
Ratio = cell(nSubs,1);
residuals_list = cell(nSubs,1);
difficulty = cell(nSubs,1);
for k = 1:nSubs
    if (isempty(B_list{k}) == 1)
       continue;
    end
    files=subList{k}
    subject_name= strsplit(files(1).name,{'Rlb*_','_'},'CollapseDelimiters',true);
    subject_name=subject_name{1};
    B= B_list{k};
    R= R_list{k};
    M= M_list{k};
    if nargin < 8 
        rho_subject = cell(nSubs,1);
        c_subject = cell(nSubs,1);
         d_subject = cell(nSubs,1);
        [rho_subject{:}] = deal(1.9);
        [c_subject{:}] = deal(0.3684);
        [d_subject{:}] = deal(1);
    end
    n_backs = n_backs_list{k};
    rho = rho_subject{k};
    c = c_subject{k};
    d = d_subject{k};
    [Y_hat,err,diff] = forward2(Pi,B,A,R,M,n_backs,rho,c,d,subject_name);
    difficulty{k} = diff;
    Y_hat_list{k} = Y_hat;
    residuals_list{k} = err;
    Ratio{k} = R./M;
end

R= cell2mat(R_list);
M= cell2mat(M_list);

residuals = cell2mat(residuals_list);
rmse = sqrt(sum(residuals.*residuals)/length(residuals));
save('residuals_list.mat','residuals_list');
save('Predicted Values.mat','Y_hat_list');
save('Actual Values.mat','Ratio');
save('difficulty.mat','difficulty');
save('rmse.mat','rmse');
end

