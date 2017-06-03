function [V_hat] = convertPositiveDefinite(V_hat)
[V,e] = eig(V_hat);

e_prime= nonzeros(e);
n = find(e_prime(:)<0);
v=length(e_prime);
NEG =[];
ind=[];
r=1;
for k=1:v
  if e_prime(k)<0
    ind(r) = k;
    NEG(k)=e_prime(k);
    r = r+1;
  end
end
m = length(NEG);
if m > 0
  S = sum(NEG);
  W = (S*S*100)+1;
  P = min(abs(e_prime));
  E = sort(NEG);
  NEWvalue = zeros(m,1);
  for i=1:m
      NEWvalue(i) = P*((S-E(i))*(S-E(i))/W);
      if sum(find(i==ind))~=0
        e(i,i) = NEWvalue(i);
      end
  end
end

V_hat = V'*e*V;
end

