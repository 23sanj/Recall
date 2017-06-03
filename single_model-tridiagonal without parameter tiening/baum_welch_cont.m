function [A,Pi,logP] = baum_welch_cont(X,B_list)
%Step 1: Initializing the matrices
N= size(X,2);
err = 1e-6;

%Initializing A and Pi -- Making sure that elements are non uniform
%A = 1/N*rand(N,N); % A ~ 1/N
A =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A_s = sum(A,2);

for i=1:N
    A(i,:) = A(i,:)./A_s(i); %So that the rows sum up to 1
end

 Pi = rand(N,1); % Pi ~ 1/N
Pi= Pi./sum(Pi);

maxIters = 20; %Maximum number of re-estimation iterationslogP
it = 1;

logliks = zeros(maxIters,1);

logPold = -Inf;
%Estmate:
%[A,Pi,logP] = reestimate_A(A,Pi,B_list); %Here logP  is the log-likelihood
converged = false;
for it =1: maxIters
        [A_,Pi_,logP] = reestimate_A(A,Pi,B_list); %Re-estimate the model
        
        if logP < logPold 
           logP = logPold;
           warning('Error. The log-likelihood must go up!');
           break;
        end
        
     
      if (abs(logPold - logP)/(1+abs(logPold))) < err
          if norm(A_ - A,inf)/N < err
             converged = true;
              A = A_;
              Pi = Pi_;
              break;
          end
     end
      A = A_;
      Pi = Pi_;
      logPold = logP;
    logliks(it) = logP;
    it = it + 1;
end

logliks(logliks ==0) = [];
loglik = max(logliks);

save('logliks.mat','logliks');
save('loglik.mat','loglik');

end

