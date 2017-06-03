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

function [xf,Vf,Pf,loglik,err,Predicted_Values,S_t] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt,a)

T = length(y); %The total number of time-steps
xf= zeros(dim,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,dim,T);
err = zeros(dim,T);
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
    
    alpha =10^-4;%exp(-3); %spread of sigma points around the mean
    beta = 2; %incoroporate prior knowledge of x--gaussian=2
    kappa = 0;
    lambda = (alpha*alpha)*(1+kappa)-1;
   % Calculate the sigma points and there corresponding weights using the Scaled Unscented Transformation
    X_0 = x_hat;
    X_1 = x_hat + sqrt((1+lambda)*V_hat);
    X_2 = x_hat - sqrt((1+lambda)*V_hat);
    
    Wm_0 = lambda/(1+lambda);
    Wm_1 = 1/(2*(1+lambda));
    Wm_2 = 1/(2*(1+lambda));
    
    Wc_0 = Wm_0 +(1-(alpha*alpha) +beta);
    Wc_1 = Wm_1;
    Wc_2 = Wm_2;
    
    %Propagating the sigma vectors through the non linear function
    Y_0 = g(X_0,u(t),m,r,a);
    Y_1 = g(X_1,u(t),m,r,a);
    Y_2 = g(X_2,u(t),m,r,a);
    
    
    Y_hat = Wm_0*Y_0 + Wm_1*Y_1 +Wm_2*Y_2; %Weighted sample mean
    Cov_est =  Wc_0*(Y_0 - Y_hat)*(Y_0 - Y_hat)' + Wc_1*(Y_1 - Y_hat)*(Y_1 - Y_hat)' + Wc_2*(Y_2 - Y_hat)*(Y_2 - Y_hat)'; %weighted sample covariance
    S_t(t,1) = Cov_est;
    
    S= Cov_est+R;
    
     P = Wc_0*(X_0 - x_hat)*(Y_0 - Y_hat)' + Wc_1*(X_1 - x_hat)*(Y_1 - Y_hat)' + Wc_2*(X_2 - x_hat)*(Y_2 - Y_hat)';
   
     %compute Kalamn Gain
    K = P/S; 
    
    Predicted_Values(t) = Y_hat;
    e = y(t)-Predicted_Values(t);
    err(:,t) =e;    
    %Update Step:
    x = x_hat + K*e;
    V= V_hat - K*S*K';
    
    
    xf(:,t) =x;
    Vf(:,:,t) =V;
    Pf(:,:,t) =P;
    
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

