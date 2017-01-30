function [] = explot(Ratio,Y_hat_list)
N = numel(Y_hat_list);
for i=1:N
    f(i)=figure;
    plot(Ratio{i,1},'r');
    hold on;
    plot(Y_hat_list{i,1},'b');
end

end

