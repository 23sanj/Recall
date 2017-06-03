%Function to simulate synthetic data

function [A1, C1, B1, D1, Q1, R1, x0_1, V0_1, loglik1] = simulate_synthetic_data(x0,V0,A,B,C,D,Q,R,n_backs_list)
% Set up the input signal, initial conditions, etc.
u = cell2mat(n_backs_list); % Input signal (an impulse at time 0)

Ns = length(u); 	        % Number of sample times to simulate
y = zeros(Ns,1);        % Preallocate output signal for n=0:Ns-1
w= normrnd(0,Q);
v= normrnd(0,R);

% Perform the system simulation:
x = x0;                % Set initial state
X=[];
X=x0;
for n=1:Ns-1           % Iterate through time
  y(n) = C*x + D*u(n)+ v; % Output for time n-1
  x = A*x + B*u(n)+ w;    % State transitions to time n
  X = [X x];
end
data = cell(1,1);
U = cell(1,1);
data{1}= y;
U{1} = u;



log_P = zeros(5,1);
A_rr = cell(5,1);
C_rr = cell(5,1);
B_rr = cell(5,1);
D_rr = cell(5,1);
Q_rr = cell(5,1);
R_rr = cell(5,1);
x0_rr = cell(5,1);
V0_rr = cell(5,1);


for i=1:5 %Random Restarts to avoid getting stuck in local maxima
    [A1, C1, B1, D1, Q1, R1, x0_1, V0_1, loglik1] = learn_kalman(data,U);
    A_rr{i} = A1;
    B_rr{i} = B1;
    C_rr{i} = C1;
    D_rr{i} = D1;
    Q_rr{i} = Q1;
    R_rr{i} = R1;
    x0_rr{i} = x0_1;
    V0_rr{i} = V0_1;
    log_P(i) = loglik1;
end

[loglik,idx] =max(log_P);
 
A1 = A_rr{idx};
C1 = C_rr{idx};
B1 = B_rr{idx};
D1 = D_rr{idx};
Q1 = Q_rr{idx};
R1 = R_rr{idx};

x0_1 = x0_rr{idx};
V0_1 = V0_rr{idx};
 save('log_P.mat','log_P');
 save('loglik1.mat','loglik1');
 save('A1.mat','A1');
 save('C1.mat','C1');
 save('B1.mat','B1');
 save('D1.mat','D1');
 save('Q1.mat','Q1');
 save('R1.mat','R1');
 save('x0_1.mat','x0_1');
 save('V0_1.mat','V0_1');


save('X.mat','X');
save('data.mat','data');
save('U.mat','U');
end

