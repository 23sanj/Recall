function [rmse] = compute_rmse(x0,V0,A,B,C,D,Q,R,n_backs_list,data_list,subList,dim)
nSubs = numel(data_list);
residuals_list = cell(nSubs,1);
Predicted_Values = cell(nSubs,1);
for k = 1:nSubs
    if (isempty(n_backs_list{k}) == 1)
       continue;
    end
    files=subList{k}
    subject_name= strsplit(files(1).name,{'Rlb*_','_'},'CollapseDelimiters',true);
    subject_name=subject_name{1};
    n_backs = n_backs_list{k};
    y = data_list{k};
    [xf,Vf,Pf,loglik,err,Predicted_Value]= kalman_filter(A,C,B,D,n_backs,Q,R,y,x0,V0,dim)
    residuals_list{k} = err';
    Predicted_Values{k} = Predicted_Value';
end

residuals = cell2mat(residuals_list);
rmse = sqrt(sum(residuals.*residuals)/length(residuals));
save('residuals_list.mat','residuals_list');
save('Predicted Values.mat','Predicted_Values');
save('Actual Values.mat','data_list');
save('rmse.mat','rmse');


end

