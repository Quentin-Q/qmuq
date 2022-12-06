function Y = uq_tf1_pp2_kun(X,P)
% uq_tf1_pp2_kun是一个在英文论文2中的测试函数1
%

% processing the parameters
switch nargin
    case 1
        a = 1;
        b = -0.5;
        c = -0.5;
        d = 1;
        e = 2;
        f = 0.5;
        g = 0.5;
        h = -1;
    case 2
        a = P(1);
        b = P(2);
        c = P(3);
        d = P(4);
        e = P(5);
        f = P(6);
        g = P(7);
        h = P(8);
    otherwise
        error('Number of input arguments not accepted!');
end

% computing the response value
Y(:,1) =a*X(:,1).^2 + b*X(:,1) + c*X(:,2).^2 ...
    + d*X(:,2) + e*X(:,3).^2 + f*X(:,1).*X(:,2) ...
    + g*(X(:,1).^2).*X(:,2) + h*X(:,2).*X(:,3);


