function [devianceResiduals,deviance] = getDeviance_null(result)
%function [devianceResiduals,deviance,samples_deviance,samples_devianceResiduals] = getDeviance(result,Nsamples)
% This function calculates the null deviance from the model. Temp function,
% Lior 2018-May-10
%

pPred = result.psiHandle(result.data(:,1));
% change predicted to the null predicted: The mean of y values.
pPred(1:end) = mean(result.data(:,2) ./ result.data(:,3));
pMeasured = result.data(:,2)./result.data(:,3);

loglikelihoodPred = result.data(:,2).*log(pPred)+(result.data(:,3)-result.data(:,2)).*log((1-pPred));
loglikelihoodMeasured = result.data(:,2).*log(pMeasured)+(result.data(:,3)-result.data(:,2)).*log((1-pMeasured));
loglikelihoodMeasured(pMeasured==1) = 0;
loglikelihoodMeasured(pMeasured==0) = 0;

devianceResiduals = -2*sign(pMeasured-pPred).*(loglikelihoodMeasured - loglikelihoodPred);

deviance = sum(abs(devianceResiduals));

end