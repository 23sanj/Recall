function [A,Pi] = baum_welch_cont(X,B_list)
%Step 1: Initializing the matrices
N= size(X,2);
err = 1e-3;

%Initializing A and Pi -- Making sure that elements are non uniform
A = 1/N*rand(N,N); % A ~ 1/N
A_s = sum(A,2);


for i=1:N
    A(i,:) = A(i,:)./A_s(i); %So that the rows sum up to 1
end

Pi = rand(1,N); % Pi ~ 1/N
Pi = Pi./sum(Pi);

maxIters = 15; %Maximum number of re-estimation iterations
it = 1;

logPold = -Inf;
%Estmate:
[A,Pi,logP] = reestimate_A(A,Pi,B_list); %Here logP  is the log-likelihood

while it< maxIters && abs(logPold - logP) >= err
    %if gt(logPold,logP) == 0
        logPold = logP;
        [A,Pi,logP] = reestimate_A(A,Pi,B_list); %Re-estimate the model
        it = it + 1;
    %else 
     %   break;
    %end
end


end

