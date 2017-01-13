function [A_,logP] = reestimate_A(A,Pi,P_SEQ)
A_ = zeros(size(A));

[alpha,beta,scale] = alpha_beta_pass(Pi,A,P_SEQ);

T= size(P_SEQ,1);
N= size(P_SEQ,2);

for i=1:N
  for j=1:N
     denom=0;numer=0;
     for t=1:T-1
        numer = numer + alpha(t,i)*A(i,j)*P_SEQ(t+1,j)*beta(t+1,j);
        denom = denom + (alpha(t,i)*beta(t,i)/scale(t)); 
     end
     A_(i,j) = exp(log(numer)- log(denom));
   end
end    


logP= -sum(log(scale));%likelihood of data


end



