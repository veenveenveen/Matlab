function match= SBC_feature_compare(testing_data1,sbc_file)
No_of_Gaussians=12;  %the number of Gaussian Mixtures which will be used in modeling
%no_coeff=[1];
no_coeff=[5:12];     

load(sbc_file);


Fs=8000;


testing_features1=sbc_2(testing_data1,8000');

max=-100e+10;

% fea cell array holds the features of the persons

for i=1:no_of_fe

    mu_t =fea{i,1};
    sigma_t=fea{i,2};
    c_t=fea{i,3};
%disp('Comparing the test features of speaker one and two against model one');
[lYM,lY]=lmultigauss(testing_features1(:,no_coeff)', mu_t,sigma_t,c_t);
maxv(i)=mean(lY);


end

match=maxv;