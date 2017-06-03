function [] = explot3(A,B,C,D,Q,R,data_list,n_backs_list,subList,x0,V0,Predicted_Values)
%Plotting for every subject:
nSubs = numel(subList);
dim=2;
count =1;
for s = 1:nSubs
    y = data_list{s};
    u = n_backs_list{s};
    Y1= data_list{s};
    Y2 = Predicted_Values{s};
    if isempty(y) ~= 0
      continue;
    end 
    y=y';
    dim = size(A,1); %since x is 1 dimensional
    T = length(y);
    sessions = linspace(1,T,T);
    %Step 1: Call the kalman filter
    [xf,Vf,Pf,loglik] = kalman_filter(A,C,B,D,u,Q,R,y,x0,V0,dim);

    %Step 2: Backward Pass-- The Kalman Smoother and the lag-one-covariance
%smoother
    xs= zeros(dim,T);
    xs(:,T) =xf(:,T);
    Vs(:,:,T) =Vf(:,:,T);
    P(:,:,T) = P_future;
    for t=T-1:-1:1
        if t==T-1
            [xs(:,t),Vs(:,:,t),J] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),A, Q,B,u(t)); 
            continue;
        end
        [xs(:,t),Vs(:,:,t),J,P(:,:,t+1)] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),A, Q,B,u(t),P(:,:,t+2),J);
    end


    fig(s) = figure;
    Subject= subList{s}.name;
    Subject =strsplit(Subject,'_');
    Subject = Subject{1};
    
    h(1)=subplot(2, 1, 1);
    scatter(sessions,u,'bx');
    hold on;
    plot(xs,'r');
    hold on;
    plot(xf,'g');
    %legend('Observed N-back','Predicted Skill--Smoothened Estimate','Predicted Skill--Filtered Estimate');
   title(sprintf('Subject= %s',Subject));
    xlabel('Block Number');
    ylabel('N-back');


    h(2)=subplot(2, 1, 2);
    scatter(sessions,Y1,'o');
    hold on;
    scatter(sessions,Y2,'x');
    
    b = num2str(u);
    c = cellstr(b);
    %text(sessions,Y2,c);
    %text(sessions,Y1,c);
    
    c= get(h(1));
    position =c.XLim;
    x1 = position(2);
    c= get(h(2));
    position =c.XLim;
    x2 = position(2);
    set(h(2), 'XLim',[0.5 x1]);
    legend('Predicted Percentage Correct','Actual Percentage Correct');
    xlabel('Block Number');
    ylabel('Classification Accuracy');

    if count==1
        print(fig(s), '-dpsc2', 'User-Skill-Trace.ps');
    else
       print(fig(s), '-append', '-dpsc2', 'User-Skill-Trace.ps'); 
    end
    count = count +1;
    

end
end

