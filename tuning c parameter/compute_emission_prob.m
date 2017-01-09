function [P_SEQ,X] = compute_emission_prob(M,R,n_backs,c)
%SEQ is a matrix returned, where every row corresponds to a sequence of a session. 
%is a matrix of sequences for all sessions.
%Control input: z= m, n_back
%Latent variable : x 
%Sequence of observations: y=r (Number got right)
%time: t-- per session
X= linspace(1,9,5); %Fixing the range of alpha-between 1-4: nbacks are 1-4
n_X = size(X,2);
n_sessions = numel(n_backs); %The number of sessions for a subject
P_SEQ = zeros(n_sessions,n_X);

for i=1:n_sessions
    %Applying item response theory:
   
    n_back = n_backs(i); 
    r = R(i);
    m = M(i);
    %IRT model:
    
    q_plug = 0.5*(X- n_back);
    q= c+ (1.0-c)./ ( 1.0 + exp(-q_plug)); % a vector with 20 values corresponding to the probability 
     pos_q = q.^r; %taking logs as the probabiltities are small
    neg_q =(1-q).^(m-r);
    
    P_SEQ(i,:) =nchoosek(m,r).*pos_q .*neg_q; %Warning Generated:Result may not be exact. Coefficient is greater than 9.007199e+15 and is only accurate to 15 digits
    if find(isnan(P_SEQ(i,:))) ~= 0 
       P_SEQ(i,find(isnan(P_SEQ(i,:))))=0;
    end
    if find(isinf(P_SEQ(i,:))) ~= 0 
       P_SEQ(i,find(isinf(P_SEQ(i,:))))=1;
    end
    
    %P_SEQ(i,:) = P_SEQ(i,:)./sum(P_SEQ(i,:)); %Normalizing to make them Probabilities 
    
end 
for i=1:n_X
    if sum(P_SEQ(:,i)) == 0
         P_SEQ(:,i) = 0;
    else
         P_SEQ(:,i) = P_SEQ(:,i)./sum(P_SEQ(:,i)); %Normalizing to make them Probabilities 
    end
end
end
