function [] = explot2(Y_hat_list,Ratio,subList)
%Plotting for every subject:
nSubs = numel (Y_hat_list);
Diff = cell(nSubs,1);
sum_diff =zeros(100,1);
sum_diff_2 =zeros(100,1);
count=0;
for k=1:nSubs
    Y1= Y_hat_list{k}; %Actual Value
    Y2= Ratio{k}; %Predicted value
    if (isempty(Y1) == 1)
       continue;
    end
   
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    differ = Y1-Y2;
    if (size(sum_diff,1) >  size(Diff,1))
        differ = [differ;repmat(0,(size(sum_diff,1)-size(differ,1)),1)]; %appending 0s to maintain structure
    end
    sum_diff = differ + sum_diff;
    %sum_diff_2 = (differ).^2 + sum_diff_2;
    Diff{k} = differ;
    count = count +1;
end
    rem_idx = min(find(sum_diff == 0));
    sum_diff = sum_diff(1:rem_idx-1);
    
    mean_res= sum_diff/count; %mean across all subjects
   
    for k=1:nSubs
        differ = Diff{k};
        if (isempty(differ) == 1)
            continue;
        end
        mean_res = [mean_res;repmat(0,(size(differ,1)-size(mean_res,1)),1)] %appending 0s to maintain structure
        sum_diff_2 = (differ-mean_res).^2 + sum_diff_2;
    end
    sum_diff_2 = sum_diff_2(1:rem_idx-1);
     var_res = sqrt(sum_diff_2/count);
     mean_res = mean_res(1:rem_idx-1);
    
    N = size(mean_res,1);
    sessions = linspace(1,N,N);
   % boxplot(sum_diff,sessions, 'plotstyle', 'compact');
     bar(mean_res,'BaseValue',0);   
    title('Mean of residuals across all subjects');
    
    xlabel('Session Number');
    ylabel('Mean of residuals');
    
    figure;
    bar(var_res,'BaseValue',0);   
    title('Variance of residuals across all subjects');
    
    xlabel('Session Number');
    ylabel('Variance of residuals');
    
    save('Variance.mat','var_res');
    save('Mean.mat','mean_res');
end

