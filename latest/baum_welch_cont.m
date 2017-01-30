function [A,Pi,loglik] = baum_welch_cont(X,B_list)
%Step 1: Initializing the matrices
N= size(X,2);
err = 1e-3;

%Initializing A and Pi -- Making sure that elements are non uniform
%A = rand(N);
%A = tril(A);

%A_u = triu(A)-triu(A,2);
%A= A_l+ A_u;
A =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A_s = sum(A,2);
   
   for i=1:N
        A(i,:) = A(i,:)./A_s(i);
   end
   Pi = repmat(1/N,N,1); % Pi ~ 1/N



%Pi = rand(1,N); % Pi ~ 1/N
%Pi= Pi./sum(Pi);

maxIters = 20; %Maximum number of re-estimation iterations
it = 1;

logliks = zeros(maxIters,1);

logPold = -Inf;

 x=0;y=0;z=0;
for i=2:N-1
    x= x + A(i,i-1);
    y= y + A(i,i);
     z= z + A(i,i+1);
end

for i=2:N-1
   A(i,i-1) = x;
   A(i,i) = y;
   A(i,i+1) = z;
end     
   

%Estmate:
[A,Pi,logP] = reestimate_A(A,Pi,B_list); %Here logP  is the log-likelihood
x=0;y=0;z=0;
for i=2:N-1
    x= x + A(i,i-1);
    y= y + A(i,i);
     z= z + A(i,i+1);
end

for i=2:N-1
   A(i,i-1) = x;
   A(i,i) = y;
   A(i,i+1) = z;
end     
   
    
converged = false;
while it< maxIters 
      if (abs(logPold - logP)/(1+abs(logPold))) < err
         A  = A./sum(A,2);
         Pi  = Pi./sum(Pi);
         converged = true;
         break;
      end
    
        logPold = logP;
        [A,Pi,logP] = reestimate_A(A,Pi,B_list); %Re-estimate the model
        x=0;y=0;z=0;
        for i=2:N-1
            x= x + A(i,i-1);
            y= y + A(i,i);
             z= z + A(i,i+1);
        end

        for i=2:N-1
           A(i,i-1) = x;
           A(i,i) = y;
           A(i,i+1) = z;
        end
        logliks(it) = logP;
           
         it = it + 1;
end

logliks(logliks ==0) = [];
loglik = max(logliks);

save('logliks.mat','logliks');
save('loglik.mat','loglik');

end

