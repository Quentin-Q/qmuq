

%% 1 - INITIALIZE UQLAB
clc
close all
clear all
clearvars
rng(100,'twister')
uqlab

%% 2 - CMCUTATIONAL MODEL
ModelOpts.mFile = 'uq_tf2_pp2_kun'; % 3d

myModel = uq_createModel(ModelOpts);

%% 3 - PROBABILISTIC INPUT MODEL
% Specify these marginals in UQLab:
for ii = 1:3
    InputOpts.Marginals(ii).Type = 'Gaussian';
    InputOpts.Marginals(ii).Parameters = [0 1];
end

%% Create an INPUT object based on the specified marginals:
myInput = uq_createInput(InputOpts);

uq_print(myInput)

N_Degree = 6;
MC_NSamples = 10.^(1:N_Degree)';
MC_Mean = zeros(N_Degree,1);
MC_StD = zeros(N_Degree,1);
MC_CoV = zeros(N_Degree,1);

for n = 1 : length(MC_NSamples)
X_MC = uq_getSample(MC_NSamples(n),'MC');
X_LHS = uq_getSample(MC_NSamples(n), 'LHS');

% 计算函数值
Y_MC = uq_tf1_pp2_kun(X_MC);

% 计算均值和方差
MC_Mean(n,1) = mean(Y_MC);
MC_StD(n,1) = std(Y_MC );
MC_CoV(n,1) = MC_StD(n,1)/MC_Mean(n,1);


end



%%

TrueMean = 13.12202;
TrueStD = 4.300557;
RelError_Mean = abs(MC_Mean - TrueMean)/TrueMean;
RelError_StD = abs(MC_StD - TrueStD)/TrueStD;

figure(1)
set(gcf,'unit','centimeters','position',[10 5 17.4 10]); % 10cm*17.4cm
set(gcf,'ToolBar','none','ReSize','off');   % 移除工具栏
set(gcf,'color','w'); % 背景设为白色


subplot(2,1,1)
p1 = plot(MC_NSamples,RelError_Mean,'k--','LineWidth',1.5);
g = get(p1,'Parent');
set(g,'xscale','log');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of Mean','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(b)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,1,2)
p2 = plot(MC_NSamples,RelError_StD,'r--','LineWidth',1.5);
g = get(p2,'Parent');
set(g,'xscale','log');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of St.D.','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(c)'},'FontSize',10,'FontName','Arial','FontWeight','bold');


% h1=legend([p1 p2 p3 p4 p5 p6],'\fontname{Arial}y_1','\fontname{Arial}y_2','\fontname{Arial}y_3',...
%     '\fontname{Arial}y_4','\fontname{Arial}y5','\fontname{Arial}y6','Orientation','horizontal');
% set(h1,'Linewidth',1.5,'FontSize',10,'FontWeight','bold');
% set(h1,'position',[0.4,0.9,0.2,0.1]);%legend位置
% set(h1,'Box','off');

%text(0.05,0.6,'(a)')










