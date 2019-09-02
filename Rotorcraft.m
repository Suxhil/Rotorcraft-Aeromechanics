%given
rho = 1.0793;  R = 6.8; v = 55; fa = 2.5; m = 4500;
g = 9.81; b = 3; c = 0.35; Cd = 0.0095; VT = 33*6.8;
mu = v/VT; sfin = 2.5; omega = 33;
tic
%constants end%
pfuse = zeros(1,9);
pmrtr = zeros(1,10);
pvi = zeros(1,10);
B1 = zeros(1,10);
for X = 25:10:85
    disp(['For velocity: ',num2str(X),' m/s'])
    v = X;
    %main loop
    Tx = 0.5*rho*power(v,2)*fa;
    D = Tx*1.2/8.2;
    Tz = m*g + D;
    %Assumption
    A = pi*power(R,2)*(power(0.9,2)-power(0.18,2));
    vi = (Tz/(2*rho*A))/v;
    Pvi = Tz*vi;
    %%%%%%%%%%
    Pfuse = 0.5*rho*power(v,3)*fa;%fuselase power
    Pmrtr = (1/8)*rho*b*c*R*Cd*power(VT,3)*(1+4.3*power(mu,2));%main rotor profile power
    Pmr = Pvi + Pfuse + Pmrtr ;
    disp(['Induced power= ',num2str(Pvi),' Nm/s'])
    disp(['Fuselage Power= ',num2str(Pfuse),' Nm/s'])
    disp(['Main rotor profile power= ',num2str(Pmrtr),' Nm/s'])
    disp(['Power main rotor= ',num2str(Pmr),' Nm/s'])
        pvi(X) = Pvi;
        pfuse(X) = Pfuse;
        pmrtr(X) = Pmrtr;
      %Assume
    %iteration start
    Ttr = 0;
    ii = 1;
    Bn1 = 0; 
    Bn = 1;
    B = 90;
    while (Bn - Bn1) >0.001 
            disp(['Iteration: ',num2str(ii)])
            Tfin = ((Pmr/omega)-Ttr*9.5)/8.2;
            bta = Tfin/(0.5*rho*power(v,2)*sfin*3.8);
            Bn = B;
            B = bta*(180/pi);
            Bn1 = B;

%             if Bn1 > 0
            %%%%%%beta found
                Fside = 0.5*rho*power((v*sind(B)),2)*4;
                Ty = Fside+Tfin+Ttr;
                Ttr = 1/1.8*((Ty*1.2)-(Tfin*0.85));
                ii = ii +1;
                disp(['Beta= ',num2str(Bn1)])
                B1(X) = Bn1;
%             else
%                 disp(['Beta= ',num2str(Bn)])
%                 Fside = 0.5*rho*power((v*sind(Bn)),2)*4;
%                 Ty = Fside+Tfin+Ttr;
%                 Ttr = 1/1.8*((Ty*1.2)-(Tfin*0.85));
%                 B1(X) = Bn;
%             end
    end
    %end of first iteration
    Fside = 0.5*power(v*sin(Bn),2)*4;
    Ty = Tfin+Ttr+Fside;
    if v == 55
                disp(['Tx:', num2str(Tx),' N'])
                disp(['Ty:', num2str(Ty),' N'])
                disp(['Tz:', num2str(Tz),' N'])
                disp(['Ttr:', num2str(Ttr),' N'])
                disp(['Tfin:', num2str(Tfin),' N']) 
                disp(['Fside:', num2str(Fside),' N'])
    else
    end
    
    
%%%%%%%%question number 4
end
X = 25:10:85;
y1 = [pvi(25) pvi(35) pvi(45) pvi(55) pvi(65) pvi(75) pvi(85)];
y2 = [pfuse(25) pfuse(35) pfuse(45) pfuse(55) pfuse(65) pfuse(75) pfuse(85)];
y3 = [pmrtr(25) pmrtr(35) pmrtr(45) pmrtr(55) pmrtr(65) pmrtr(75) pmrtr(85)];
y4 = [B1(25) B1(35) B1(45) B1(55) B1(65) B1(75) B1(85)];

plot(X,y1,'g-o')
hold on
plot(X,y2,'r-+')
hold on
plot(X,y3,'b-s')
xlabel('Forward Velocity (m/s)');
ylabel('Power required (Nm/s)');
legend('Induced power','fuselage power','main rotor profile power');
hold off
print('power curve','-dpng','-r1500')
figure
hold on
xlabel('Forward Velocity (m/s)');
ylabel('Side slip Angle(in degrees)');
plot(X,y4,'-d');
hold off
print('beta vs velociity','-dpng','-r1500')
toc
%SK







