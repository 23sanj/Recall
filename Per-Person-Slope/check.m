function [] = check(B_list )

rhos= linspace(0.1,2,20);
c_values = linspace(0,1,20);
Models_A = cell(20,20);
Models_Pi = cell(20,20);

log_lik = zeros(20,20);


X= linspace(1,9,18); 
t=1;
for rho=rhos %For each rho
    s=1;
    for c=c_values
         A_rr = cell(5,1);
         Pi_rr = cell(5,1);
         ll_rr = zeros(5,1);
        for rr=1:5
           [A,Pi,ll] = baum_welch_cont(X,B_list(:,t,s));%Applying Baum Welch to re-estimate the parameters
            A_rr{rr} = A;
            Pi_rr{rr} = Pi;
            ll_rr(rr) = ll;
        end
            [loglik idx] = max(ll_rr(:));
        
            Models_A{t,s} = A_rr{idx};
            Models_Pi{t,s} = Pi_rr{idx};
            log_lik(t,s) =loglik; %Matrix of liklihood for 20 rhos
        s=s+1;
    end
    t=t+1;
end  
save('log_lik.mat','log_lik');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_A{x,y,:};
Pi =  Models_Pi{x,y};
picked_rho = rhos(x);
picked_c = c_values(y);

save('A.mat','A');
save('Pi.mat','Pi');
save('log_lik.mat','log_lik');
save('picked_rho.mat','picked_rho');
save('picked_c.mat','picked_c');
save('Models_A.mat','Models_A');
save('Models_Pi.mat','Models_Pi');

end

