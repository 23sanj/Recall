function [A_,Pi_,lik] = reestimate_A(A,Pi,B_list)
A_ = zeros(size(A));
N = size(A,1);
K= numel(B_list);

    %Call the function to calculate the values of numer, denom and
    %likelihood for training sequence k

sum_numer = zeros(N,N);
sum_denom = zeros(N,1);
sum_Pi_hat = zeros(N,1);
lik = 0;
P_list = cell(K,1);
       for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
            [Pi_hat,numer,denom,logP] =single_seq(A,Pi,B);
            P_list{k} = logP;
            sum_numer = sum_numer + numer; 
            if abs(sum(sum(numer)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            sum_Pi_hat = sum_Pi_hat + Pi_hat;
            lik = lik + logP;%Calculate total likelihood of data:/exp(logP)
        end

Pi_ = sum_Pi_hat./sum(sum_Pi_hat);
    totalTransitions = sum(sum_numer,2);

    A_ = sum_numer./(repmat(totalTransitions,1,N));

save('P_list.mat','P_list');

end



