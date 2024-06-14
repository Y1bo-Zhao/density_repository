function [sys,x0,str,ts,simStateCompliance] = TD(t,x,u,flag,CtrlPara)
%% flag ȡֵ
switch flag,    % flag Ĭ��ֵΪ 0
  case 0,       % ��ʼ��
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;  
  case 2,       % ��ɢ״̬�ĸ��� 
    sys=mdlUpdate(t,x,u,CtrlPara);
  case 3,       % ���� S-function ����� 
    sys=mdlOutputs(t,x,u);
  case {1,4,9}  % ģ���в���Ҫ�� flag ֵ 
    sys=[];    
  otherwise     % ����ֵ����
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

%% mdlInitializeSizes  ��ʼ���Ӻ���
%  flag = 0 ʱִ�У����� S-funciton ģ��Ļ�������
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes
sizes = simsizes;           % ���� simsizes ��װ�س�ʼ����Ϣ�ṹ
sizes.NumContStates  = 0;   % ����״̬������
sizes.NumDiscStates  = 2;   % ��ɢ״̬������
sizes.NumOutputs     = 2;   % ���������
sizes.NumInputs      = 1;   % ���������
sizes.DirFeedthrough = 0;   % ��������˿ڵ��ź��Ƿ�������Ӻ�����ʹ�ã�1 ��ʾ��ֱ����ϵ����������� sys ���� u ��ֱ�ӵ���ϵ
sizes.NumSampleTimes = 1;   % ����ʱ�������
sys = simsizes(sizes);      % �ٴε��� simsizes ���� sizes �ṹ�е���Ϣ���ݸ� sys��sys ��һ������ Simulink ������Ϣ������
x0  = [0;0];                % ״̬�����ĳ�ʼֵ
str = [];                   % ��������
ts  = [-1 0];               % ����ʱ��
simStateCompliance = 'UnknownSimState';  % ָ������״̬�ı���ʹ�������

%% mdlUpdate  ��ɢ״̬�Ӻ���
%  flag = 2 ʱִ�У�������ɢ״̬������ʱ�䡢�������ȱ�������
function sys=mdlUpdate(t,x,u,CtrlPara)
fh = fhan(x(1)-u, x(2), CtrlPara.TD.r0, CtrlPara.TD.h0);
sys(1) = x(1) + CtrlPara.T * x(2);
sys(2) = x(2) + CtrlPara.T * fh;

%% mdlOutputs  ����Ӻ���
%  flag = 3 ʱִ�У����� S-function �����
function sys=mdlOutputs(t,x,u)
sys = x;

%% coustom function  �Զ��庯��
%  fhan ����
function fhan = fhan(x1,x2,r0,h0)
d = r0 * (h0^2);
a0 = h0 * x2;
y = x1 + a0;
a1 = sqrt(d * (d + 8 * abs(y)));
a2 = a0 + sign(y) * (a1 - d)/2;
sy = (sign(y + d) - sign(y - d))/2;
a = (a0 + y - a2) * sy + a2;
sa = (sign(a + d) - sign(a - d))/2;
fhan = -r0 * (a / d - sign(a)) * sa - r0 * sign(a);

%% end