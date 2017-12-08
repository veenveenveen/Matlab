function match= MFCC_feature_compare(testing_data1,mfcc_file)
No_of_Gaussians=12;  %the number of Gaussian Mixtures which will be used in modeling
%no_coeff=[1];
no_coeff=[5:12];     


load(mfcc_file);

Fs=8000;



testing_features1=melcepst(testing_data1,8000');

max=-100e+10;

% fea cell array holds the features of the persons
f=statusbar('Comparing');
for i=1:no_of_fe
 f=statusbar((i/no_of_fe),f);
    mu_t =fea{i,1};
    sigma_t=fea{i,2};
    c_t=fea{i,3};

[lYM,lY]=lmultigauss(testing_features1(:,no_coeff)', mu_t,sigma_t,c_t);
maxv(i)=mean(lY);

end
match=maxv;
 delete(statusbar);