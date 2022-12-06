
%% 1 - INITIALIZE UQLAB
clc
close all
clear all
clearvars
rng(100,'twister')
uqlab

%% 2 - COMPUTATIONAL MODEL
ModelOpts.mFile = 'uq_tf1_pp2_kun'; % 3d

myModel = uq_createModel(ModelOpts);

%% 3 - PROBABILISTIC INPUT MODEL
% Specify these marginals in UQLab:
for ii = 1:3
    InputOpts.Marginals(ii).Type = 'Gaussian';
    InputOpts.Marginals(ii).Parameters = [0 1];
end

%% Create an INPUT object based on the specified marginals:
myInput = uq_createInput(InputOpts);

%% 4 - POLYNOMIAL CHAOS EXPANSION (PCE) METAMODELS
%
% This section showcases several ways to calculate the polynomial
% chaos expansion (PCE) coefficients.

% Select PCE as the metamodeling tool in UQLab:
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';

% Assign the Ishigami function model as the full computational model
% of the PCE metamodel:
MetaOpts.FullModel = myModel;


%% 4.1 Quadrature-based calculation of the coefficients
%
% Quadrature-based methods automatically use the computational model
% created earlier to gather the model responses on the quadrature nodes.

% Specify the 'Quadrature' calculation method
% (by default, Smolyak' sparse quadrature is used):



for FPC_d = 1:5

    MetaOpts.Method = 'Quadrature';

    % Specify the maximum polynomial degree:
    MetaOpts.Degree = FPC_d;

    % UQLab will automaticallydDDDsc determine the appropriate quadrature level.

    % Create the quadrature-based PCE metamodel:
    myPCE_Quadrature{FPC_d,1} = uq_createModel(MetaOpts);

    FPC_Error(FPC_d, 1) = myPCE_Quadrature{FPC_d,1}.Error.normEmpError;
    FPC_Mean(FPC_d, 1) = myPCE_Quadrature{FPC_d,1}.PCE.Moments.Mean;
    FPC_StD(FPC_d, 1)= sqrt(myPCE_Quadrature{FPC_d,1}.PCE.Moments.Var);
    FPC_CoV(FPC_d, 1)= FPC_StD(FPC_d, 1)/FPC_Mean(FPC_d, 1);
    FPC_NSamples(FPC_d, 1) = myPCE_Quadrature{FPC_d,1}.ExpDesign.NSamples;
    FPC_NCoef(FPC_d, 1) = length(myPCE_Quadrature{FPC_d,1}.PCE.Coefficients);

    % Print a report on the calculated coefficients:
    uq_print(myPCE_Quadrature{FPC_d})

    % Create a visual representation of the distribution of the coefficients:
    %     uq_display(myPCE_Quadrature{FPC_d})
    %     fig = gcf;
    %     fig.Name = 'Polynomial Spectrum for the quadrature method';

end

TrueMean = 2.5;
TrueStD = 3.840572;
RelError_Mean = abs(FPC_Mean - TrueMean)/TrueMean;
RelError_StD = abs(FPC_StD - TrueStD)/TrueStD;








figure(1)
set(gcf,'unit','centimeters','position',[10 5 17.4 10]); % 10cm*17.4cm
set(gcf,'ToolBar','none','ReSize','off');   % 移除工具栏
set(gcf,'color','w'); % 背景设为白色

subplot(2,2,1)
p1 = plot(FPC_NSamples,FPC_Error,'b--','LineWidth',1.5);
g = get(p1,'Parent');%对应p1所在的坐标轴
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Error','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(a)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,2,2)
p2 = plot(FPC_NSamples,RelError_Mean,'k--','LineWidth',1.5);
g = get(p2,'Parent');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of Mean','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(b)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,2,3)
p3 = plot(FPC_NSamples,RelError_StD,'r--','LineWidth',1.5);
g = get(p3,'Parent');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of St.D.','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(c)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,2,4)
p4 = plot(FPC_NSamples,FPC_CoV,'g','LineWidth',1.5);
g = get(p4,'Parent');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('CoV','FontSize',10,'FontName','Arial');
xlabel({'Number of Samples','(d)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

% h1=legend([p1 p2 p3 p4 p5 p6],'\fontname{Arial}y_1','\fontname{Arial}y_2','\fontname{Arial}y_3',...
%     '\fontname{Arial}y_4','\fontname{Arial}y5','\fontname{Arial}y6','Orientation','horizontal');
% set(h1,'Linewidth',1.5,'FontSize',10,'FontWeight','bold');
% set(h1,'position',[0.4,0.9,0.2,0.1]);%legend位置
% set(h1,'Box','off');

%text(0.05,0.6,'(a)')










