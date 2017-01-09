function [] = explot3(A,Pi,B_list,subList,n_backs_list,Y_hat_list,Ratio)
%Plotting for every subject:
nSubs = numel(B_list);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    B= B_list{k};
    n_backs= n_backs_list{k};
    if (isempty(B) == 1)
       continue;
    end
    [alpha,beta,scale] =alpha_beta_pass(A,Pi,B);
    
    %gamma=alpha.*beta./sum(alpha.*beta,2); %Posterior state from smoothing
    gamma=alpha.*beta.*(1./scale)';
    old_gamma = gamma;
    N= size(B,1);
    sessions = linspace(1,N,N);
    
    
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    fig(k)= figure;
    
    a=subplot(2, 1, 1);  
    scatter(sessions+0.2,n_backs,'kx');
    hold on;
    ylim([0 9]);
    new_gamma = zeros(size(gamma));
    
    for l=sessions
        for i= 1:size(gamma,2)
            [c_max,c_ind] = max(gamma(l,:));
            gamma(l,c_ind) =0;
            if (any(new_gamma(l,:) == c_ind))
                new_gamma(l,i) = NaN;
                continue;
            end
            new_gamma(l,i)= c_ind;
        end
    end
    
    %new_gamma(:, find(sum(abs(new_gamma)) == 0)) = [];
    %First col-highest, 2nd - 2nd highest
    map = [1 0 0; %Dark-red
          % 1 0.1 0.2;
           1 0.6 0.3; %Orange
           1 1 0.4;%Yellow
           1 1 0.9; %mauve
           1 1 1;]; %White
    for val = 1: size(new_gamma,2)
        res = val - size(new_gamma,2);
        scatter(sessions,new_gamma(:,val),'o','MarkerFaceColor',map(val,:));
        %colorbar(map);
        hold on;
    end
    
    legend('Observed N-back','Predicted Skill');
    %title(sprintf('N-back skill level estimate for Subject= %s',Subject));
    xlabel('Session Number');
    ylabel('N-back');
    
    b=subplot(2, 1, 2);
    scatter(sessions,Y1,'o');
    hold on;
    scatter(sessions,Y2,'x');
    %xlim([0 25]);
    %title(sprintf('Actual and Predicted Plots for Subject= %s',Subject));
    legend('Predicted Percentage Correct','Actual Percentage Correct');
    xlabel('Session Number');
    ylabel('Classification Accuracy');
     set(gcf,'NextPlot','add');
    axes;
    h = title(sprintf('Subject= %s',Subject));
    set(gca,'Visible','off');
    set(h,'Visible','on');
    
    if k==1
        print(fig(k), '-dpsc2', 'User-Skill-Trace.pdf');
    else
       print(fig(k), '-append', '-dpsc2', 'User-Skill-Trace.pdf'); 
    end
end


end

