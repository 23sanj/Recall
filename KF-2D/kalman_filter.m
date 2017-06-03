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

function [xf,Vf,Pf,loglik,err,Predicted_Values,Pr] = kalman_filter(A,B,C,D,u,Q,R,y,x0,V0,dim)

T = length(y); %The total number of time-steps
xf= zeros(dim,1,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,dim,T);
err = zeros(T,1);
Predicted_Values = zeros(T,1);
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
    x_hat = A*x_prev;%+ B*u(t);
    V_hat = A*V_prev*A' + Q;
    
    %Compute Kalman Gain:
    Cov_est = C*V_hat*C'; %Variance in estimates
    Cov_res= R; %Variance in measurements
    S = Cov_est + Cov_res;%Innovation covariance
    
    %S_inv =inv(S);
    K = V_hat*C'/S; 
    %end
    
    
    %Compute error:
    e= y(t)- (C*x_hat + D*u(t));
    Predicted_Values(t) = (C*x_hat + D*u(t));
    err(t) =e;    
    %Update Step:
    x = x_hat + K*e;
    V= (eye(2) - K*C)*V_hat;
    P= A*V*(eye(2) - K*C);
    
    xf(:,t) =x;
    Vf(:,:,t) =V;
    Pf(:,:,t) =P;
    if t==T-1
        Pr = (eye(dim) - K*C)*V*A;
    end
    LL = -0.5*(log(2*pi) + log(abs(det(S))) + e'/S*e);
    %LL = -gaussian_prob(e, zeros(1,length(e)), S, 1);
    loglik= loglik + LL;
end


end

