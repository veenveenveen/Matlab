function [mu,sigm,c]=gmm_estimate(X,M,iT,mu,sigm,c,Vm)
% [mu,sigma,c]=gmm_estimate(X,M,<iT,mu,sigm,c,Vm>)
% 
% X   : the column by column data matrix (LxT)
% M   : number of gaussians
% iT  : number of iterations, by defaut 10
% mu  : initial means (LxM)
% sigm: initial diagonals for the diagonal covariance matrices (LxM)
% c   : initial weights (Mx1)
% Vm  : minimal variance factor, by defaut 4 ->minsig=var/(M²Vm²)

 
  
  % *************************************************************
  % GENERAL PARAMETERS
  [L,T]=size(X);        % data length
  varL=var(X')';    % variance for each row data;
  
  min_diff_LLH=0.001;   % convergence criteria

  % DEFAULTS
  iT=10;  % number of iterations, 
  mu=X(:,[fix((T-1).*rand(1,M))+1]);  % mu def: M rand vect.
  sigm=repmat(varL./(M.^2),[1,M]);  % sigm def: same variance
  c=ones(M,1)./M;   % c def: same weight
  Vm=4;    % minimum variance factor
  
  min_sigm=repmat(varL./(Vm.^2*M.^2),[1,M]);   % MINIMUM sigma!
 


  % VARIABLES
  lgam_m=zeros(T,M);    % prob of each (X:,t) to belong to the kth mixture
  lB=zeros(T,1);        % log-likelihood
  lBM=zeros(T,M);       % log-likelihhod for separate mixtures


  old_LLH=-9e99;        % initial log-likelihood

  % START ITERATATIONS  
  for iter=1:iT
 
    
    % ESTIMATION STEP ****************************************************
    [lBM,lB]=lmultigauss(X,mu,sigm,c);
  
 
    LLH=mean(lB);
    %set(handles.tx_msg,'String','Extracting MFCC Features'); 
    %disp(sprintf('log-likelihood :  %f',LLH));
    
    lgam_m=lBM-repmat(lB,[1,M]);  % logarithmic version
    gam_m=exp(lgam_m);            % linear version           -Equation(1)
    
    
    % MAXIMIZATION STEP **************************************************
    sgam_m=sum(gam_m);            % sum of gam_m for all X(:,t)
    
     
    % gaussian weights ************************************
    new_c=mean(gam_m)';      %                                -Equation(4)

    % means    ********************************************
    % (convert gam_m and X to (L,M,T) and .* and then sum over T)
    mu_numerator=sum(permute(repmat(gam_m,[1,1,L]),[3,2,1]).*...
               permute(repmat(X,[1,1,M]),[1,3,2]),3);
    % convert  sgam_m(1,M,N) -> (L,M,N) and then ./
    new_mu=mu_numerator./repmat(sgam_m,[L,1]);              % -Equation(2)

    % variances *******************************************
    sig_numerator=sum(permute(repmat(gam_m,[1,1,L]),[3,2,1]).*...
                permute(repmat(X.*X,[1,1,M]),[1,3,2]),3);
    
    new_sigm=sig_numerator./repmat(sgam_m,[L,1])-new_mu.^2; % -Equation(3)

    % the variance is limited to a minimum
    new_sigm=max(new_sigm,min_sigm);
    
           %*******
    % UPDATE

    if old_LLH>=LLH-min_diff_LLH
    
      break;
    else
 
        old_LLH=LLH;
      
      mu=new_mu;
      sigm=new_sigm;
      c=new_c;

  end
 
    %******************************************************************
  end
   
