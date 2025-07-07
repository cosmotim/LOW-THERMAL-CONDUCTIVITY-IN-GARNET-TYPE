clear all
%Q=[[2.0,2.0,0.0],[2.0,0.0,0.0],[4.0,0.0,0.0],[6.0,0.0,0.0],[5.0,0.0,0.0],[0.3, 0.3, 8.0], [0.8, 0.8, 8.0], [-0.2, -0.2, 8.0], [0.0, 0.0, 7.6], [0.0, 0.0, 7.7], [0.0, 0.0, 7.0], [3.8, 3.8, 3.8]];
%Q_2=[15.16249501427101, 15.422369500336732, 15.138870060992307, 13.645773013778333, 14.007234798942477, 11.57622710656403, 10.23432976033375]


% Q_A = [[2.0,0.0,0.0],[5.0,0.0,0.0],[0.0,0.0,7.85],[0.0, 0.0, 7.8], [0.0, 0.0, 7.9], [0.2, 0.2, 8.0]];
% 
% HWHM_A =     [0.10259, 0.43751, 0.69859,  0.62475, 0.44984, 0.24033];
% HWHM_err_A = [0.098516, 0.070354, 0.082034, 0.22112, 0.45098, 0.13994];

Q_A = [[2.0,0.0,0.0],[3.0,3.0,0.0], [5.0, 0.0, 0.0]];

HWHM_A =     [0.10663,  0.20729, 0.27710];
HWHM_err_A = [0.063191, 0.12500, 0.18011];


Q_T =[[0.3, 0.3, 8.0], [0.8, 0.8, 8.0], [-0.2, -0.2, 8.0], [0.0, 0.0, 7.6], [0.0, 0.0, 7.7], [0.0, 0.0, 7.0], [3.8, 3.8, 3.8]];



a = 12.95980; % A

Q = [Q_A, Q_T];

for i = 1:3:length(Q_A)-2
    index = (i-1)/3+1;
    Q_2_A(index) = ( 2*pi/a.*norm( Q_A([i,i+1,i+2]) ) ).^2; 
end

for i = 1:3:length(Q_T)-2
    index = (i-1)/3+1;
    Q_2_T(index) = ( 2*pi/a.*norm( Q_T([i,i+1,i+2]) ) ).^2; 
end

for i = 1:3:length(Q)-2
    index = (i-1)/3+1;
    Q_2(index) = ( 2*pi/a.*norm( Q([i,i+1,i+2]) ) ).^2; 
end

%HWHM    =[0.31387,0.10259,0.35314, 0.43819, 0.43751 ,0.329773368163061, 0.41853514038220907, 0.3381561131300559, 0.3810227281800471, 0.4565445747199137, 0.3636241142423391, 0.4209639535372012];
%HWHM_err=[0.84952,0.098516,0.88068, 0.45981, 0.070354,0.04969425556492933, 0.05797098889850106, 0.050507265866523626, 0.039035353675119164, 0.05150311385075002, 0.03197691580452162, 0.05783260097210008];


HWHM_T = [0.329773368163061, 0.41853514038220907, 0.3381561131300559, 0.3810227281800471, 0.4565445747199137, 0.3636241142423391, 0.4209639535372012];

HWHM = [HWHM_A , HWHM_T];



HWHM_err_T = [0.04969425556492933, 0.05797098889850106, 0.050507265866523626, 0.039035353675119164, 0.05150311385075002, 0.03197691580452162, 0.05783260097210008];
HWHM_err = [HWHM_err_A, HWHM_err_T];


%HWHM    =[0.058921, 0.43751 ,0.329773368163061, 0.41853514038220907, 0.3381561131300559, 0.3810227281800471, 0.4565445747199137, 0.3636241142423391, 0.4209639535372012];
%HWHM_err=[0.9343, 0.070354,0.04969425556492933, 0.05797098889850106, 0.050507265866523626, 0.039035353675119164, 0.05150311385075002, 0.03197691580452162, 0.05783260097210008];
%% 
hbar = 6.582119569 * 1e-13 ; % meV * s
tau = 1.5; % ps
d = 1.316; % A
Diffusivity = 1.866; % 10^11 A^2/s
Diffusivity_exp = 3.9*1e-13; % m^2/s

%Q2_space = linspace(0,max(Q_2),200);

Q_space = linspace(0,sqrt(max(Q_2)),200);
Q2_space = Q_space.^2;

