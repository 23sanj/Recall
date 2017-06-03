function [Y_hat,err] = forward2(Pi,B,A,R,M,n_backs,rho,c)
T= size(B,1);
N= size(B,2);

Y_hat = zeros(T,1);
%Mean over time:--the irt eqn 
[alpha,beta,scale,scale_beta] = alpha_beta_pass(A,Pi,B);

X= linspace(1,9,9);
q_plug = rho*(X- n_backs); 
map_fn = c + (1.0 - c)./ ( 1.0 + exp(-q_plug));
for t=1:T
    Y_hat(t,1)=sum(alpha(t,:).*map_fn(t,:));
end

%Compute error:
Ratio = R./M
err= (Y_hat-Ratio);

end

