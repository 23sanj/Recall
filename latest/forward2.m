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
B=B';

fs = zeros(N,T);

bs = ones(T,N);
s = zeros(1,T);
%fs(1,1) = 1;  % assume that we start in state 1.

fs = zeros(N,T);
s = zeros(1,T);
%fs(1,1) = 1;  % assume that we start in state 1.

fs(:,1) = Pi(:).*B(:,1);  %alpha at t=1
s(1) = sum(fs(:, 1));
fs(:,1) = fs(:,1) ./ s(1);

%s(1) = 1;
for count = 2:T
    for state = 1:N
        fs(state,count) = B(state,count) .* (sum(fs(:,count-1) .*A(:,state)));
    end
    % scale factor normalizes sum(fs,count) to be 1. 
    s(count) =  sum(fs(:,count));
    fs(:,count) =  fs(:,count)./s(count);
end


Y_hat = Mean_B*fs; %Summing over all states
Y_hat = Y_hat';
%Compute error:
Ratio = R./M
err= (Y_hat-Ratio);

end

