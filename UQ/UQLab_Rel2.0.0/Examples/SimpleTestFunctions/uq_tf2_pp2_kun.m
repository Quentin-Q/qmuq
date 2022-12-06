function Y = uq_tf2_pp2_kun(X,P)
% uq_test_f2_pp2_kun是一个在英文论文2中的测试函数2
%

% processing the parameters
switch nargin
    case 1
        a = -0.5;
        b = 1;
        c = 1;
        d = 0.5;
        e = 0.5;
    case 2
        a = P(1);
        b = P(2);
        c = P(3);
        d = P(4);
        e = P(5);
    otherwise
        error('Number of input arguments not accepted!');
end

% computing the response value
PN1 = 10-X(:,1);
PN2 = (9-X(:,2)).^2;
PN3 = 8-X(:,3);
PN4 = (7-X(:,4)).^2;

Y(:,1) = log(abs(PN1.*PN2.*PN3.*PN4)) ...
    +a*X(:,1).^2 + b*X(:,5).^2 + c*X(:,6).^3 ...
    + d*X(:,2).*X(:,4) + e*X(:,3).*X(:,5).^2;
