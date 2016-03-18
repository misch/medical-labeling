function [classifier,sInfo ] = learnPuboost(data,L,prob,nbRounds)
% data: MxN matrix containing training examples (M N-dimensional examples)
% L: labels (Mx1 vector). 
%     label(i) =    1 --> i-th training sample is surely positive
%     label(i) =    -1 --> i-th training sample is surely negative
%     label(i) =    0 --> i-th training sample is not labeled; 
%                   whether it's considered positive or negative 
%                   depends on the probability weights.
% prob: the heart of this method - a probability weight for each training
% sample (Mx1 vector).
%     prob(i) close to 1 --> most likely positive
%     prob(i) close to 0 --> most likely negative
%     boundary between +/- is at prob(i) = 0.5
% nbRounds: number of weak classifiers that are learned

shrinkage      = 0.1;

nbSamples      = size(data,1);
nbFeat = size(data,2);

labels         = L;
Uindex         = find(labels==0); % unlabeled data
Lindex         = find(labels~=0); % labeled data
labels(Uindex) = 2*(prob(Uindex) > 0.5)-1; % set labels for U set.
prob(Uindex)   = (prob(Uindex) < 0.5).*(1-prob(Uindex)) + (prob(Uindex) > 0.5).*prob(Uindex);

classifier{nbRounds} = [];
L_Vec = zeros(nbRounds,1); % loss vector
R_vec = zeros(nbSamples,1); % pseudo residuals
F_vec = zeros(nbSamples,1); % current scores vector

gamma          =  numel(Uindex) / nbSamples;

h = waitbar(0,'PU-boost training...');
sorted_data = sort(data,1);

for ii = 1:nbFeat
    sorted_attr_values{ii} = uniquetol(sorted_data(:,ii),0.005)';
end

for m = 1:nbRounds
 
    % for labeled and unlabeled, the gradient of the loss function (pseudo
    % residuals) is computed separately
    R_vec(Lindex) = (-labels(Lindex).*exp(-labels(Lindex).*F_vec(Lindex)));
    R_vec(Uindex) = -gamma*(labels(Uindex).*prob(Uindex).*exp(-labels(Uindex).*F_vec(Uindex))...
                    - labels(Uindex).*(1-prob(Uindex)).*exp(labels(Uindex).*F_vec(Uindex)));                    

%     double hinge loss (unlabeled) and composite loss (positives)
%     R_vec(Lindex) = -labels(Lindex);
%     R_vec(Uindex) = -labels(Uindex).*((labels(Uindex).*F_vec(Uindex))<-1)-0.5*labels(Uindex).*(abs(labels(Uindex).*F_vec(Uindex))<=1);
                     
%     dispData(R_vec,data);
    classifier{m}.wl     = getBestWeakLearner(data,R_vec',sorted_attr_values);
    classifier{m}.alpha  = 1;%compAlpha(Pdata,Udata,PWeights,UWeights,UProb,ULab,gamma,bRound.wl);
   
    F_vec   = evalClassifier(labels,data,classifier, shrinkage,m); 
    L_Vec(m) = sum(exp(-labels(Lindex).*F_vec(Lindex)))+...
               gamma*sum(prob(Uindex).*exp(-labels(Uindex).*F_vec(Uindex)) +...
                      (1-prob(Uindex)).*exp(labels(Uindex).*F_vec(Uindex)));
                  
    waitbar(m/nbRounds);
end
close(h);

sInfo.LOSS  = L_Vec;

end

%% 
function dispData(W,D)
figure(1); subplot(3,1,3);
hold on;
for dd=1:size(D,1)
    if W(dd) >0.5
        plot(D(dd,1),D(dd,2),'go','MarkerSize',round(12*W(dd)));
    else
        plot(D(dd,1),D(dd,2),'ro','MarkerSize',round(12*(1-W(dd))));
    end
end
axis([0,6,0,4.5]);
grid on;
hold off;

end

%%
function [scores] = evalClassifier(labels,data,cl,shr,mMax)
scores = zeros(size(labels,1),1);
for m=1:mMax
    scores  = scores + shr*cl{m}.alpha.*evalWL(cl{m}.wl,data);
end
end

%%
function  weakStruc = getBestWeakLearner(data,R_vec,sorted_attr_values)

tttest = 0;

nbFeat = size(data,2);
score = Inf*ones(1,nbFeat);
theta = zeros(1,nbFeat);
coord = zeros(1,nbFeat);
pol = zeros(1,nbFeat);

for pp = [-1,1]
    parfor (cc = 1:nbFeat,12)
        for tt = sorted_attr_values{cc}
%         for tt = linspace(min_vals(cc), max_vals(cc),300)
%            for tt = [0:0.1:0.4, 0.401:0.01:0.7, 0.8,0.9,1]
            if pp > 0
                P_1 = data(:,cc) >  tt;
                N_1 = data(:,cc) <  tt;
                H   = P_1 - N_1;
            else
                P_1 = data(:,cc) <  tt;
                N_1 = data(:,cc) >  tt;
                H   = P_1 - N_1;
            end
            
            new_score        = R_vec*H;
            
            if (tttest== 1)
                fprintf('%d %d %f %f %f \n',pp,cc,tt,new_score,pE_err);
            end

            if score(cc) >= new_score
              score(cc) = new_score;
              theta(cc) = tt;
              coord(cc) = cc;
              pol(cc) = pp;
            end
        end
    end
end
    [min_score, min_idx] = min(score);
    weakStruc = struct('score',min_score,'theta',theta(min_idx),'coord',coord(min_idx),'pol',pol(min_idx));
end

%%

function alpha = compAlpha(Pdata,Udata,PWeights,UWeights,UProb,ULab,fact,wl)

    UW_neg = UWeights'.*(1-UProb);
    UW_pos = UWeights'.*(UProb);

    tt     = wl.theta;
    pp     = wl.pol;
    cc     = wl.coord;

    if pp > 0
        pE_err       = PWeights'*(((2.*( Pdata(:,cc) >  tt ) - 1))<0);
        pE_cor       = PWeights'*(((2.*( Pdata(:,cc) >  tt ) - 1))>0);
        UMissed      = ( ( ULab.*(2.*( Udata(:,cc) >  tt ) - 1) )<0) ;
        UCorr        = ( ( ULab.*(2.*( Udata(:,cc) >  tt ) - 1) )>0) ;
    else
        pE_err       = PWeights'*(((2.*( Pdata(:,cc) <  tt ) - 1))<0);
        pE_cor       = PWeights'*(((2.*( Pdata(:,cc) <  tt ) - 1))>0);
        UMissed      = ( ( ULab.*(2.*( Udata(:,cc) <  tt ) - 1) )<0) ;
        UCorr        = ( ( ULab.*(2.*( Udata(:,cc) <  tt ) - 1) )>0) ;
    end

    U_cor_pos     = UW_pos*UCorr;
    U_cor_neg     = UW_neg*UCorr;
    U_inc_pos     = UW_pos*UMissed;
    U_inc_neg     = UW_neg*UMissed;

    alpha        = 0.5*log((pE_cor+U_cor_pos+U_inc_neg)/(pE_err+U_inc_pos+U_cor_neg)) ;

end
