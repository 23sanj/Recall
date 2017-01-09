function [rmse] = compute_rmse(B_list,Models_rho,R_list,M_list,X)
%This function calculates the rmse over the entire dataset for the given A for all subjects:
rhos= linspace(0.1,2,20);
nSubs = size(M_list,1);
Y_hat_list = cell(nSubs,numel(rhos));
residuals_list = cell(nSubs,numel(rhos));
rmse = zeros(numel(rhos),1);
for k = 1:nSubs
    t=1;
    for rho=rhos %For each rho
        B= B_list(k,t);
        R= R_list(k,t);
        M= M_list(k,t);
        if (isempty(B) == 0)
            continue;
        end
        A = Models_rho{t};
   
        [Y_hat,err] = forward2(B,A,R,M,X);
        Y_hat_list(k,t) = Y_hat;
        residuals_list(k,t) = err;
        t=t+1;
    end
end  
 
t=1;
for rho=rhos
    residuals =cell2mat(residuals_list(:,t));
    rmse(t,1) = sqrt(sum(residuals.*residuals)/length(residuals));
    t=t+1;
end

save('residuals_list.mat','residuals_list');
save('Y_hat_list.mat','Y_hat_list');
save('rmse.mat','rmse');

plot(rhos,rmse);
title('rmse vs rho');
xlabel('rho');
ylabel('rmse');

end

