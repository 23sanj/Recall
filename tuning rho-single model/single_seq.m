function [numer,denom,P] = single_seq(A,B)

%For multiple sequences-- Add together the frequencies of induvidual sequences

[alpha,beta,scale] = alpha_beta_pass(A,B);

T= size(B,1);
N= size(B,2);

numer = zeros(size(A));
denom = zeros(size(A,1),1);

for i=1:N
  for j=1:N
        for t=1:T-1
            numer(i,j)= numer(i,j) + alpha(t,i)*A(i,j)*B(t+1,j)*beta(t+1,j);
        end
  end
   denom(i) =sum(numer(i,:)); 
end    

logP=0;
for t=1:T
    if scale(t) == 0
        continue;
    else
        logP= logP + log(scale(t));
    end
    
end

logP = -logP;%log likelihood of data
P= exp(logP);

end