fit1_exp = (hbar/(tau*1e-12)).*(1 - exp(- (Diffusivity_exp*1e+20*1e-12*tau).*Q2_space ) );
fit1 = (hbar/(tau*1e-12)).*(1 - exp(- (Diffusivity*1e11*1e-12*tau).*Q2_space ) );
fit2 = (hbar/(tau*1e-12)).*(1-(sin(Q2_space.^(1/2).*d)./ (Q2_space.^(1/2).*d) ) );
%% 

myfit_CE = fittype( @(tau,d,Q_x) (hbar*1e12/tau).*(1 - ( sin(Q_x.^(1/2).*d) ./ (Q_x.^(1/2).*d) ) ) , 'independent','Q_x' , 'coefficient',{'tau','d'});

%CE_fit = fit(Q_2.', HWHM.', myfit_CE, 'Start' , [tau,d])
% Add inverse error as fit weight
CE_fit = fit(Q_2.', HWHM.', myfit_CE, 'Start' , [tau,d], 'Weight',1./HWHM_err)

CE_f = @(x) CE_fit(x);

myfit_single = fittype (@(tau,Diffusivity_F,Q_x) ((hbar*1e12)/tau).*(1 - exp((-1*Diffusivity_F*tau*1e-12*1e+11).*Q_x)), 'independent', 'Q_x', 'coefficient', {'tau', 'Diffusivity_F'});

single_fit = fit(Q_2.' , HWHM.' , myfit_single , 'Start', [tau, Diffusivity])
single_f = @(x) single_fit(x);

myfit_SS = fittype( @(tau,d,Q_x) (hbar*1e12/tau).*(  (Q_x.*(d.^2./6)) ./ (1 + Q_x.*(d.^2./6))  ) , 'independent','Q_x' , 'coefficient',{'tau','d'});

SS_fit = fit(Q_2.' , HWHM.' , myfit_SS , 'Start', [tau,d])
SS_f = @(x) SS_fit(x);
%% 

% CE_nonlinear_F = @(x, Q_data) (hbar/x(1)).*(1-exp(-x(2).*x(1).*Q_data));
% x0 = [tau, d];
% [x,resnorm,~,exitflag,output] = lsqcurvefit(CE_nonlinear_F,x0,Q_2,HWHM)


%% 
close all
figure(3)
hold on
errorbar(Q_2_A.^(1/2),HWHM_A,HWHM_err_A,'^')
errorbar(Q_2_T.^(1/2),HWHM_T,HWHM_err_T,'o')

plot(Q_space, CE_f(Q2_space))
plot(Q_space,single_f(Q2_space))
plot(Q_space, SS_f(Q2_space))
hold off
legend('ARCS QENS Data','TAX QENS Data','CE model','Single diffusion model','SS model')
Ang = char(197);
xlabel(['|{\bfQ}| ( ' , Ang , '^{-1})'])
ylabel('HWHM (meV)')
box on

% figure(2)
% hold on
% errorbar(Q_2,HWHM,HWHM_err,'o')
% plot(Q2_space,fit1)
% plot(Q2_space,fit2)
% hold off
% legend('Data','single diffusion model','CE model')
% xlabel('Q^2 (A^-2)')
% ylabel('HWHM (meV)')
% box on

figure(1)
box on

% Q_space = linspace(0,sqrt(max(Q_2)),200);
% Q2_space = Q_space.^2;
hold on
errorbar(Q_2_T.^(0.5),HWHM_T,HWHM_err_T,'o','DisplayName','TAX Data')
errorbar(Q_2_A.^(0.5),HWHM_A,HWHM_err_A,'^','DisplayName','ARCS Data')
fig_a_x = Q_2.^(0.5);
% plot(Q2_space.^(0.5), single_f(Q2_space),'--')
plot(Q2_space.^(0.5), CE_f(Q2_space),'DisplayName','CE Model')
fig_b_x = Q2_space.^(0.5);
fig_b_y = CE_f(Q2_space);
% plot(Q2_space.^(0.5), SS_f(Q2_space),'-.')
hold off
xlim([0 4])
%ylim([0 1])
%legend('Data','single diffusion model','CE model','SS model')
legend('Location','northwest')
Ang = char(197);
xlabel(['|{\bfQ}| ( ' , Ang , '^{-1})'])
ylabel('HWHM (meV)')

% figure(3)
% box on
% tau = 3.4;
% d = 2.2;
% fit2_ref = (hbar/(tau*1e-12)).*(1-( sin(Q2_space.^(1/2).*d) ./ (Q2_space.^(1/2).*d)) );
% plot(Q2_space.^(1/2), fit2_ref)




