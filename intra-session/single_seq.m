function [Pi_hat,numer,denom,logP] = single_seq(A,Pi,B)

%For multiple sequences-- Add together the frequencies of induvidual sequences

[alpha,beta,scale] = alpha_beta_pass(A,Pi,B);

T= size(B,1);
N= size(B,2);

numer = zeros(size(A));
denom = zeros(size(A,1),1);

Pi_hat =zeros(N,1); %Re-estimated Pi

for i=1:N
  for j=1:N
        for t=1:T-1
            numer(i,j)= numer(i,j) + alpha(t,i)*A(i,j)*B(t+1,j)*beta(t+1,j);
        end
  end
        %for t=1:T-1
            %denom(i) = denom(i) + alpha(t,i)*beta(t,i)/scale(t); 
        %end
   denom(i) =sum(numer(i,:)); 
end 

%For Pi:
Pi_hat(:,1)=  alpha(1,:).*beta(1,:)/scale(1); %Check??

logP=0;
for t=1:T
    if scale(t) == 0
        continue;
    else
        logP= logP + log(scale(t));
    end
    
end

logP = -logP;%log likelihood of data
%P= exp(logP);

end



