function [A] = baum_welch_cont(P_SEQ)
%Step 1: Initializing the matrices
N= size(P_SEQ,2);
T= size(P_SEQ,1);

err = 1e-4;

%Initializing A and Pi -- Making sure that elements are non uniform
A = 1/N*rand(N,N); % A ~ 1/N
A_s = sum(A,2);
for i=1:N
    A(i,:) = A(i,:)./A_s(i); %So that the rows sum up to 1
end

Pi = 1/N*rand(1,N); % Pi ~ 1/N
Pi = Pi./sum(Pi); %So that the rows sum up to 1

maxIters = 10; %Maximum number of re-estimation iterations
it = 1;

logPold = 0;
%Estmate:
[A,logP] = reestimate_A(A,Pi,P_SEQ); %Here logP  is the log-likelihood

while it< maxIters && abs(logPold - logP) >= err
    logPold = logP;
    [A,logP] = reestimate_A(A,Pi,P_SEQ); %Re-estimate the model
    it = it + 1;
end


end

