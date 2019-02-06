function [V, Score] = CIR2V(CIR)


%% Directions to check
Res=2^8;
az=repmat(linspace(-90, 90, Res), Res, 1); az=az(:);
el=repmat(linspace(-90, 90, Res), Res, 1).'; el=el(:);
V=[cos(az*pi/180).*cos(el*pi/180), -sin(az*pi/180), -cos(az*pi/180).*sin(el*pi/180)].';
%% Angular response
load('Applications\CSI2PredTrans.mat', 'Err')
load('AntennaConfig_wDaniel2.mat', 'Coordinates', 'CentralSteer')
E=abs(diag(Err*Err'));
Q=diag((1+E).^-0.5);
Steer=exp(Coordinates*V*2i*pi);
Steer([4, 11, 18:20], :)=0;
Steer=Q*(Steer.*CentralSteer);
Steer=bsxfun(@rdivide, Steer, sqrt(sum(abs(Steer).^2)));

CIR(isnan(CIR))=0;
if any(CIR~=0)
    CIR=Q*CIR;
    CIR=CIR/sqrt(sum(abs(CIR).^2));
end

Val=abs((CIR)'*Steer);
[Score, ii_V]=max(Val, [], 2);
V=V(:, ii_V);

end