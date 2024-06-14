function [sys,x0,str,ts,simStateCompliance] = NLSEF_fal(t,x,u,flag,CtrlPara)
%% flag ȡֵ
switch flag,    % flag Ĭ��ֵΪ 0
  case 0,       % ��ʼ��
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;  
  case 3,       % ���� S-function ����� 
    sys=mdlOutputs(t,x,u,CtrlPara); 
  case {1,2,4,9}   % ģ���в���Ҫ�� flag ֵ 
    sys=[];      
  otherwise     % ����ֵ����
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

%% mdlInitializeSizes  ��ʼ���Ӻ���
%  flag = 0 ʱִ�У����� S-funciton ģ��Ļ�������
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes
sizes = simsizes;           % ���� simsizes ��װ�س�ʼ����Ϣ�ṹ
sizes.NumContStates  = 0;   % ����״̬������
sizes.NumDiscStates  = 0;   % ��ɢ״̬������
sizes.NumOutputs     = 1;   % ���������
sizes.NumInputs      = 2;   % ���������
sizes.DirFeedthrough = 1;   % ��������˿ڵ��ź��Ƿ�������Ӻ�����ʹ�ã�1 ��ʾ��ֱ����ϵ����������� sys ���� u ��ֱ�ӵ���ϵ
sizes.NumSampleTimes = 1;   % ����ʱ�������
sys = simsizes(sizes);      % �ٴε��� simsizes ���� sizes �ṹ�е���Ϣ���ݸ� sys��sys ��һ������ Simulink ������Ϣ������
x0  = [];                   % ״̬�����ĳ�ʼֵ
str = [];                   % ��������
ts  = [-1 0];               % ����ʱ��
simStateCompliance = 'UnknownSimState';  % ָ������״̬�ı���ʹ�������

%% mdlOutputs  ����Ӻ���
%  flag = 3 ʱִ�У����� S-function �����
function sys=mdlOutputs(t,x,u,CtrlPara)
fe1 = fal(u(1),CtrlPara.NLSEF.a1,CtrlPara.NLSEF.delta);
fe2 = fal(u(2),CtrlPara.NLSEF.a2,CtrlPara.NLSEF.delta);
u0 = CtrlPara.NLSEF.beta1 * fe1 +  CtrlPara.NLSEF.beta2 * fe2;
sys = u0;

%% coustom function  �Զ��庯��
%  fal ����
function y = fal(x,a,delta) 
    if abs(x) < delta   
        y = x / (delta^(1-a));
    else
        y = sign(x) * (abs(x)^a); 
    end

%% end