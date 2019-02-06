function bp = AdaptCBP(ch)

[~, I_ch]=sort(abs(ch), 'descend');
[~, N]=max(cumsum(abs(ch)).^2./(1:length(ch)));
bp=zeros(size(ch));
bp(I_ch(1:N))=1/sqrt(N);

bp=bp.*exp((pi/2*1i)*round(angle(ch)/(pi/2)));

end