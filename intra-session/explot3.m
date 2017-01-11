function [] = explot3(A,Pi,B_list,subList,n_backs_list,Y_hat_list,Ratio)
%Plotting for every subject:
nSubs = numel(B_list);
gamma_list = cell(nSubs,1);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    B= B_list{k};
    n_backs= n_backs_list{k};
    if (isempty(B) == 1)
       continue;
    end
    [alpha,beta,scale] =alpha_beta_pass(A,Pi,B);
    
    gamma=alpha.*beta.*(1./scale)';
    N= size(B,1);
    sessions = linspace(1,N,N);
    
    
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    fig(k)= figure;
    h1 = axes;
    
    
    a=subplot(2, 1, 1);  
    imagesc(gamma');
    caxis([0, 1])
    colorbar;
    set(gca,'YDir','normal');
    set(gca,'YTick',[1,2,3,4,5]);
    hold on;
    scatter(sessions+0.2,n_backs,'kx');
    ylim([1 9]);
    
    
    
    legend('Observed N-back','Predicted Skill');
    %title(sprintf('N-back skill level estimate for Subject= %s',Subject));
    xlabel('Episode Number');
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
        print(fig(k), '-dpsc2', 'User-Skill-Trace.ps');
    else
       print(fig(k), '-append', '-dpsc2', 'User-Skill-Trace.ps'); 
    end
    gamma_list{k} = gamma;
    
end
save('gamma_list.mat','gamma_list');

end

