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

function [xf,Vf,Pf,loglik,err,Predicted_Values,S_t] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt)

T = length(y); %The total number of time-steps
xf= zeros(dim,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,1,T);
err = zeros(1,T);
S_t= zeros(T,1);
Predicted_Values = zeros(1,T);
loglik = 0;
for t=1:T
    m = M(t);
    r= Rt(t);
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
    
    %Calculating sigma points
    [WC,WM,X] =calc_sigmapoints(x_hat,V_hat,dim);
    %Propagating the sigma vectors through the non linear function
    Y_sig = zeros(2*dim+1,1);
    for j=1:2*dim+1
       Y_sig(j) = g(X(1,j),u(t),m,r,X(2,j));
    end
   
    C  = zeros(size(x_hat,1),1);
    Y_hat = 0;
    S=0;
    for i=1:size(X,2)
      Y_hat = Y_hat + WM(i) * Y_sig(i);
    end
    for i=1:size(X,2)
      S = S + WC(i) * (Y_sig(i) - Y_hat) * (Y_sig(i) - Y_hat)';
      C = C + WC(i) * (X(:,i) - x_hat) * (Y_sig(i) - Y_hat)';
    end
    S = S + R;
     %compute Kalamn Gain
    K = C/S; 
    
    Predicted_Values(t) = Y_hat;
    e = y(t)-Predicted_Values(t);
    err(:,t) =e;    
    %Update Step:
    x = x_hat + K*e;
    V= V_hat - K*S*K';
    
    %I = eye(2);
    %V= V + eps*I; %To ensure matrix doesn't underflow
    
    xf(:,t) =x;
    Vf(:,:,t) =V;
    Pf(:,:,t) =C;
    
    
    %lag-one-cov
   % Pf_future(:,:,t+1)= (eye(dim) - K*C)*A*V_prev;
    
    %Calculate log-likelihood -- pdf of 'e' with mean=0 and covariance S
    % prediction error and its variance can be used the construct the likelihood function
    %p = mvnpdf(e, zeros(1,length(e)), S); 
    %LL= log(p);
    LL = -0.5*(log(2*pi) + log(abs(det(S))) + (e'/S)*e);
    %LL = -gaussian_prob(e, zeros(1,length(e)), S, 1);
    loglik= loglik + LL;
end
end

