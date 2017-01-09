function [A_,logP] = reestimate_A(A,B_list)
A_ = zeros(size(A));
N = size(A,1);
K= numel(B_list);

    %Call the function to calculate the values of numer, denom and
    %likelihood for training sequence k

sum_numer = zeros(N,N);
sum_denom = zeros(N,1);
P_list = cell(K,1);
for i=1:N
   for j=1:N
       for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
            [numer,denom,P] =single_seq(A,B);
            P_list{k} = P;
            if denom(i) ~= 0
                sum_numer(i,j) = sum_numer(i,j) + (numer(i,j)/denom(i)); 
            end
        end
   end
    sum_denom(i) =sum(sum_numer(i,:));
end


%Calculate total likelihood of data:
logP =0;
for k=1:K
    if isempty(P_list{k}) == 0
        logP = log(P_list{k}) + logP;
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



