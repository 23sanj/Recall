function [] = explot3(A,Pi,B_list,subList,n_backs_list,Y_hat_list,Ratio)
%Plotting for every subject:
nSubs = numel(B_list);
filtered_estimates = cell(nSubs,1);
X= linspace(1,9,18);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    B= B_list{k};
    n_backs= n_backs_list{k};
    if (isempty(B) == 1)
       continue;
    end
       [fs] = alpha_beta_pass(A,Pi,B) % gamma= alpha_hat*beta_hat lpha_hat*beta_hat 
    
   % gamma=alpha.*beta.*(1./scale)';
    N= size(B,1);
    sessions = linspace(1,N,N);
    
    
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    fig(k)= figure;
    
    h= zeros(1,2);
    h(1)=subplot(2, 1, 1);
   
    imagesc(fs');
    
    
    set(gca,'YDir','normal');
    %yticklabels = -90:20:90;
    set(gca, 'YTick', 1:18, 'YTickLabel',{'1', '1.47', '1.94', '2.41','2.88', '3.35', '3.82', '4.29','4.76', '5.24', '5.71', '6.18','6.65', '7.12', '7.59', '8.06','8.53','9'});
    hold on;
     n_backs_new = n_backs;

    

    n_backs_new(n_backs_new ==9 )=18; 

    n_backs_new(n_backs_new ==5 )=9;

    n_backs_new(n_backs_new ==3 )=5;

    n_backs_new(n_backs_new ==2 )=3; 

    

    n_backs_new(n_backs_new ==1 )=1; 

     

    

    n_backs_new(n_backs_new ==7 )=14; 

    n_backs_new(n_backs_new ==4 )=7; 

    n_backs_new(n_backs_new ==6 )=12; 

    n_backs_new(n_backs_new ==8 )=16; 

    

    

    scatter(sessions+0.2,n_backs_new,'rx');


    %ylim([1 9]);
    
    
    
    legend('Observed N-back','Predicted Skill');
    %title(sprintf('N-back skill level estimate for Subject= %s',Subject));
    xlabel('Event Number');
    ylabel('N-back');
    
    
    h1Pos = get(h(1),'position');
     caxis([0, 1])
    cbar=colorbar('location','eastoutside');
    
    set(h(1),'position',h1Pos);
   
    
    h(2)=subplot(2, 1, 2);
    
    
    
    scatter(sessions,Y1,'o');
    hold on;
    scatter(sessions,Y2,'x');
    
      b = num2str(n_backs);
    c = cellstr(b);
    text(sessions,Y2,c);
    text(sessions,Y1,c);
    
    c= get(h(1));
    position =c.XLim;
    x1 = position(2);
     c= get(h(2));
    position =c.XLim;
    x2 = position(2);
    set(h(2), 'XLim',[0.5 x1]);
    
    legend('Predicted Percentage Correct','Actual Percentage Correct');
    xlabel('Event Number');
    ylabel('Classification Accuracy');
     set(gcf,'NextPlot','add');
    axes;
    ht = title(sprintf('Subject= %s',Subject));
    set(gca,'Visible','off');
    set(ht,'Visible','on');
    
    
     filtered_estimates{k} = fs;
    if k==1
        print(fig(k), '-dpsc2', 'User-Skill-Trace.ps');
    else
       print(fig(k), '-append', '-dpsc2', 'User-Skill-Trace.ps'); 
    end
    
end
save('filtered_estimates.mat','filtered_estimates');
end

