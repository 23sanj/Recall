function [rmse] = compute_rmse(B_list,A,Pi,R_list,M_list,n_backs_list)
%This function calculates the rmse over the entire dataset for the given A for all subjects:
nSubs = numel (M_list);
Y_hat_list = cell(nSubs,1);
Ratio = cell(nSubs,1);
residuals_list = cell(nSubs,1);
for k = 1:nSubs
    if (isempty(B_list{k}) == 1)
       continue;
    end
    B= B_list{k};
    R= R_list{k};
    M= M_list{k};
    n_backs = n_backs_list{k};
    rho=1.6;
    c=0.0;
    d=1;
    [Y_hat,err] = forward2(Pi,B,A,R,M,n_backs,rho,c,d);
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
save('rmse.mat','rmse');
end

