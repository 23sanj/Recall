function [alpha,beta,scale] = alpha_beta_pass(A,P_SEQ)
%Compute alpha and the scale
N= size(P_SEQ,2);
T= size(P_SEQ,1);

B= P_SEQ';
alpha = zeros(T,N);
beta = ones(T,N);


Pi = zeros(1,N); % Pi ~ 1/N
Pi(1) = 1; 
Pi(2:end) =0;

scale = zeros(1,T); %Scaling

alpha(1,:) = Pi .*P_SEQ(1,:);  %alpha at t=1
scale(1) = 1 ./ sum(alpha(1, :));
alpha(1,:) = alpha(1, :) * scale(1);

for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* P_SEQ(t, :);
    if sum(alpha(t,:)) == 0
        scale(t) = 0;
        alpha(t, :) = 0;
    else
        scale(t) = 1 ./ sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) * scale(t);
    end
end

beta(T, :) = scale(T);

for t = (T-1):-1:1
    beta(t,:) = A * (B(:,t+1) .* beta(t+1,:)');
    beta(t, :) = beta(t, :) * scale(t);
end
end
