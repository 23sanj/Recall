function [P_SEQ,X] = compute_emission_prob_with_effort(M,R,n_backs,rho,c,d,eff)
%SEQ is a matrix returned, where every row corresponds to a sequence of a session. 
%is a matrix of sequences for all sessions.
%Control input: z= m, n_back
%Latent variable : x 
%Sequence of observations: y=r (Number got right)
%time: t-- per session
X= linspace(1,9,9); %Fixing the range of alpha-between 1-4: nbacks are 1-4
N = size(X,2);
n_X = size(X,2);
n_sessions = numel(n_backs); %The number of sessions for a subject
P_SEQ = zeros(n_sessions,n_X);
for i=1:n_sessions
    %Applying item response theory:
    %rho = 0.2; %The discrimination parameter is set for now
    n_back = n_backs(i); 
    r = R(i);
    m = M(i);
    %IRT model:
    %c = 0.2105;
    q_plug = rho*(X- n_back);
    q= c + (1.0 - c)./ ( 1.0 + exp(-q_plug)); % a vector with 20 values corresponding to the probability 
     pos_q = q.^r; %taking logs as the probabiltities are small
    neg_q =(1-q).^(m-r);
    
    P_SEQ(i,:) =nchoosek(m,r).*pos_q .*neg_q; %Warning Generated:Result may not be exact. Coefficient is greater than 9.007199e+15 and is only accurate to 15 digits
    
    for j=1:N
        P_SEQ(i,j) = eff*P_SEQ(i,j) + (1-eff)*P_SEQ(i,round(j/2));
    end
end 

end
