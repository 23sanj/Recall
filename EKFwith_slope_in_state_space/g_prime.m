function [df] = g_prime(x,u,a)
    d=1;
    c=0;
    %a=1.6;
    
    t= 1 + exp(-a*(x-u));
    q = (1/(t) - 1/(t*t))
    df = a*(d-c)*q;
end