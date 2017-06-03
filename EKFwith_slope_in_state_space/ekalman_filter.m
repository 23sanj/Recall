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

function [xf,Vf,Pf,loglik,G_t,err,Predicted_Values] = ekalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt,a)

T = length(y); %The total number of time-steps
xf= zeros(dim,T);
Vf= zeros(dim,dim,T);
Pf= zeros(dim,dim,T);
err = zeros(dim,T);
Predicted_Values = zeros(dim,T);
loglik = 0;
G_t = zeros(T,dim);
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
    
    %Compute the derivative wrt x at 't':
    m =M(t);
    r= Rt(t);
    %syms x;                       %Call the non-linear function
    G = g_prime(x_hat(1,:),u(t),x_hat(2,:));
    G_t(t) = double(G);
    if isnan(G_t(t))==1 
        %error('derivitive is inf');
        G_t(t) =0;
    end
    %G_t = vpa(G_t); %Higher precision
    %Compute Kalman Gain:
    Cov_est = G_t(t)*V_hat*G_t(t)'; %Variance in estimates
    Cov_res= R; %Variance in measurements
    S = Cov_est + Cov_res;%Innovation covariance
    disp(S)
    
    %Compute error:
    e= y(t)- g(x_hat(1,:),u(t),m,r,x_hat(2,:));
    disp(u(t))
    %S_inv =pinv(S);

    K = V_hat*G_t(t)'/S; 
    
    Predicted_Values(:,t) = g(x_hat(1,:),u(t),m,r,x_hat(2,:));
    err(:,t) =e;    
    %Update Step:
    x = x_hat + K*e;
    V= (eye(dim) - K*G_t(t))*V_hat;
    P= A*V*(eye(dim) - K*G_t(t));
    
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

