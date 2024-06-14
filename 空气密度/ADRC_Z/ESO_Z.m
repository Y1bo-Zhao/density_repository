function [sys,x0,str,ts,simStateCompliance] = ESO(t,x,u,flag,CtrlPara)
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
sizes.NumDiscStates  = 3;   % ��ɢ״̬������
sizes.NumOutputs     = 3;   % ���������
sizes.NumInputs      = 2;   % ���������
sizes.DirFeedthrough = 0;   % ��������˿ڵ��ź��Ƿ�������Ӻ�����ʹ�ã�1 ��ʾ��ֱ����ϵ����������� sys ���� u ��ֱ�ӵ���ϵ
sizes.NumSampleTimes = 1;   % ����ʱ�������
sys = simsizes(sizes);      % �ٴε��� simsizes ���� sizes �ṹ�е���Ϣ���ݸ� sys��sys ��һ������ Simulink ������Ϣ������
x0  = [0;0;0];                   % ״̬�����ĳ�ʼֵ
str = [];                   % ��������
ts  = [-1 0];                % ����ʱ��
simStateCompliance = 'UnknownSimState';  % ָ������״̬�ı���ʹ�������

%% mdlUpdate  ��ɢ״̬�Ӻ���
%  flag = 2 ʱִ�У�������ɢ״̬������ʱ�䡢�������ȱ�������
function sys=mdlUpdate(t,x,u,CtrlPara)
e1 = x(1) - u(2);
sys(1) = x(1) + CtrlPara.T * (x(2) - CtrlPara.ESO.beta01 * e1);
sys(2) = x(2) + CtrlPara.T * (x(3) - CtrlPara.ESO.beta02 * fal(e1,1/2,CtrlPara.ESO.delta) + CtrlPara.b * u(1));
sys(3) = x(3) - CtrlPara.T * CtrlPara.ESO.beta03 * fal(e1,1/4,CtrlPara.ESO.delta);

%% mdlOutputs  ����Ӻ���
%  flag = 3 ʱִ�У����� S-function �����
function sys=mdlOutputs(t,x,u)
sys = x;

%% coustom function  �Զ��庯��
%  fal ����
function y = fal(x,a,delta) 
    if abs(x) < delta   
        y = x / (delta^(1-a));
    else
        y = sign(x) * (abs(x)^a); 
    end
    
%% end