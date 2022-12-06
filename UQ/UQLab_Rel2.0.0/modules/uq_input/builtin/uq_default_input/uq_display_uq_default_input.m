function uq_display_uq_default_input( module, inptArray, varargin )
%UQ_DISPLAY_UQ_DEFAULT_INPUT is a utility function for visualising a random
% vector specified in an Input object of generated by the uq_default_input
% module. By default, it generates a scatter plot matrix of the elements of
% the random vector. There is also the option to plot the PDF and CDF of
% the marginal distributions of the vector components.

%% Parameters
% Set an input dimension, above which a message will be shown about having
% too many inputs
Mmax = 10;
% Flag to produce PDF.CDF of each marginal instead of scatterplots
marginals_flag = false; 
% (Normalized) Sizes
figure_PosX = 50;
figure_PosY = 50;
figure_Width = 500;
figure_Height = 400;
% Sample size
N = 1e3;
% Scatter matrix marker symbol
marker_symbol = '.';
% Number of std's for the Xrange in case of inptArray scalar (displaying of a single marginal)
nStd = 5;
Nbins = 15;

%% Consistency checks and command line parsing
M = length(module.Marginals);
if ~exist('inptArray', 'var')
    inptArray = 1:M;
end
if length(inptArray ) > Mmax
    fprintf('Requested input range is too large, please select a smaller range.\n') ;
    return;
end

%% parsing the residual command line
% initialization
if nargin > 2
    parse_keys = {'marginals'};
    parse_types = {'f'};
    [uq_cline, varargin] = uq_simple_parser(varargin, parse_keys, parse_types);
    % 'beta' option additionally prints beta
    marginals_flag = strcmp(uq_cline{1}, 'true');
end

%% Obtain the samples that will be plotted
X = uq_getSample(module,N, 'LHS');

%% Produce the plot
Min = length(inptArray);

if Min > 2 && ~marginals_flag
    % Create the figure and set the title and the position
    uq_figure('name', sprintf('Input Object: %s, Marginals: %s',...
        module.Name, num2str(inptArray)))

    % Specify colors
    Colors = uq_colorOrder(2);
    plot_Color = Colors(1,:);
    hist_Color = Colors(2,:);
    % Plot the scatter matrix
    [H,AX,BigAx,P,PAx] = plotmatrix(X(:,inptArray));
    % Fine tune axes
    for ii = 1 : Min
        idx = inptArray(ii);
        uq_formatDefaultAxes(AX(end,ii))
        set(get(AX(end,ii), 'XLabel'), 'String',...
            ['$\mathrm{', module.Marginals(idx).Name ,'}$']);
        set(get(AX(end,ii), 'XLabel'), 'FontSize', 12);

        uq_formatDefaultAxes(AX(ii,1))
        set(get(AX(ii,1), 'YLabel'), 'String',...
            ['$\mathrm{', module.Marginals(idx).Name ,'}$']);
        set(get(AX(ii,1), 'YLabel'), 'FontSize', 12);
        
        set(P(ii), 'FaceColor', hist_Color, 'EdgeColor', hist_Color, 'FaceAlpha', 1)
        for jj = 1:Min
            uq_formatDefaultAxes(AX(ii,jj))
            set(H(ii,jj), 'Color', plot_Color)
            uq_formatDefaultAxes(AX(end,ii))
        end
        set(AX, 'FontSize', 12)
    end
    
