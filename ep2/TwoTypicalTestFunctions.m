
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

<<<<<<< HEAD
=======
% for ii = 1:3
%     InputOpts.Marginals(ii).Type = 'Uniform';
%     InputOpts.Marginals(ii).Parameters = [0 1]; 
% end

>>>>>>> 62bc3e4b2cb6f098dac8ef32b0d8a02e3d3b1a31
%% Create an INPUT object based on the specified marginals:
myInput = uq_createInput(InputOpts);

%% 4 - POLYNOMIAL CHAOS EXPANSION (PCE) METAMODELS
%
% This section showcases several ways to calculate the polynomial
% chaos expansion (PCE) coefficients.

% Select PCE as the metamodeling tool in UQLab:
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';

<<<<<<< HEAD
% Assign the Ishigami function model as the full computational model
% of the PCE metamodel:
MetaOpts.FullModel = myModel;


=======
% Assign the Ishigami function model as the full computational model 
% of the PCE metamodel:
MetaOpts.FullModel = myModel;

>>>>>>> 62bc3e4b2cb6f098dac8ef32b0d8a02e3d3b1a31
%% 4.1 Quadrature-based calculation of the coefficients
%
% Quadrature-based methods automatically use the computational model
% created earlier to gather the model responses on the quadrature nodes.

% Specify the 'Quadrature' calculation method
% (by default, Smolyak' sparse quadrature is used):
<<<<<<< HEAD



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










=======
MetaOpts.Method = 'Quadrature';

% Specify the maximum polynomial degree:
MetaOpts.Degree = 5;

% UQLab will automatically determine the appropriate quadrature level.

% Create the quadrature-based PCE metamodel:
myPCE_Quadrature = uq_createModel(MetaOpts);

% Print a report on the calculated coefficients:
uq_print(myPCE_Quadrature)

% Create a visual representation of the distribution of the coefficients:
uq_display(myPCE_Quadrature)
fig = gcf;
fig.Name = 'Polynomial Spectrum for the quadrature method';



%% 4.4 Orthogonal Matching Pursuit (OMP) calculation of the coefficients
%
% The Orthogonal Matching Pursuit Algorithm (OMP) can be enabled
% similarly to the other PCE calculation methods:
MetaOpts.Method = 'OMP';

% OMP allows for degree-adaptive calculation of the PCE
% coefficients. That is, if an array of possible degrees is given,
% the degree with the lowest Leave-One-Out cross-validation error
% (LOO error) is automatically selected.
% Specify the range for the degree selection:
MetaOpts.Degree = 1:6;
MetaOpts.ExpDesign.NSamples = 20;
MetaOpts.ExpDesign.Sampling = 'LHS';

% Specify a sparse truncation scheme (hyperbolic norm with q = 0.75):
MetaOpts.TruncOptions.qNorm = 0.75;

% Create the OMP-based PCE metamodel:
myPCE_OMP = uq_createModel(MetaOpts);

% Print a report on the calculated coefficients:
uq_print(myPCE_OMP)

% Create a visual representation of the distribution of the coefficients:
uq_display(myPCE_OMP)
fig = gcf;
fig.Name = 'Polynomial Spectrum for OMP';


%% 4.6 Bayesian Compressive Sensing (BCS) calculation of the coefficients
%
% The Bayesian Compressive Sensing Algorithm (BCS) can be enabled
% similarly to the other PCE calculation methods:
MetaOpts.Method = 'BCS';

% BCS allows for degree-adaptive calculation of the PCE
% coefficients. That is, if an array of possible degrees is given,
% the degree with the lowest Leave-One-Out cross-validation error
% (LOO error) is automatically selected.
% Specify the range for the degree selection:
MetaOpts.Degree = 1:6;

% Specify a sparse truncation scheme (hyperbolic norm with q = 0.75):
MetaOpts.TruncOptions.qNorm = 0.75;

% Create the BCS-based PCE metamodel:
myPCE_BCS = uq_createModel(MetaOpts);

% Print a report on the calculated coefficients:
uq_print(myPCE_BCS)

% Create a visual representation of the distribution of the coefficients:
uq_display(myPCE_BCS)
fig = gcf;
fig.Name = 'Polynomial Spectrum for BCS';






%% 

% 生成随机数
r = randn(10000000,3);

% 计算函数值
f = uq_test_f1_pp2_kun(r);


% 计算均值和方差
mean_f = mean(f)
std_f = std(f)



%% 5 - VALIDATION OF THE METAMODELS

%% 5.1 Generation of a validation set
%
% Create a validation sample of size $10^4$ from the input model:
Xval = uq_getSample(1e4);

%%
% Evaluate the full model response at the validation sample points:
Yval = uq_evalModel(myModel,Xval);

%%
% Evaluate the corresponding responses
% for each of the three PCE metamodels created before:
YQuadrature = uq_evalModel(myPCE_Quadrature,Xval);
YOLS = uq_evalModel(myPCE_OLS,Xval);
YLARS = uq_evalModel(myPCE_LARS,Xval);
YOMP = uq_evalModel(myPCE_OMP,Xval);
YSP = uq_evalModel(myPCE_SP,Xval);
YBCS = uq_evalModel(myPCE_BCS,Xval);
YPCE = {YQuadrature, YOLS, YLARS, YOMP, YSP, YBCS};

%% 5.2 Comparison of the results
%
% To visually assess the performance of each metamodel, produce scatter
% plots of the metamodel vs. the true response on the validation set:
uq_figure
methodLabels = {'Quadrature', 'OLS', 'LARS', 'OMP', 'SP', 'BCS'};

for i = 1:length(YPCE)

    subplot(2,3,i)
    uq_plot(Yval, YPCE{i}, '+')
    hold on
    uq_plot([min(Yval) max(Yval)], [min(Yval) max(Yval)], 'k')
    hold off
    axis equal 
    axis([min(Yval) max(Yval) min(Yval) max(Yval)]) 
    
    title(methodLabels{i})
    xlabel('$\mathrm{Y_{true}}$')
    ylabel('$\mathrm{Y_{PC}}$')

end

%% 5.3 Computation of the validation error
myPCEs = {myPCE_Quadrature, myPCE_OLS, myPCE_LARS, myPCE_OMP, myPCE_SP, myPCE_BCS};

fprintf('Validation error:\n')
fprintf('%10s | Rel. error | ED size\n', 'Method')
fprintf('---------------------------------\n')
for i = 1:length(YPCE)
    fprintf('%10s | %10.2e | %7d\n', methodLabels{i}, mean((Yval - YPCE{i}).^2)/var(Yval), myPCEs{i}.ExpDesign.NSamples);
end
>>>>>>> 62bc3e4b2cb6f098dac8ef32b0d8a02e3d3b1a31
