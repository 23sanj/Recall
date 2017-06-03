function [] = explot3(A,B,Q,R,data_list,n_backs_list,R_list,M_list,subList,x0,V0,Predicted_Value)
%Plotting for every subject:
nSubs = numel(subList);
dim=2;
count =1;
for s = 1:nSubs
    y = data_list{s};
    Y1= data_list{s};
    Y2 = Predicted_Value{s};
    if isempty(y) ~= 0
      continue;
    end 
    
    dim = size(A,1); %since x is 1 dimensional
    T = length(y');
    M= M_list{s};
    Rt=R_list{s};
    
    n_back = n_backs_list{s};
    n_back_prev= ones(size(n_back,1),1); %Since there is no 0 n-back, let us take n-back=1 
    n_back_fut = ones(size(n_back,1),1);
    y_prev= ones(size(y,1),1);%Default accuracy =1
    for i=1:size(n_back,1)
        if i==1
          n_back_fut(i) = n_back(i+1);
          continue;
        end
        n_back_prev(i) = n_back(i-1);
        y_prev(i) = y(i-1); %Previous y(t-1) + a constant =1
        if i == size(n_back,1)
           continue;
        end
        n_back_fut(i) = n_back(i+1);
    end
    u = [n_back,n_back_prev,y_prev,repmat(1,size(n_back,1),1)];
    u=u';
    y=y';
    sessions = linspace(1,T,T);
    %Step 1: Call the kalman filter
    [xf,Vf,Pf,loglik,err,Predicted_Values,S_t] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt);


    %Step 2: Backward Pass-- The Kalman Smoother and the lag-one-covariance
%smoother
    xs= zeros(dim,T);
    xs(:,T) =xf(:,T);
    Vs(:,:,T) =Vf(:,:,T);

    for t=T-1:-1:1
        [xs(:,t),Vs(:,:,t),Ps(:,:,t+1)] = rts_smoother(xs(:,t+1),Vs(:,:,t+1),xf(:,t), Vf(:,:,t),Vf(:,:,t+1), Pf(:,:,t+1), A, Q,B,u(:,t));    
    end
    fig(s) = figure;
    Subject= subList{s}.name;
    Subject =strsplit(Subject,'_');
    Subject = Subject{1};
    
    h(1)=subplot(2, 1, 1);
    scatter(sessions,u(1,:),'bx');
    hold on;
    plot(xs(1,:),'r');
    hold on;
    plot(xf(1,:),'g');
   % legend('Observed N-back','Predicted Skill--Smoothened Estimate','Predicted Skill--Filtered Estimate');
   title(sprintf('Subject= %s',Subject));
    xlabel('Block Number');
    ylabel('N-back');


    h(2)=subplot(2, 1, 2);
    scatter(sessions,Y1,'rx');
    hold on;
    scatter(sessions,Y2,'bo');
    
    b = num2str(n_back);
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
   % legend('Actual Percentage Correct','Predicted Percentage Correct');
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

