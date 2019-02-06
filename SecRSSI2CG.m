function CG = SecRSSI2CG(sec, rssi, length_Antennas)

%%%
while any(diff(sec)==0)
    I=find(diff(sec)==0);
    sec(I)=sec(I)-1;
end
%%%
rssi=rssi(sec>1);
sec=sec(sec>1);
RSSI=zeros(1, 5*length_Antennas+1);
RSSI(64-sec)=rssi;
RSSI(RSSI==0)=nan;
RSSI_A=RSSI(1:length_Antennas+1);
RSSI_P=reshape(RSSI(length_Antennas+2:end), 4, length_Antennas);
RSSI_P_fft=fft(RSSI_P);
CG=sqrt(RSSI_A).*[1, exp(1i*angle(RSSI_P_fft(2, :)))];

end