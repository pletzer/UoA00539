function [fd,pk,fnnb]=fcnCD_PK_v2(iv,d,plt,tt,fnntol,slow,usefnn)
%e.g. x=lorenz(); [fd,pk,fnnb]=d2d(x(3,:),3,0,1,10); or
%[fd,pk,fnnb]=d2d(x(3,:),3,0,1,10,1) for the slow routine
%or [fd,pk,fnnb]=d2d(x(3,:),3,0,1,10,0,1) for the fast with false near nbrs
%iv is the input vector or array, d is the dimension, 
%plt allows for plotting the log-log tt adds tic toc
%fnntol gives the false nearest neighbour tolerance
%slow uses the slow routine that uses less memory
%usefnn calculates the lase nearest neighbours score
%Copyright Chris King 17 Aug 2018 24 Nov 2018
%Permission to use for research on a creative commons licence 
%as long as the author's name is cited, along with http://dhushara.com
%you can run a script checking fd=d2(x(3),i) for i=2,3,4,5 to get a plateau
%if you set d=0, the function will accept a multidimensional vector 
%e.g d2(lorenz,0)
if nargin<7
   usefnn=0;
end
if nargin<6
    slow=0;
end
if nargin<5
    fnntol=10;
end
if nargin<4
    tt=1;
end
if nargin<3
    plt=0;
end
%if tt
%    tic;
%end

tic;
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
        vec(i, :) = iv(i:i+iter-d-1);
    end
    l2=iter-d;
end
time_t1 = toc;

tic;
%toc;
% Now add up how many pairs of points are distance apart
% closer than epsilon and return epsilon and count in
% the array ratio for later graphical analysis with Exce
scales = 18;
start = 1;
ratio = zeros(3,scales);
n=start;
epsilon = 1/(2^n);
[dists, mn, mx] = computeDist(l2, d, vec);
time_t2 = toc;

tic;
fnnb=0;
if usefnn
    md=min(dists);
    nnb=zeros(1,l2);
    for i=1:l2
        nnb(i)=find(dists(:,i)-md(i)==0,1);
    end
    fnnb=0;
    for i=1:l2
        if abs(iv(i+d)-iv(nnb(i)+d))/dists(i,nnb(i))>fnntol
            fnnb=fnnb+1/l2;
        end
    end
end
time_t3 = toc;

tic;
while epsilon*mx>2*mn && n<scales
    if slow
        count = 0;
        for i=1:l2
            for j=1:l2    
                if dists(i,j) < epsilon*mx
                    count = count + 1;
                end
            end
        end
    else
        mx2=epsilon*mx;
        count=length(find(dists<mx2));
    end
    if count>0
    ratio(1,n) = epsilon;
    ratio(2,n) = count;
    n=n+1;
    end
    epsilon = 1/(1.5^n);
end
time_t4 = toc;

tic;
ratio=ratio(:,1:n-1);
[p q]=size(ratio);
if plt
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
time_t5 = toc;
disp(['fcnCD_PK_v2 times: ', num2str(time_t1), ' ', num2str(time_t2), ' ', num2str(time_t3), ' ', num2str(time_t4), ' ', num2str(time_t5)])
%if tt
%    toc;
%end
