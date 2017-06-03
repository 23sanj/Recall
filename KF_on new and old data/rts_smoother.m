%Smooth update at each time step

function [xs,Vs,J,P] = rts_smoother(xs_future, Vs_future,xf, Vf, A, Q,B,u,P_future,J_prev,varargin)

    x_hat = A*xf + B*u;
    V_hat = A*Vf*A' + Q;
    J= Vf*A'/(V_hat);
    
    
    xs = xf + J*(xs_future - x_hat);
    Vs = Vf + J*(Vs_future - V_hat)*J';
    if nargin > 8
       P = V_hat*J_prev' + J*(P_future - A*V_hat)*J_prev';
    end
   
    %Ps = Pf_future + ((Vs_future - Vf_future)/(Vf_future))*Pf_future;%lag one covariance
end

