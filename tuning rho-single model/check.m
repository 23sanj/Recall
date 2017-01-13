function [] = check(B_list, R_list,M_list,n_backs_list,subList )

rhos= linspace(0.1,2,20);
c_values = linspace(0,1,20);
Models_rho = cell(20,20);
log_lik = zeros(20,20);

X= linspace(1,9,5); 

t=1;
for rho=rhos %For each rho
    s=1;
    for c=c_values
        [A,loglik]=baum_welch_cont(X,B_list(:,t,s)); %Applying Baum Welch to re-estimate the parameters
        Models_rho{t,s} = A;
        log_lik(t,s) =loglik; %Matrix of liklihood for 20 rhos
        s=s+1;
    end
    t=t+1;
end  
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_rho{x,y};
picked_rho = rhos(x);
picked_c = c_values(y);

save('A.mat','A');
save('log_lik.mat','log_lik');
save('picked_rho.mat','picked_rho');
save('picked_c.mat','picked_c');
save('Models_rho.mat','Models_rho');

end

