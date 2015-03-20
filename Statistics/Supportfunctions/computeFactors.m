function arsq_factors = computeFactors(answers)

answers = answers';

load Factors
% answers in the form n_subjects x n_dimensions

n_subjects = size(answers,1);

for i=1:n_subjects
    
    subject = answers(i,:);
    arsq_factors(i,1) = nanmean(double(subject(Factors.factors.f1')));
    arsq_factors(i,2) = nanmean(subject(Factors.factors.f2'));
    arsq_factors(i,3) = nanmean(subject(Factors.factors.f3'));
    arsq_factors(i,4) = nanmean(subject(Factors.factors.f4'));
    arsq_factors(i,5) = nanmean(subject(Factors.factors.f5'));
    arsq_factors(i,6) = nanmean(subject(Factors.factors.f6'));
    arsq_factors(i,7) = nanmean(subject(Factors.factors.f7'));
    arsq_factors(i,8) = nanmean(subject(Factors.factors.f8'));
    arsq_factors(i,9) = nanmean(subject(Factors.factors.f9'));
    arsq_factors(i,10) = nanmean(subject(Factors.factors.f10'));

    
% arsq_factors(i,1) = nanmean(double(subject([1,11,21])));
% arsq_factors(i,2) = nanmean(double(subject([2,12,22])));
% arsq_factors(i,3) = nanmean(double(subject([3,13,23])));
% arsq_factors(i,4) = nanmean(double(subject([4,14,24])));
% arsq_factors(i,5) = nanmean(double(subject([5,15,25])));
% arsq_factors(i,6) = nanmean(double(subject([6,16,26])));
% arsq_factors(i,7) = nanmean(double(subject([7,17,27])));
% arsq_factors(i,8) = nanmean(double(subject([10,20,30])));
% arsq_factors(i,9) = nanmean(double(subject([8,18,28])));
% arsq_factors(i,10) = nanmean(double(subject([9,19,29])));
    
end

% arsq_factors = round(arsq_factors);


