clc;clear all

[x,y]=meshgrid(-1:0.01:1,-1:0.01:1);
z = x.^3+3*y.^3-x.*y;
mesh(x,y,z)

%%
clc;clear all
syms x y
f=x^3+3*y^3-x*y;
fx=diff(f,x)
fy=diff(f,y)
[x0,y0]=solve(fx,fy,[x,y])

x0(find(isreal(x0)==1))
y0(find(isreal(y0)==1))
x0
y0
%%
if isempty(x0)
error('���������ڼ�ֵ��!');
end
fxx=diff(fx,x)
fyy=diff(fy,y)
fxy=diff(fx,y)
for k=1:length(x0)
fv=limit(limit(f,x,x0(k)),y,y0(k));
A=limit(limit(fxx,x,x0(k)),y,y0(k));
B=limit(limit(fxy,x,x0(k)),y,y0(k));
C=limit(limit(fyy,x,x0(k)),y,y0(k));
if A*C-B^2>0
if A<0
disp(['��[',char(x0(k)),', ', char(y0(k)),']�Ǽ���ֵ��, ����ֵΪ', char(fv)]);
else
disp(['��[',char(x0(k)),', ', char(y0(k)),']�Ǽ�Сֵ��, ��СֵΪ', char(fv)]);
end
elseif A*C-B^2<0
disp(['��[',char(x0(k)),', ', char(y0(k)),']���Ǽ�ֵ��']);
else
disp(['�޷��жϵ�[',char(x0(k)),', ', char(y0(k)),']�Ƿ�ֵ��']);
end
end

(1/243)^(1/3)
243^(1/3)/27
243^(2/3)/243