function [Y_hat,rms] = forward(P_SEQ,A,R,M,X)

T= size(P_SEQ,1);
N= size(P_SEQ,2);

Y_hat = zeros(T,1);

alpha = zeros(T,N);
scale = zeros(1,T); %Scaling

%Initializing alpha
alpha(1,1) =1;
alpha(1,2:end) = 0;
alpha(2:end,2:end) = 0;
Mean_P_SEQ = P_SEQ*X';
%Computing alpha:
for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* P_SEQ(t,:);
    scale(t) = 1 ./ sum(alpha(t, :));
    alpha(t, :) = alpha(t, :) * scale(t);
end

for t=1:T
    Y_hat(t) = sum(alpha(t,:).*Mean_P_SEQ(t));
end

%Compute error:

diff = (Y_hat-R);
rms = zeros(size(M));
for t=1:numel(M)
   rms(t) = diff(t)/M(t);
end

%Scaling--or no scaling doesn't make a difference
rms = rms.^2;

end

