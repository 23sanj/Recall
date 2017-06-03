%The EM algorithm applied to the kalman model for dual estimation
function [A, C, B, D, Q, R, x0, V0, loglik] = learn_kalman(data,n_backs)

N = length(data);


%Initializing A, C, Q,R,x0 and V0
A =rand;
B= rand;
C= rand;
D=rand;
R=rand;
Q=rand;

x0=rand;
V0=rand;

dim =size(A,1);

Tsum = 0;
for s = 1:N
  y = data{s};
  if isempty(y) ~= 0
      continue;
  end
  T =size(y,1);
  Tsum = Tsum + T;
end


previous_loglik = -inf;
loglik = 0;
converged = 0;
iter = 1;
LL = [];
threshold = 1e-3;
max_iter =20;
while ~converged & (iter <= max_iter) 

  %%% E step
  
  Sum_xx = zeros(dim, dim);
Sum_xb = zeros(dim, dim);
Sum_bb = zeros(dim, dim);
Sum_yy = zeros(dim, dim);
Sum_yx = zeros(dim, dim);
Sum_yu = zeros(dim, dim);
Sum_xu1= zeros(dim, dim);
Sum_bu= zeros(dim, dim);
Sum_uu1= zeros(dim, dim);
Sum_uu2=zeros(dim, dim);
Sum_xu2=zeros(dim, dim);
Sum_bx= zeros(dim, dim);
Sum_xy =zeros(dim, dim);
Sum_uy= zeros(dim, dim);
Sum_ux1= zeros(dim, dim);
 Sum_ux2 = zeros(dim, dim);
Sum_ub = zeros(dim, dim);
  P1sum = zeros(dim, dim);
  x1sum = zeros(dim, 1);
  loglik = 0;
  count=0;
  for s = 1:N
    y = data{s};
    u = n_backs{s};
    if isempty(y) ~= 0
      continue;
    end 
    [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,x1_t,V1_t,loglik_t] = Estep(A,C,B,D,u,Q,R,y,x0,V0);
    Sum_xx = Sum_xx + S_xx;
    Sum_xb = Sum_xb + S_xb;
    Sum_bb = Sum_bb + S_bb;
    Sum_yy = Sum_yy + S_yy;
    Sum_yx = Sum_yx + S_yx;
    Sum_yu = Sum_yu + S_yu;
    Sum_xu1 = Sum_xu1 + S_xu1;
    Sum_bu = Sum_bu + S_bu;
    Sum_uu1 = Sum_uu1 + S_uu1;
    Sum_uu2 = Sum_uu2 + S_uu2;
    Sum_xu2 = Sum_xu2 + S_xu2;
    Sum_bx = Sum_bx + S_bx;
    Sum_xy = Sum_xy + S_xy;
    Sum_uy = Sum_uy + S_uy;
    Sum_ux1 = Sum_ux1 + S_ux1;
    Sum_ux2 = Sum_ux2 + S_ux2;
    Sum_ub = Sum_ub + S_ub;
    
    
    P1sum = P1sum + V1_t + x1_t*x1_t';
    x1sum = x1sum + x1_t;
    
    loglik = loglik + loglik_t;
    
    count = count + 1;
  end
  LL = [LL loglik];
  save('LL.mat','LL');
  iter = iter + 1;
   Tsum1 = Tsum - count;
  %%% M step
  M = [Sum_xb Sum_xu1] *(inv([Sum_bb,Sum_bu;Sum_ub,Sum_uu1]));
  A = M(1);
  B= M(2);
  Q = (Sum_xx - Sum_xb*A' - A*Sum_bx - Sum_xu1*B' - B*Sum_ux1 + A*Sum_bu*B' + B*Sum_ub*A' + A*Sum_bb*A' + B*Sum_uu1*B') / Tsum1;
  
  O= [Sum_yx Sum_yu] *(inv([Sum_xx,Sum_xu2;Sum_ux2,Sum_uu2]));
  C = O(1);
  D= O(2);
  R = (Sum_yy - Sum_yx*C' - C*Sum_xy - Sum_yu*D' - D*Sum_uy + C*Sum_xu2*D' + D*Sum_ux2*C' + C*Sum_xx*C' + D*Sum_uu2*D') / Tsum;
  

  x0 = x1sum / count;
  V0 = P1sum/count - x0*x0';
  
  % We have converged if the slope of the log-likelihood function falls below 'threshold'
%log likelihood should increase
if loglik - previous_loglik < -1e-3 % allow for a little imprecision
 fprintf(1, '******likelihood decreased from %6.4f to %6.4f!\n', previous_loglik,loglik);
end
delta_loglik = abs(loglik - previous_loglik);
avg_loglik = (abs(loglik) + abs(previous_loglik) + eps)/2;
if (delta_loglik / avg_loglik) < threshold
 converged = 1;
 plot(LL);
else 
converged = 0; 
plot(LL);
end 
  previous_loglik = loglik;
end

end

