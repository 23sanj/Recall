%Function that calculates both forward and backward passes and computes
%expected sufficient statistics for a single observation sequence
%State Space: 1 D states.
%INPUT: A--Dynamics Matrix--1 x 1 matrix
%       C-- Output Matrix-- 1 x 1 matrix
%       y-- One Observation sequence
%       Q-- The dynamics covariance
%       R-- Noise Covariance
%       x0-- initial state mean
%       V0-- initial state Covariance
%
%OUTPUT:Sufficient statistics
function [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,S_yg,S_yg2,x1,V1,loglik] = Estep(A,B,u,Q,R,y,x0,V0,M,Rt,dim)
%dim = size(A,1); %since x is 1 dimensional
T = length(y); %The total number of time-steps

xs= zeros(dim,T);
Vs= zeros(dim,dim,T);
Ps= zeros(dim,1,T);

y=y';

%Step 1: Call the kalman filter
[xf,Vf,Pf,loglik,err,Y_hat,S] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt);

%Step 2: Backward Pass-- The Kalman Smoother and the lag-one-covariance
%smoother
xs(:,T) =xf(:,T);
Vs(:,:,T) =Vf(:,:,T);

for t=T-1:-1:1
    [xs(:,t),Vs(:,:,t),Ps(:,:,t+1)] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),Vf(:,:,t+1), Pf(:,:,t+1), A, Q,B,u(t));    
end

Ps(:,:,1) = zeros(dim,1);


%Computing the expected sufficient statistics for a sequence

S_xx = zeros(dim, dim);
S_xb = zeros(dim, dim);
S_bb = zeros(dim, dim);
S_yy = zeros(1, 1);
S_yx = zeros(dim, dim);
S_yu = zeros(dim, dim);
S_xu1 = zeros(dim, 1);
S_bu = zeros(dim, 1);
S_uu1 = zeros(1, 1);
S_uu2 = zeros(dim, dim);
S_xu2 = zeros(dim, dim);
S_yg = zeros(1,1);
S_yg2 = zeros(1,1);

%need to change

for t=1:T
   m = M(t);
   r=Rt(t);
    [WC,WM,X]  =calc_sigmapoints(xs(:,t),Vs(:,:,t),dim);
    Y_sig = zeros(2*dim+1,1);
    for j=1:2*dim+1
       Y_sig(j) = g(X(1,j),u(t),m,r,X(2,j));
    end
    Y_hat = 0;
    Y_cov =0;
    P_cov=0;
    x_hat = zeros(dim,1);
    x_hat_prev = zeros(dim,1);
    for i=1:size(X,2)
      Y_hat = Y_hat + WM(i) * Y_sig(i);
      x_hat = x_hat + WM(i) * X(:,i);
    end
     for i=1:size(X,2)
      Y_cov = Y_cov + WC(i) * (Y_sig(i) - Y_hat) * (Y_sig(i) - Y_hat)';
      if t>1
        P_cov = P_cov + WC(i) * (X(:,i) - x_hat) * (X(:,i) - x_hat_prev)';
      end
    end
  
  S_xx = S_xx + Vs(:,:,t) + xs(:,t)*xs(:,t)'; 
  S_yy = S_yy + y(t)*y(t)';
  S_yx = S_yx + y(t)*xs(:,t)';
  S_yu = S_yu + y(t)*u(t)';
  S_xu2 = S_xu2 + xs(:,t)*u(t)';
  S_uu2 = S_uu2 + u(t)*u(t)';
  S_yg = S_yg + y(t)*Y_hat';
  S_yg2 = S_yg2 + (Y_hat*Y_hat) + Y_cov; 
  if t>1 
    S_xb = S_xb  + P_cov +xs(:,t)*xs(:,t-1)'; 
    S_bb = S_bb + Vs(:,:,t-1) + xs(:,t-1)*xs(:,t-1)'; 
    S_xu1 = S_xu1 + xs(:,t)*u(t-1)';
    S_bu = S_bu + xs(:,t-1)*u(t-1)';
    S_uu1 = S_uu1 + u(t-1)*u(t-1)';
  end
  x_hat_prev= x_hat;
end
S_bx = S_xb';
S_xy = S_yx';
S_uy = S_yu';
S_ux1 = S_xu1';
S_ub = S_bu';
S_ux2 = S_xu2';

x1 = xs(:,1);
V1 = Vs(:,:,1);



end

