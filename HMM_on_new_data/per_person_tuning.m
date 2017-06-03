function [] = per_person_tuning()

c= 0;
d=1;
rho_values = linspace(0.1,2,20);
c_values = linspace(0,1,20);
d_values = linspace(0,1,20);


%Step 1: Tune A, with a fixed rho: 1.6--For now fix c=0, and d =1
[A,Pi,subList] = train_hmm();

nSubs = size(subList,1);
rho_subject = cell(nSubs,1);
c_subject = cell(nSubs,1);
d_subject = cell(nSubs,1);

loglik_subject = cell(nSubs,1);
%Step 2: Tune each rho, with A fixed-- Search the rho for max likelihood
for k= 1:nSubs
    files = subList{k};
    B_cell = cell(20,20,20);
    if isempty(files) ~= 1 
        %EM algo to find max likelihood
         [M,R,n_backs] = set_up2(subList{k});
         s=1;
         log_lik = zeros(20,20,20);
         for rho= rho_values
             t=1;
             for c=c_values
                    u=1;
                    for d=d_values
                        [B,X] =  compute_emission_prob(M,R,n_backs,rho,c,d); 
                        B_cell{s,t,u} = B;

                       log_P = zeros(5,1);
                        A_rr = cell(5,1);
                        Pi_rr = cell(5,1);
                        B = cell(1);
                        B{1}= B_cell{s,t,u};
                        for i=1:5 %Random Restarts to avoid getting stuck in local maxima
                            [A,Pi,loglik] = baum_welch_cont(X,B);
                            A_rr{i} = A;
                            Pi_rr{i} = Pi;
                            log_P(i) = loglik;
                        end
                        [loglik,idx] =max(log_P);
                       log_lik(s,t,u) = loglik;  
                        u=u+1;
                    end
                   t=t+1;
             end
             s=s+1;
         end     
           [loglik idx] = max(log_lik(:));
           [x,y,z] = ind2sub(size(log_lik),idx);
           picked_rho = rho_values(x);
           picked_c = c_values(y);
           picked_d = d_values(z);
            rho_subject{k} = picked_rho; %Assign rho to the particular subject
            c_subject{k} = picked_c;
            d_subject{k} = picked_d;
            loglik_subject{k} = loglik;
    end
end
%Step 3: Estimate A, Pi using these seperate slopes
[A,Pi,~] = train_hmm(rho_subject,c_subject,d_subject);
save('rho_subject.mat','rho_subject');
save('c_subject.mat','c_subject');
save('d_subject.mat','d_subject');

save('A.mat','A');
save('Pi.mat','Pi');
end

