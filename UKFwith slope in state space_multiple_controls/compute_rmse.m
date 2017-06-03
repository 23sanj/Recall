function [rmse] = compute_rmse(x0,V0,A,B,M_list,R_list,Q,R,n_backs_list,data_list,subList)
nSubs = numel(data_list);
residuals_list = cell(nSubs,1);
Predicted_Value = cell(nSubs,1);
for k = 1:nSubs
    if (isempty(n_backs_list{k}) == 1)
       continue;
    end
    files=subList{k}
    subject_name= strsplit(files(1).name,{'Rlb*_','_'},'CollapseDelimiters',true);
    subject_name=subject_name{1};
   
    y = data_list{k};
    n_back = n_backs_list{k};
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
    M= M_list{k};
    Rt=R_list{k};
    dim=2;
    u=u';
    [xf,Vf,Pf,loglik,err,Predicted_Values] = ukalman_filter(A,B,u,Q,R,y,x0,V0,dim,M,Rt);
    residuals_list{k} = err'; 
    Predicted_Value{k} = Predicted_Values';
end

residuals = cell2mat(residuals_list);
rmse = sqrt(sum(residuals.*residuals)/length(residuals));
save('residuals_list.mat','residuals_list');
save('Predicted Value.mat','Predicted_Value');
save('Actual Values.mat','data_list');
save('rmse.mat','rmse');


end

