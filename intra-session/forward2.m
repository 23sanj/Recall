function [Y_hat,err] = forward2(Pi,B,A,R,M)
T= size(B,1);
N= size(B,2);
Y_hat = zeros(T,1);
alpha = zeros(T,N);
Mean_B = zeros(1,N);
%Pi= zeros(1,N);
%Pi(1)=1;
%Pi(2:end) = 0;
%Mean over time:
for i=1:N
    Mean_B(:,i) = sum(B(:,i).*(R./M));
end
%Computing alpha:
scale = zeros(1,T); %Scaling

alpha(1,:) = Pi(1,:).*B(1,:);  %alpha at t=1
scale(1) = 1 ./ sum(alpha(1, :));
alpha(1,:) = alpha(1, :) * scale(1); 

for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* B(t, :);
    scale(t) = 1 ./ sum(alpha(t, :));
    alpha(t, :) = alpha(t, :) * scale(t);
end

Y_hat =  alpha*Mean_B'; %Summing over all states

%Compute error:
Ratio = R./M
err= (Y_hat-Ratio);
end

