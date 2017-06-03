% The purpose of each iteration of a Kalman filter is to update
% the estimate of the state vector of a system (and the covariance
% of that vector) based upon the information in a new observation.
%State Space: 1 D states.
%INPUT: A--Dynamics Matrix--1 x 1 matrix
%       C-- Output Matrix-- 1 x 1 matrix
%       y-- One Observation sequence
%       Q-- The dynamics noise covariance
%       R-- Observation Noise Covariance
%       x0-- initial state mean
%       V0-- initial state Covariance
%
%OUTPUT: xf-- filtered estimates of mean
%        Vf-- filtered estimates of variance
%        Pf-- filtered estimates of covariance
%        loglik--loglikelihood

function [xf,Vf,Pf,loglik,err,Predicted_Values,Pr] = kalman_filter(A,C,B,D,u,Q,R,y,x0,V0,dim)

T = length(y); %The total number of time-steps
xf= zeros(dim,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,dim,T);
err = zeros(dim,T);
Predicted_Values = zeros(dim,T);
loglik = 0;
for t=1:T
    if t == 1
        x_prev = x0;
        V_prev = V0;
    else
        x_prev = x;
        V_prev = V;
    end
    %Performing a kalman-update::
    %Prediction step: A-priori estimate
    x_hat = A*x_prev + B*u(t);
    V_hat = A*V_prev*A' + Q;
    
    %Compute Kalman Gain:
    Cov_est = C*V_hat*C'; %Variance in estimates
    Cov_res= R; %Variance in measurements
    S = Cov_est + Cov_res;%Innovation covariance
    
    S_inv =inv(S);
    K = V_hat*C'*S_inv; 
    
    %Compute error:
    e= y(t)- (C*x_hat + D*u(t));
    Predicted_Values(:,t) = (C*x_hat + D*u(t));
    err(:,t) =e;    
    %Update Step:
    x = x_hat + K*e;
    V= (eye(dim) - K*C)*V_hat;
    P= A*V*(eye(dim) - K*C);
    
    xf(:,t) =x;
    Vf(:,:,t) =V;
    Pf(:,:,t) =P;
    
    %lag-one-cov
   % Pf_future(:,:,t+1)= (eye(dim) - K*C)*A*V_prev;
    
    %Calculate log-likelihood -- pdf of 'e' with mean=0 and covariance S
    % prediction error and its variance can be used the construct the likelihood function
    %p = mvnpdf(e, zeros(1,length(e)), S); 
    %LL= log(p);
    LL = -0.5*(log(2*pi) + log(abs(det(S))) + e'*(S_inv)*e);
    %LL = -gaussian_prob(e, zeros(1,length(e)), S, 1);
    loglik= loglik + LL;
     if t==T-1
        Pr = (eye(dim) - K*C)*V*A;
    end
end


end

