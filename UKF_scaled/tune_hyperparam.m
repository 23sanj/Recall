function [] = tune_hyperparam(data_list,n_backs_list,M_list,R_list)
    a_list = linspace(0,2,20);
    Models_A = cell(20,1);
    Models_B = cell(20,1);
    Models_Q = cell(20,1);
    Models_R = cell(20,1);
    Models_x0 = cell(20,1);
    Models_V0 = cell(20,1);
    log_lik = zeros(20,1);
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

        Models_A{j} = A_rr{idx};
        Models_B{j} = B_rr{idx};
        Models_Q{j} = Q_rr{idx};
        Models_R{j} = R_rr{idx};
        Models_x0{j} = x0_rr{idx};
        Models_V0{j} = V0_rr{idx};
        log_lik(j,1) =loglik;
    end

save('Models_A.mat','Models_A');
save('Models_B.mat','Models_B');
save('Models_Q.mat','Models_Q');
save('Models_R.mat','Models_R');
save('Models_x0.mat','Models_x0');
save('Models_V0.mat','Models_V0');
save('log_lik.mat','log_lik');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_A{x};
B =  Models_B{x};
Q =  Models_Q{x};
R =  Models_R{x};
x0 =  Models_x0{x};
V0 =  Models_V0{x};

picked_a = a_list(x);

save('A.mat','A');
save('B.mat','B');
save('Q.mat','Q');
save('R.mat','R');
save('x0.mat','x0');
save('V0.mat','V0');

save('picked_a.mat','picked_a');

end

