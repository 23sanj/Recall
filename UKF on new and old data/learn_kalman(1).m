%The EM algorithm applied to the kalman model for dual estimation
function [A, B, Q, R,x0, V0, loglik] = learn_kalman(data,n_backs,M_list,R_list,LL,A_L,B_L,Q_L,R_L,x0_L,V0_L,a)

N = length(data);


%Initializing A, C, Q,R,x0 and V0
A =rand;
B= rand;
%C= rand;
%D=rand;
R=rand;
Q=rand;

x0=(9-1)*rand;
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

threshold = 1e-3;
max_iter =20;
while and(~converged,(iter <= max_iter)) 

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
 Sum_yg = zeros(dim,dim);
 Sum_yg2 = zeros(dim,dim);
Sum_ub = zeros(dim, dim);
  P1sum = zeros(dim, dim);
  x1sum = zeros(dim, 1);
  loglik = 0;
  count=0;
  for s = 1:N
    y = data{s};
    u = n_backs{s};
    M= M_list{s};
    Rt=R_list{s};
    if isempty(y) ~= 0
      continue;
    end 
    [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,S_yg,S_yg2,x1_t,V1_t,loglik_t] = Estep(A,B,u,Q,R,y,x0,V0,M,Rt,a);
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
    Sum_yg = Sum_yg + S_yg;
    Sum_yg2 = Sum_yg2 + S_yg2;
    
    
    P1sum = P1sum + V1_t + x1_t*x1_t';
    x1sum = x1sum + x1_t;
    count=count+1;
    loglik = loglik + loglik_t;
  end
  LL = [LL loglik];
  save('LL.mat','LL');
  iter = iter + 1;
   Tsum1 = Tsum - count;
  %%% M step

  M = [Sum_xb Sum_xu1] /([Sum_bb,Sum_bu;Sum_ub,Sum_uu1]);
  A = M(1);
  B= M(2);
  Q = (Sum_xx - Sum_xb*A' - A*Sum_bx - Sum_xu1*B' - B*Sum_ux1 + A*Sum_bu*B' + B*Sum_ub*A' + A*Sum_bb*A' + B*Sum_uu1*B') / Tsum1;
  
  R = (Sum_yy - Sum_yg - (Sum_yg)' + Sum_yg2)/ Tsum;
  

  x0 = x1sum / count;
  V0 = P1sum/count - x0*x0';
  
  A_L = [A_L A];
  B_L = [B_L B];
  Q_L = [Q_L Q];
  R_L = [R_L R];
  x0_L =[x0_L x0];
  V0_L =[V0_L V0];
  
  
 % We have converged if the slope of the log-likelihood function falls below 'threshold'
%log likelihood should increase
if loglik - previous_loglik == 0
    previous_loglik = loglik;
    continue;
end
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
 save('A_L.mat','A_L');
save('B_L.mat','B_L');
save('Q_L.mat','Q_L');
save('R_L.mat','R_L');

end

