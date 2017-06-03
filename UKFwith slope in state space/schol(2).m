function [L,def] = schol(A)

  L  = zeros(size(A));
  def = 1;
  for i=1:size(A,1)
    for j=1:i
      s = A(i,j);
      for k=1:j-1
	s = s - L(i,k)*L(j,k);
      end
      if j < i
	if L(j,j) > eps
          L(i,j) = s / L(j,j);
        else
          L(i,j) = 0;
        end
      else
	if (s < -eps)
	  s = 0;
	  def = -1;        
	elseif (s < eps)
	  s = 0;
	  def = min(0,def);
	end
	L(j,j) = sqrt(s);
      end
    end  
  end
  
  if (nargout < 2) & (def < 0)
    warning('Matrix is negative definite !!!!');
  end

