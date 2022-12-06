
%% 1 - INITIALIZE UQLAB
clc
close all
clear all
clearvars
rng(100,'twister')
uqlab

%% 2 - COMPUTATIONAL MODEL
ModelOpts.mFile = 'uq_tf2_pp2_kun'; % 3d

myModel = uq_createModel(ModelOpts);

%% 3 - PROBABILISTIC INPUT MODEL
% Specify these marginals in UQLab:
for ii = 1:6
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



%% 4.4 Orthogonal Matching Pursuit (OMP) calculation of the coefficients
%
% The Orthogonal Matching Pursuit Algorithm (OMP) can be enabled
% similarly to the other PCE calculation methods:

testN = 49;

myPCE_OMP{testN,1} = [];
OMP_Error = zeros(testN,1);
OMP_LOOError = zeros(testN,1);
OMP_MLOOError = zeros(testN,1);
OMP_NormEmpError = zeros(testN,1);
OMP_Mean = zeros(testN,1);
OMP_StD = zeros(testN,1);
OMP_CoV = zeros(testN,1);
OMP_NCoef = zeros(testN,1);


for OMP_NSamples = 2:testN+1

    MetaOpts.Method = 'OMP';

    % OMP allows for degree-adaptive calculation of the PCE
    % coefficients. That is, if an array of possible degrees is given,
    % the degree with the lowest Leave-One-Out cross-validation error
    % (LOO error) is automatically selected.
    % Specify the range for the degree selection:
    MetaOpts.Degree = 1:10;
    MetaOpts.ExpDesign.NSamples = OMP_NSamples;
    MetaOpts.ExpDesign.Sampling = 'LHS';

    % Specify a sparse truncation scheme (hyperbolic norm with q = 0.75):
    MetaOpts.TruncOptions.qNorm = 0.75;

    % Create the OMP-based PCE metamodel:
    myPCE_OMP{OMP_NSamples-1,1} = uq_createModel(MetaOpts);

    OMP_LOOError(OMP_NSamples-1,1) = myPCE_OMP{OMP_NSamples-1,1}.Error.LOO;
    OMP_MLOOError(OMP_NSamples-1,1) = myPCE_OMP{OMP_NSamples-1,1}.Error.ModifiedLOO;
    OMP_NormEmpError(OMP_NSamples-1,1) = myPCE_OMP{OMP_NSamples-1,1}.Error.normEmpErr;
    OMP_Mean(OMP_NSamples-1,1) = myPCE_OMP{OMP_NSamples-1,1}.PCE.Moments.Mean;
    OMP_StD(OMP_NSamples-1,1)= sqrt(myPCE_OMP{OMP_NSamples-1,1}.PCE.Moments.Var);
    OMP_CoV(OMP_NSamples-1,1)= OMP_StD(OMP_NSamples-1,1)/OMP_Mean(OMP_NSamples-1,1);
    OMP_NCoef(OMP_NSamples-1,1) = length(myPCE_OMP{OMP_NSamples-1,1}.PCE.Coefficients);

    % Print a report on the calculated coefficients:
    uq_print(myPCE_OMP{OMP_NSamples-1,1} )

    % Create a visual representation of the distribution of the coefficients:
    % uq_display(myPCE_OMP{OMP_NSamples-1,1} )
    % fig = gcf;
    % fig.Name = 'Polynomial Spectrum for OMP';

end


%%

TrueMean = 13.12202;
TrueStD = 4.300557;
RelError_Mean = abs(OMP_Mean - TrueMean)/TrueMean;
RelError_StD = abs(OMP_StD - TrueStD)/TrueStD;
OMP_NSamples = (2:testN+1)';

figure(1)
set(gcf,'unit','centimeters','position',[10 5 17.4 10]); % 10cm*17.4cm
set(gcf,'ToolBar','none','ReSize','off');   % 移除工具栏
set(gcf,'color','w'); % 背景设为白色

subplot(2,2,1)
p1_1 = plot(OMP_NSamples,OMP_LOOError,'r--','LineWidth',1.5);
hold on
p1_2 = plot(OMP_NSamples,OMP_MLOOError,'k-','LineWidth',1.5);
hold on
p1_3 = plot(OMP_NSamples,OMP_NormEmpError,'b-.','LineWidth',1.5);

g = get(p1_1,'Parent');%对应p1所在的坐标轴
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('OMP Error','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(a)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

h1=legend([p1_1 p1_2 p1_3],'\fontname{Arial}LOO','\fontname{Arial}MLOO','\fontname{Arial}NormEmp',...
    'Orientation','horizontal');
set(h1,'Linewidth',1.5,'FontSize',10,'FontWeight','bold'); %legend字体
set(h1,'position',[0.4,0.9,0.2,0.1]);%legend位置
set(h1,'Box','off'); %去掉legend边框

subplot(2,2,2)
p2 = plot(OMP_NSamples,RelError_Mean,'k--','LineWidth',1.5);
g = get(p2,'Parent');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of Mean','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(b)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,2,3)
p3 = plot(OMP_NSamples,RelError_StD,'r--','LineWidth',1.5);
g = get(p3,'Parent');
set(g,'Linewidth',1.5,'FontSize',10,'FontName','Arial','FontWeight','bold');
ylabel('Rel. Error of St.D.','FontSize',10,'FontName','Arial','FontWeight','bold');
xlabel({'Number of Samples','(c)'},'FontSize',10,'FontName','Arial','FontWeight','bold');

subplot(2,2,4)
p4 = plot(OMP_NSamples,OMP_CoV,'g','LineWidth',1.5);
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










