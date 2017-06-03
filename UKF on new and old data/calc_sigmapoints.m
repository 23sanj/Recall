function [Wc_0,Wc_1,Wc_2,Wm_0,Wm_1,Wm_2,X_0,X_1,X_2] =calc_sigmapoints(x_hat,V_hat,dim)
  
    alpha =10^-4;%exp(-3);1 %spread of sigma points around the mean
    beta = 2%0; %incoroporate prior knowledge of x--gaussian=2
    kappa = 0%3 -dim%0;
    lambda = (alpha*alpha)*(1+kappa)-1;
   % Calculate the sigma points and there corresponding weights using the Scaled Unscented Transformation
    X_0 = x_hat;
    X_1 = x_hat + sqrt((1+lambda)*V_hat);
    X_2 = x_hat - sqrt((1+lambda)*V_hat);
    
    Wm_0 = lambda/(1+lambda);
    Wm_1 = 1/(2*(1+lambda));
    Wm_2 = 1/(2*(1+lambda));
    
    Wc_0 = Wm_0 +(1-(alpha*alpha) +beta);
    Wc_1 = Wm_1;
    Wc_2 = Wm_2;
    

end

