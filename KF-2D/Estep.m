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
function [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,x1,V1,loglik] = Estep(A,B,C,D,u,Q,R,y,x0,V0,dim)
%dim = 1; %since x is 1 dimensional
T = length(y); %The total number of time-steps

xs= zeros(2,1,T);
Vs= zeros(2,2,T);
Ps= zeros(2,2,T);

y=y';

%Step 1: Call the kalman filter
[xf,Vf,Pf,loglik,err,Predicted_Values,P_future] = kalman_filter(A,B,C,D,u,Q,R,y,x0,V0,dim);

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

S_xx = zeros(2, 2);
S_xb = zeros(2, 2);
S_bb = zeros(2, 2);
S_yy = zeros(1, 1);
S_yx = zeros(1, 2);
S_yu = zeros(1,1);
S_xu1 = zeros(2, 1);
S_bu = zeros(2, 1);
S_uu1 = zeros(1, 1);
S_uu2 = zeros(1, 1);
S_xu2 = zeros(2, 1);

for t=1:T
  S_xx = S_xx + Vs(:,:,t) + xs(:,t)*xs(:,t)'; 
  S_yy = S_yy + y(:,t)*y(:,t)';
  S_yx = S_yx + y(:,t)*xs(:,t)';
  S_yu = S_yu + y(:,t)*u(t)';
  S_xu2 = S_xu2 + xs(:,t)*u(t)';
  S_uu2 = S_uu2 + u(t)*u(t);
  if t>1 
    S_xb = S_xb +  P(:,:,t) + xs(:,t)*xs(:,t-1)'; 
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

