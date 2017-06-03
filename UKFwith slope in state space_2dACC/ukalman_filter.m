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

function [xf,Vf,Pf,loglik,err,Predicted_Values,P] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt)

dimy = size(y,1);
T = length(y); %The total number of time-steps
xf= zeros(dim,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,dimy,T);
err = zeros(dimy,T);
Predicted_Values = zeros(dimy,T);
loglik = 0;
for t=1:T
    m = M(t,:);
    r= Rt(t,:);
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
    Y_sig = zeros(2,2*dim+1);
    for j=1:2*dim+1
       Y_sig(1,j) = g(X(1,j),u(t),m(1,1),r(1,1),X(2,j));
       Y_sig(2,j) = g(X(3,j),u(t),m(1,2),r(1,2),X(4,j));
    end
   
    C  = zeros(dim,dimy);
    Y_hat =  zeros(dimy,1);
    S= zeros(dimy,dimy);
    for i=1:size(X,2)
      Y_hat= Y_hat + WM(i) * Y_sig(:,i);
    end
    for i=1:size(X,2)
      S = S + WC(i) * (Y_sig(:,i) - Y_hat) * (Y_sig(:,i) - Y_hat)';
      C = C + WC(i) * (X(:,i) - x_hat)*(Y_sig(:,i) - Y_hat)';
    end
    S = S + R;
     %compute Kalamn Gain
    K = C/S; 
    
    Predicted_Values(:,t) = Y_hat;
    e = y(:,t)-Predicted_Values(:,t);
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
    if t==T-1
        P = (V - K*S*K')*A;
    end
end
end

