%Smooth update at each time step

function [xs,Vs,Ps] = rts_smoother(xs_future, Vs_future,xf, Vf, Vf_future, Pf_future, A, Q,B,u)

    x_hat = A*xf +B*u;
    V_hat = A*Vf*A' + Q;
    J= Vf*A'*(inv(V_hat));
    
    xs = xf + J*(xs_future - x_hat);
    Vs = Vf + J*(Vs_future - V_hat)*J';
    Ps = Pf_future + (Vs_future - Vf_future)*(inv(Vf_future))*Pf_future;%lag one covariance
end

