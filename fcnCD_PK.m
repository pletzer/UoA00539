function [fd,pk,fnnb]=fcnCD_PK(iv,d,opt)
%e.g. x=lorenz(); fd=d2(x(3),3);
%Copyright Chris King 17 Aug 2018
%Permission to use for research on a creative commons licence 
%as long as the author's name is cited, along with http://dhushara.com
%you can run a script checking fd=d2(x(3),i) for i=2,3,4,5 to get a plateau
%if you set d=0, the function will accept a multidimensional vector 
%e.g d2(lorenz,0)
if nargin<3
    opt=0;
end
%tic;
if d==0
    vec=iv;
    s=size(vec);
    d=s(1);
    iter=s(2);
    l2=iter;
else
    s=size(iv);
    if s(1)>1
        iv2=zeros(1,s(1)*s(2));
        for i=1:s(2)
            hld=iv(:,i);
            iv2(1+(i-1)*s(1):i*s(1))=hld';
        end
        iv=iv2;
    end
    iter=length(iv);
    vec=zeros(d,iter-d);
    for i=1:d
        for j=1:iter-d
            vec(i,j)=iv(i+j-1);
        end
    end
    l2=iter-d;
end
mx = 0;
mn = 0;
%toc;
% Now add up how many pairs of points are distance apart
% closer than epsilon and return epsilon and count in
% the array ratio for later graphical analysis with Excel
scales = 18;
start = 1;
ratio = zeros(3,scales);
n=start;
epsilon = 1/(2^n);
dists=NaN(l2);
for i=1:l2
    for j=1:l2
        sum = 0;
        for k = 1:d
            sum = sum + (vec(k,i) - vec(k,j)).^2;
        end
        sum = sqrt(sum);
        if sum > mx
            mx = sum;
        end
        if i==1 && j==2
            mn = sum;
        else
            if (sum < mn) && (sum>0)
                mn = sum;
            end
        end
        if i==j
            dists(i,j)=1e10;
        else
            dists(i,j)=sum;
        end
    end
end
md=min(dists);
nnb=zeros(1,l2);
for i=1:l2
    % Correction was needed as find can return many values; we need to find
    % only one
    nnb(i)=find(dists(:,i)-md(i)==0,1);
end


fnnb=0;
for i=1:l2
    if abs(iv(i+d)-iv(nnb(i)+d))/dists(i,nnb(i))>10
        fnnb=fnnb+1/l2;
    end
end




while epsilon*mx>2*mn && n<scales
%     count = 0;
%     for i=1:l2
%         for j=1:l2    
%             if dists(i,j) < epsilon*max
%                 count = count + 1;
%             end
%         end
%     end 
    mx2=epsilon*mx;
    count=length(find(dists<mx2));
    if count>0
    ratio(1,n) = epsilon;
    ratio(2,n) = count;
    n=n+1;
    end
    epsilon = 1/(1.5^n);
end
ratio=ratio(:,1:n-1);
[p q]=size(ratio);
if opt
    loglog(ratio(1,:),ratio(2,:));
end
%ro=polyfit(log(ratio(1,floor(q/3):ceil(2*q/3))),log(ratio(2,floor(q/3):ceil(2*q/3))),1);
ro=polyfit(log(ratio(1,floor(2*q/3):q)),log(ratio(2,floor(2*q/3):q)),1);
pk=0;
for i=1:n-2
    hld=(log(ratio(2,i+1))-log(ratio(2,i)))/(log(ratio(1,i+1))-log(ratio(1,i)));
    if hld>pk
        pk=hld;
    end
end
fd=ro(1);
%toc;
