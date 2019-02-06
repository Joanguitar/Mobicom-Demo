function [ cg ] = GetComplexGain( CG, N, th )

if nargin<3
    th=0.90;
    if nargin<2
        N=2;
    end
end

V=DecomposeCIR(CG, N);

CG_f=CG(abs(CG*V(:, 1))./sqrt(sum(abs(CG).^2, 2))>th, :);
CG_f=bsxfun(@times, CG_f, exp(-1i*angle(CG_f*V(:, 1))));

cg=mean(CG_f, 1);
cg=cg./abs(cg).*mean(abs(CG));

end