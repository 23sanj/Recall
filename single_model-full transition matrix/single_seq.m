function [Pi_hat,numer,denom,logP] = single_seq(A,Pi,B)

%For multiple sequences-- Add together the frequencies of induvidual sequences

[alpha,beta,scale,scale_beta] = alpha_beta_pass(A,Pi,B);

logf = log(alpha);
logb = log(beta);
logGTR = log(A);
logGE = log(B);

T= size(B,1);
N= size(B,2);

numer = zeros(size(A));
denom = zeros(size(A,1),1);

Pi_hat =zeros(N,1); %Re-estimated Pi
for t=1:T-1
    addition = zeros(N,N); % addition for each time-step
for i=1:N
  for j=1:N
        addition (i,j) = exp( logf(t,i) + logGTR(i,j) + logGE(t+1,j) + logb(t+1,j));
            
  end
end 
    addition = addition/sum(sum(addition));
    numer= numer + addition;
end
%For Pi:
Pi_hat(:,1)=  exp( logf(1,:) + logb(1,:)); %Check??%P = sum(alpha(:,t).*beta(:,t))*scale*scale_beta;
Pi_hat = Pi_hat/sum(Pi_hat);

logP = - sum(log(scale));%log likelihood of data

end



