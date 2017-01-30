function [A_,Pi_,logP] = reestimate_A(A,Pi,B_list)
A_ = zeros(size(A));
N = size(A,1);
K= numel(B_list);

    %Call the function to calculate the values of numer, denom and
    %likelihood for training sequence k

sum_numer = zeros(N,N);
sum_denom = zeros(N,1);
sum_Pi_hat = zeros(N,1);

P_list = cell(K,1);
for i=1:N
   for j=1:N
       for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
            [Pi_hat,numer,denom,P] =single_seq(A,Pi,B);
            P_list{k} = P;
            if denom(i) ~= 0
                sum_numer(i,j) = sum_numer(i,j) + (numer(i,j)/denom(i)); 
            end
            sum_Pi_hat(i) = sum_Pi_hat(i) + Pi_hat(i);
        end
   end
    sum_denom(i) =sum(sum_numer(i,:));
end

Pi_ = sum_Pi_hat./sum(sum_Pi_hat);
%Calculate total likelihood of data:
logP =0;
for k=1:K
    if isempty(P_list{k}) == 0
        logP = P_list{k} + logP;
    end
end

for i=1:N
       if sum_denom(i) == 0
           A_(i,:) = 0; %No transitions take place from this state, since B(i,t) =0
        else
           A_(i,:) = sum_numer(i,:)./(sum_denom(i));
       end
end

save('P_list.mat','P_list');

end



