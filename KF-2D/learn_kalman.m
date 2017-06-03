%The EM algorithm applied to the kalman model for dual estimation
function [A,B, C, D, Q, R, x0, V0, loglik] = learn_kalman(data,n_backs,dim)

N = length(data);


%Initializing A, C, Q,R,x0 and V0
A = rand(2,2);
B= rand(2,1);%[rand;rand]%[rand,rand;0,1];
C= rand(1,2);
D= rand;
R= rand;
Q=[rand,0;0,rand];

x0= rand(2,1);
V0= [rand,0;0,rand];

%dim =size(A,1);

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
max_iter =10;
while ~converged & (iter <= max_iter) 

  %%% E step
  
Sum_xx = zeros(2, 2);
Sum_xb = zeros(2, 2);
Sum_bb = zeros(2, 2);
Sum_yy = zeros(1, 1);
Sum_yx = zeros(1, 2);
Sum_yu = zeros(1,1);
Sum_xu1= zeros(2, 1);
Sum_bu= zeros(2, 1);
Sum_uu1= zeros(1, 1);
Sum_uu2=zeros(1, 1);
Sum_xu2=zeros(2, 1);

Sum_bx= zeros(2, 2);
Sum_xy =zeros(2,1);

Sum_uy= zeros(1,1);
Sum_ux1= zeros(1,2);

 Sum_ux2 = zeros(1,2);
Sum_ub = zeros(1,2);
  P1sum = zeros(2, 2);
  x1sum = zeros(2, 1);
  loglik = 0;
  count=0;
  for s = 1:N
    data1= data{s};
   % y=[data1,repmat(1,size(data1,1),1)];
    y=data1;
    n_back = n_backs{s}
    u = n_back;
    if isempty(data1) ~= 0
      continue;
    end 
    [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,x1_t,V1_t,loglik_t] = Estep(A,B,C,D,u,Q,R,y,x0,V0,dim);
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
  A = M(:,1:2);
  B= M(:,3);
 % A_temp = Sum_xb/Sum_bb;
  %A(1,1)=A_temp(1,1);
  %A(1,2)=A_temp(1,2);
  %B(1,1) = B_temp(1,1);
  Q = (Sum_xx - Sum_xb*A' - A*Sum_bx - Sum_xu1*B' - B*Sum_ux1 + A*Sum_bu*B' + B*Sum_ub*A' + A*Sum_bb*A' + B*Sum_uu1*B') / Tsum1;
   O= [Sum_yx Sum_yu] *(inv([Sum_xx,Sum_xu2;Sum_ux2,Sum_uu2]));
  C = O(1,1:2);
  D= O(1,3);

  R = (Sum_yy - C*Sum_xy - Sum_yx*C' - Sum_yu*D' - D*Sum_uy' + C*Sum_xu2*D' + D*Sum_ux2*C' + C*Sum_xx*C' + D*Sum_uu2*D') / Tsum;
  

  x0 = x1sum/ count;
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

