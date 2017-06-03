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
function [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,S_yg,S_yg2,x1,V1,loglik] = Estep(A,B,u,Q,R,y,x0,V0,M,Rt,a,dim)
%dim = size(A,1); %since x is 1 dimensional
y=y';
dimy=size(y,1);
T = length(y); %The total number of time-steps

xs= zeros(dim,T);
Vs= zeros(dim,dim,T);
P= zeros(dim,dim,T);
%Step 1: Call the kalman filter
[xf,Vf,Pf,loglik,err,Y_hat,P_future] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt);

%Step 2: Backward Pass-- The Kalman Smoother and the lag-one-covariance
%smoother
xs(:,T) =xf(:,T);
Vs(:,:,T) =Vf(:,:,T);

P(:,:,T) = P_future;
for t=T-1:-1:1
    if t==T-1
        [xs(:,t),Vs(:,:,t),J] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),A, Q,B,u(t)); 
        continue;
    end
    [xs(:,t),Vs(:,:,t),J,P(:,:,t+1)] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),A, Q,B,u(t),P(:,:,t+2),J);
end



%Computing the expected sufficient statistics for a sequence

S_xx = zeros(dim, dim);
S_xb = zeros(dim, dim);
S_bb = zeros(dim, dim);
S_yy = zeros(dimy, dimy);
S_yx = zeros(dimy, dim);
S_yu = zeros(dimy, 1);
S_xu1 = zeros(dim, 1);
S_bu = zeros(dim, 1);
S_uu1 = zeros(1, 1);
S_uu2 = zeros(dim, dim);
S_xu2 = zeros(dim, dim);
S_yg = zeros(dimy,dimy);
S_yg2 = zeros(dimy,dimy);

%need to change

for t=1:T
   m =M(t,:);
   r=Rt(t,:);
    [WC,WM,X]  =calc_sigmapoints(xs(:,t),Vs(:,:,t),dim);
    Y_sig = zeros(dimy,2*dim+1);
    for j=1:2*dim+1
       Y_sig(1,j) = g(X(1,j),u(t),m(1,1),r(1,1),X(2,j));
       Y_sig(2,j) = g(X(3,j),u(t),m(1,2),r(1,2),X(4,j));
    end
    Y_hat = zeros(dimy,1);
    Y_cov =zeros(dimy,dimy);
    for i=1:size(X,2)
      Y_hat = Y_hat + WM(i) * Y_sig(:,i);
    end
     P_cov =0;
     for i=1:size(X,2)
      Y_cov = Y_cov + WC(i) * (Y_sig(i) - Y_hat) * (Y_sig(i) - Y_hat)';
      if t>1
         P_cov = P_cov + WC(i) * (X(:,i) - xs(:,t)) * (X(:,i) - xs(:,t-1))';
      end
    end
  
  
  S_xx = S_xx + Vs(:,:,t) + xs(:,t)*xs(:,t)'; 
  S_yy = S_yy + y(:,t)*y(:,t)';
  S_yx = S_yx + y(:,t)*xs(:,t)';
  S_yu = S_yu + y(:,t)*u(t)';
  S_xu2 = S_xu2 + xs(:,t)*u(t)';
  S_uu2 = S_uu2 + u(t)*u(t)';
  S_yg = S_yg + y(:,t)*Y_hat';
  S_yg2 = S_yg2 + (Y_hat*Y_hat') + Y_cov; 
  if t>1 
    S_xb = S_xb + P_cov + xs(:,t)*xs(:,t-1)'; 
    S_bb = S_bb + Vs(:,:,t-1) + xs(:,t-1)*xs(:,t-1)'; 
    S_xu1 = S_xu1 + xs(:,t)*u(t-1)';
    S_bu = S_bu + xs(:,t-1)*u(t-1)';
    S_uu1 = S_uu1 + u(t-1)*u(t-1)';
  end
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

