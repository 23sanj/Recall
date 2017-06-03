function [WC,WM,X] =calc_sigmapoints(x_hat,V_hat,dim)
  
    alpha =10^-4%10^-4;%1 %spread of sigma points around the mean
    beta = 2;%0; %incoroporate prior knowledge of x--gaussian=2
    kappa = 0;
    lambda =0;%(alpha*alpha)*(dim+kappa)-dim;
    c= lambda + dim;
   % Calculate the sigma points and there corresponding weights using the Scaled Unscented Transformation
    WM = zeros(2*dim+1,1);
    WC = zeros(2*dim+1,1);
    for j=1:2*dim+1
      if j==1
        wm = lambda / (dim + lambda);
        wc = lambda /(dim + lambda);% +(1 - alpha^2 + beta);
      else
        wm = 1 / (2 * (dim + lambda));
        wc = wm;
      end
      WM(j) = wm;
      WC(j) = wc;
    end
  decomp = schol(V_hat');
  X = [zeros(size(x_hat)) decomp -decomp];
  X = sqrt(c)*X + repmat(x_hat,1,size(X,2));
end