elseif Min == 2 && ~marginals_flag
    % Create the figure and set the title and the position
    uq_figure(...
        'Name',...
        sprintf(...
            'Input Object: %s, Marginals: %s',...
            module.Name,...
            num2str(inptArray)))
    % Specify colors
    Colors = uq_colorOrder(2);
    marker_color = Colors(1,:);
    hist_color = Colors(2,:);
    % Retrieve the indices of the marginals to plot
    idx1 = inptArray(1);
    idx2 = inptArray(2);
    % Get the samples of the selected marginals
    x = X(:,idx1);
    y = X(:,idx2);
    % Calculate the histograms
    [nx,cx] = hist(x,Nbins);
    [ny,cy] = hist(y,Nbins);
    % Calculate the axis limits
    dx = diff(cx(1:2));
    xlim = [ceil((cx(1)-dx)*10)/10 ceil((cx(end)+dx)*10)/10];
    dy = diff(cy(1:2));
    ylim = [ceil((cy(1)-dy)*10)/10 ceil((cy(end)+dy)*10)/10];
    
    % Now everything is ready to produce the plots
    % 1) Scatter plot
    subplot(2, 2, 2)
    uq_plot(...
        x, y,...
        'Color', marker_color,...
        'Marker', marker_symbol,...
        'LineStyle', 'none',...
        'MarkerSize', 10)
    hold on
    % Set labels
    h1 = gca;
    axis([xlim ylim])
    xlabel(['$\mathrm{', module.Marginals(idx1).Name, '}$'])
    ylabel(['$\mathrm{', module.Marginals(idx2).Name, '}$'])
    hold off
    
    % 2) Barplot of 1st marginal
    subplot(2, 2, 4)
    uq_bar(cx, -nx, 1, 'FaceColor', hist_color, 'EdgeColor', 'none')
    h2 = gca;
    axis([xlim -max(nx) 0])
    axis('off')
    
    % 3) Barplot of 2nd marginal
    subplot(2, 2, 1)
    yoff = 0;
    if prod(ylim) < 0
        yoff = min(y)*2;
    end
    uq_bar(cy-yoff, -ny, 1, 'FaceColor', hist_color, 'Horizontal', 'on')
    h3 = gca;
    axis([-max(ny) 0 ylim-yoff])
    axis('off')
    
    set(h1, 'Position', [0.35 0.35 0.55 0.55]);
    set(h2, 'Position', [.35 .05 .55 .15]);
    set(h3, 'Position', [.05 .35 .15 .55]);

else % M == 1 OR marginals_flag == true
    for ii = 1 : Min
        idx = inptArray(ii);
        % Create the figure and set the title and the position
        h = uq_figure(...
            'Name',...
            sprintf(...
                'Input Object: %s, Marginal: %s',...
                module.Name,...
                num2str(idx)));
        % Make the figure wider to accomodate the two plots incl. labels
        figpos = get(h,'Position');
        add_width = 0.5*figpos(3);
        set(h,'Position',[figpos(1)-add_width/2 figpos(2) figpos(3)+add_width figpos(4)])
        % Get color map
        Colors = uq_colorOrder(M);
        plot_Color = Colors(ii,:);
        % Get the built-in marginals
        builtin_marginals = uq_getAvailableMarginals;
        % Check whether the marginal is a built-in one
        isBuiltIN = any(strcmpi(module.Marginals(idx).Type,builtin_marginals));
        % Prepare the axes
        h_PDF = axes('Position', [0.1 0.16 0.39 0.75]);
        h_CDF = axes('Position', [0.6 0.16 0.39 0.75]) ;
        if isBuiltIN
            % if it is built-in get the moments and plot PDF and CDF 
            % between mean +- nStd*std
            meanX = module.Marginals(idx).Moments(1);
            stdX = module.Marginals(idx).Moments(2);
            Xrange = linspace(meanX-nStd*stdX, meanX + nStd*stdX, N)';
            pdfX = uq_all_pdf(Xrange,module.Marginals(idx));
            cdfX = uq_all_cdf(Xrange,module.Marginals(idx));
        else
            % if it is not built-in estimate the pdf and cdf using kernel
            % smoothing
            x = X(:,idx);
            params = module.Marginals(idx).Parameters;
            meanX = mean(x);
            stdX = std(x);
            
            Xrange = linspace(meanX-nStd*stdX, meanX + nStd*stdX, N)';
            pdfX = feval(['uq_' module.Marginals(idx).Type '_pdf'], Xrange, params);
            cdfX = feval(['uq_' module.Marginals(idx).Type '_cdf'], Xrange, params);
        end

        uq_plot(h_PDF, Xrange, pdfX, 'Color', plot_Color)
        xlabel(h_PDF,['$\mathrm{', module.Marginals(idx).Name ,'}$'])
        ylabel(h_PDF, ['$\mathrm{f_{', module.Marginals(idx).Name ,'}}$'])
        
        uq_plot(h_CDF, Xrange, cdfX, 'Color',plot_Color)
        xlabel(h_CDF, ['$\mathrm{', module.Marginals(idx).Name ,'}$'])
        ylabel(h_CDF, ['$\mathrm{F_{', module.Marginals(idx).Name ,'}}$'])
        
    end
end

end

