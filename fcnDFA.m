function [D,Alpha1]=fcnDFA(DATA)
% DATA should be a time series of length(DATA) greater than 2000,and of column vector.
%A is the alpha in the paper
%D is the dimension of the time series
%n can be changed to your interest

% It is consitent with the program provided by Oxford Univ 
% www.eng.ox.ac.uk/samp/dfa_soft.html 
% Interest readers can visit that page 
% and download a complied DFA program that runs much faster.
% 
% In stochastic processes, chaos theory and time series analysis, detrended fluctuation analysis (DFA) is a method for determining the statistical self-affinity of a signal. It is useful for analysing time series that appear to be long-memory processes. 
% Reference: Peng C-K, Havlin S, Stanley HE, Goldberger AL. Quantification of scaling exponents and crossover phenomena in nonstationary heartbeat time series. Chaos 1995;5:82-87.
% Version 1.1.0.0 (506 KB) by Guan Wenye

n = 100:100:1000;
N1 = length(n);
F_n = zeros(N1,1);
for i = 1:N1
    F_n(i) = funDFA(DATA,n(i),1);
end

n=n';
%plot(log(n),log(F_n));
%xlabel('n')
%ylabel('F(n)')
A = polyfit(log(n(1:end)),log(F_n(1:end)),1);
Alpha1 = A(1);
D = 3 - A(1);
return
end

function output = funDFA(DATA,win_length,order)
N=length(DATA);   
n=floor(N/win_length);
N1=n*win_length;
y=zeros(N1,1);
Yn=zeros(N1,1);
       
fitcoef=zeros(n,order+1);
mean1=mean(DATA(1:N1));

for i=1:N1
    y(i)=sum(DATA(1:i)-mean1);
end
y=y';

for j=1:n
    fitcoef(j,:)=polyfit(1:win_length,y(((j-1)*win_length+1):j*win_length),order);
end
   
for j=1:n
    Yn(((j-1)*win_length+1):j*win_length)=polyval(fitcoef(j,:),1:win_length);
end
            
output = sqrt(sum((y'-Yn).^2)/N1);

end