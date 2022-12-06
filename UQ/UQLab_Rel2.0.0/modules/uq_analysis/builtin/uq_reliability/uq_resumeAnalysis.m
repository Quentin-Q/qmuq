function CurrentAnalysis = uq_resumeAnalysis(varargin)
% UQ_RESUMEANALYSIS resumes a previously paused analysis in UQLab after the
% user provides additional information
%
%
%     myAnalysis = UQ_RESUMEANALYSIS(Y): Resume the currently active uq_analysis by
%     providing the model evaluation corresponding to the samples given in
%     myAnalysis.Results.NextSample, where myAnalysis is the analysis resulting
%     from the previous run and which was paused following the enabling of the
%     asynchronous feature.
%     myAnalysis = UQ_RESUMEANALYSIS(MYANALYSIS, Y): Resume the analysis in object
%     MYANALYSIS by providing the model evaluation corresponding to the samples given in
%     MYANALYSIS.Results.NextSample, where MYANALYSIS is the analysis resulting
%     from the previous run and which was paused following the enabling of the
%     asynchronous feature.
%      myAnalysis = UQ_RESUMEANALYSIS('UQ_SAVEDANALYSIS.MAT', Y): Resume the analysis saved
%     in the Matlab file 'UQ_SAVEDANALYSIS.MAT' by providing the model
%     evaluations corresponding to the samples given in 
%     CurrentAnalysis.Results.NextSample, where CurrentAnalysis is the analysis 
%     previously saved in 'UQ_SAVEDANALYSIS.MAT'. Note that this .mat file is 
%     generated by default whenever the asynchronous feature is enabled.
%
%   See also: uq_createAnalysis, uq_reliability, uq_getAnalysis, 
%             uq_listAnalyses, uq_selectAnalysis, uq_createInput, 
%             uq_createModel,  uq_doc


%% Get and validate options
if nargin == 1
    SampleEval = varargin{1};
    CurrentAnalysis = uq_getAnalysis();
    if isempty(CurrentAnalysis)
        error('No analysis found to resume');
    end
elseif nargin == 2
    CurrentAnalysis = varargin{1};
    SampleEval = varargin{2} ;
    
end
if isa(CurrentAnalysis,'uq_analysis')
    % The user has provided the previous analysis
    % Do nothing
elseif isa(CurrentAnalysis,'char') || isa(CurrentAnalysis,'string')
    % The user has provided the .mat file
    try
        tmp = load( CurrentAnalysis ) ;
        CurrentAnalysis = tmp.CurrentAnalysis ;
    catch
        error('The resume file could not be found! Make sure the file is accessible from your current workspace!');
    end
    if ~isa(CurrentAnalysis,'uq_analysis')
        error('The resume variable provided is not of type ''uq_analysis''');
    end
else
    error('The provided analysis is in an unexpected format.');
end

NextSample = CurrentAnalysis.Results.NextSample ;

if size(NextSample,1) ~= size(SampleEval,1)
    error('The given evaluations are inconsistent in size with the provided input sample');
end

% Supply the evaluation
CurrentAnalysis.Internal.Runtime.Async.Y = SampleEval ;
CurrentAnalysis.Internal.Runtime.Async.X = NextSample ;

success  = 1 ;

% Now run the analysis - IDEALLY I WOULD DO THIS
CurrentAnalysis.Results = eval([CurrentAnalysis.Type '(CurrentAnalysis)']) ;

% Save for next iteration
% save the current status of the analysis
if CurrentAnalysis.Internal.Async.Save
    Results.Snapshot = fullfile(CurrentAnalysis.Internal.Async.Path, ...
        CurrentAnalysis.Internal.Async.Snapshot) ;
    save(Results.Snapshot,'CurrentAnalysis');
end
end