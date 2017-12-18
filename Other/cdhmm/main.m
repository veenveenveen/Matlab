for i=1:length(samples)
	sample=[];
	for k=1:length(samples{i})
		sample(k).wave=samples{i}{k};
		sample(k).data=[];
	end
	hmm{i}=train(sample,[3 3 3 3]);
end