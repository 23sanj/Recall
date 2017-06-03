function [x0, V0] = check2(A,B,Q,R,data_list,n_backs,M_list,R_list)

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
max_iter =10;
while ~converged & (iter <= max_iter) 

  %%% E step
  
 
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
    [x1_t,V1_t,loglik_t] = Estep(A,B,u,Q,R,y,x0,V0,M,Rt);
    
    
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
  M = [Sum_xb Sum_xu1] *(inv([Sum_bb,Sum_bu;Sum_ub,Sum_uu1]));
  A = M(1);
  B= M(2);
  Q = (Sum_xx - Sum_xb*A' - A*Sum_bx - Sum_xu1*B' - B*Sum_ux1 + A*Sum_bu*B' + B*Sum_ub*A' + A*Sum_bb*A' + B*Sum_uu1*B') / Tsum1;
  
  R = (Sum_yy - Sum_yg - (Sum_yg)' + Sum_yg2)/ Tsum;
  

  x0 = x1sum / count;
  V0 = P1sum/count - x0*x0';
  
  x0_L = [A_L A];
  V0_L = [B_L B];
  Q_L = [Q_L Q];
  R_L = [R_L R];
  

  
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

%Performing a line search for maximum likelihood
[val,idx] = max(LL);
A= A_L(idx);
B= B_L(idx);
Q= Q_L(idx);
R= R_L(idx);
save('A_L.mat','A_L');
save('B_L.mat','B_L');
save('Q_L.mat','Q_L');
save('R_L.mat','R_L');


end

