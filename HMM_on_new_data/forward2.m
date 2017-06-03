function [Y_hat,err,diff] = forward2(Pi,B,A,R,M,n_backs,rho,c,d,subject_name)
T= size(B,1);
N= size(B,2);

Y_hat = zeros(T,1);
%Mean over time:--the irt eqn 
[alpha] = alpha_beta_pass(A,Pi,B);

X= linspace(1,48,96);

q_plug = rho*(X- n_backs); 
map_fn = c + (d - c)./ ( 1.0 + exp(-q_plug));
for t=1:T
    Y_hat(t,1)=sum(alpha(t,:).*map_fn(t,:));
end

%Compute error:
Ratio = R./M
%From the expected value of acciuracy-- the difficulty is offset
[diff] = exportblocksexcel(subject_name);
if isempty(diff) == 0
    for i=1:size(diff,1)
        b= str2num(diff{i,1})+1;
        d= str2num(diff{i,2});
        Y_hat(b,1) = Y_hat(b,1);
    end
end

err= (Y_hat-Ratio);

end

