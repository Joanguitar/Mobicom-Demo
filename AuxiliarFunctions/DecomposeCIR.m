function [ V, X_c, X_f ] = DecomposeCIR( X, N )

if nargin<2
    N=2; % Default value for N
end

[V, E]=eig(X'*X); E=diag(E);
if E(1)>E(end)
    V=V(:, 1:N);
else
    V=V(:, end:-1:end-N+1);
end

[~, I]=max(abs(X*V), [], 2);
I_old=zeros(size(I));
while any(I~=I_old)
    for ii_v=1:N
        x=X(I==ii_v, :);
        [VV, E]=eig(x'*x); E=diag(E);
        if E(1)>E(end)
            V(:, ii_v)=VV(:, 1);
        else
            V(:, ii_v)=VV(:, end);
        end
    end
    I_old=I;
    [~, I]=max(abs(X*V), [], 2);
end

[~, II]=sort(sum(I==1:N), 'descend');
V=V(:, II);
[~, I]=max(abs(X*V), [], 2);

if nargout>1
    X_c=X;
    for ii_v=1:N
        X_c(I==ii_v, :)=bsxfun(@times, X_c(I==ii_v, :), exp(-1i*angle(X_c(I==ii_v, :)*V(:, ii_v))));
    end
    if nargout>2
        X_f=X_c(I==1, :);
    end
end

end