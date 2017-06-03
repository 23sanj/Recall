function [] = compare_rmse(data_list,n_backs_list,R_list,M_list,subList)
a_list = linspace(0,2,20);
rmse = zeros(20,1);
log_lik=zeros(20,1);
for j=1:numel(a_list)
   a= a_list(j);
   log_P = zeros(5,1);
    A_rr = cell(5,1);
    C_rr = cell(5,1);
    B_rr = cell(5,1);
    D_rr = cell(5,1);
    Q_rr = cell(5,1);
    R_rr = cell(5,1);
    x0_rr = cell(5,1);
    V0_rr = cell(5,1);
    
    LL = [];
    A_L=[];
    B_L=[];
    Q_L=[];
    R_L=[];
    x0_L=[];
    V0_L=[];
   for i=1:5 %Random Restarts to avoid getting stuck in local maxima
        [A, B, Q, R,x0, V0, loglik] = learn_kalman(data_list,n_backs_list,M_list,R_list,LL,A_L,B_L,Q_L,R_L,x0_L,V0_L,a);
        A_rr{i} = A;
        B_rr{i} = B;
        Q_rr{i} = Q;
        R_rr{i} = R;
        x0_rr{i} = x0;
        V0_rr{i} = V0;
        log_P(i) = loglik;
   end

    [loglik,idx] =max(log_P);

    A = A_rr{idx};
    B = B_rr{idx};
    Q = Q_rr{idx};
    R = R_rr{idx};

    x0 = x0_rr{idx};
    V0 = V0_rr{idx};
   
    rmse(j,1)= compute_rmse(x0,V0,A,B,M_list,R_list,Q,R,n_backs_list,data_list,subList,a);
    log_lik(j,1) = loglik;
    
end

save('rmse.mat','rmse');
save('log_lik.mat','log_lik');

end

