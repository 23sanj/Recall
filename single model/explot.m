function [] = explot(Y_hat_list,Ratio,subList)
%Plotting for every subject:
nSubs = numel (Y_hat_list);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    if (isempty(Y1) == 1)
       continue;
    end
    N= numel(Y1);
    sessions = linspace(1,N,N);
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    fig(k)= figure;
    
    scatter(sessions,Y1,'o');
    hold on;
    scatter(sessions,Y2,'x');
    title(sprintf('Actual and Predicted Plots for Subject= %s',Subject));
    legend('Predicted Percentage Values','Actual Values');
    xlabel('Session Number');
    ylabel('Classification Accuracy');
    
    if k==1
        print(fig(k), '-dpsc2', 'Accuracy_Subject.ps');
    else
       print(fig(k), '-append', '-dpsc2', 'Accuracy_Subject.ps'); 
    end
end


end

