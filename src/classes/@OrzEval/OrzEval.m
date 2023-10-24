
classdef OrzEval
    properties (SetAccess = public)
        ER;
        EER;
        Thres;
        
        A;
        FAR;
        FRR;
        
        nP;
        nN;
        
        flgSIM;
        
    end% properties
    
    methods
        function OB = OrzEval(VAL, Label, varargin)
%function OB = OrzEval(VAL, Label, varargin)
% VAL:      �ގ��x�������͔�ގ��x�i�����j���������s��A�������͍s�x�N�g��
%           VAL���s��̏ꍇ�A���N���X���i�Q�N���X�ȏ�j�Ɣ��f
%           VAL���s�x�N�g���̏ꍇ�A�P�N���X�Ɣ��f��ER���v�Z���Ȃ�
% Label:    VAL�̗񐔂Ɠ����T�C�Y�̍s�x�N�g��
%           VAL�̐������x����ێ�
%           ���N���X���̏ꍇ�A�P�`�N���X���̒l
%           �P�N���X���̏ꍇ�A�P�iPositive�j�ƂO�iNegative�j
% ��O�����F VAL�̒l���ގ��x����ގ��x�i�����j�����肷��
%           �f�t�H���g�ł́A�ގ��x
%           ����'D'����O�����ɓ��͂��ꂽ�ꍇ�A��ގ��x�i�����j�Ƃ��Čv�Z
%           
% PlotEER�F False Reject Rate��False Alarm  Rate��Figure(10)�ɕ`��
%           �����ɂ��A�ԍ���ύX�\
% PlotROC�F ROC curve��Figure(100)�ɕ`��
%           �����ɂ��A�ԍ���ύX�\
            
            VAL=VAL(:,:);
            % �ގ��x����ގ��x��
            OB.flgSIM=true;
            if nargin == 3
                if varargin{1}=='D';
                    OB.flgSIM=false;
                end
            end
            
            % One-Class ��肩�ǂ���
            if size(VAL,1)>=2
                B=zeros(size(VAL));
                Lu = unique(Label);
                for I=1:size(Lu,2)
                    B(I,Label==Lu(I))=1;
                end
                
                if OB.flgSIM
                    [v ind] = max(VAL,[],1);
                else
                    [v ind] = min(VAL,[],1);
                end
                OB.ER = 1-mean(ind == Label);
                
            else
                B = zeros(size(Label));
                B(Label~=0)=1;
            end
            VAL=VAL(:);
            B=B(:);
            
            OB.nP = sum(B==1);
            OB.nN = sum(B==0);
            
            if OB.flgSIM
                [OB.A C]= sort(VAL,'ascend');
            else
                [OB.A C]= sort(VAL,'descend');
            end
            D = B(C);
            
            OB.FAR = 1-cumsum(D==0)/OB.nN;
            OB.FRR = cumsum(D==1)/OB.nP;
            
            [val ind] = min((abs(OB.FAR-OB.FRR)));
            OB.EER = (OB.FAR(ind)+OB.FRR(ind))/2;
            OB.Thres = OB.A(ind);
        end
        
        function PlotEER(OB,varargin)
            if nargin == 2
                No = varargin{1};
            else
                No = 10;
            end
            
            figure(No)
            clf;
            hold on
            plot(OB.A,OB.FRR,'b');
            plot(OB.A,OB.FAR,'r');
            title('FRR - FAR');
            legend('False Reject Rate','False Alarm  Rate' );
            xlabel('Threshold')
            ylabel('Rate')
            hold off
        end
        
        function PlotROC(OB,varargin)
            if nargin == 2
                No = varargin{1};
                color = 'r';
            elseif nargin == 3
                No = varargin{1};
                color = varargin{2};   
            else
                No = 100;
                color = 'r';
            end
            
            figure(No)
            %clf;
            hold on
            plot(OB.FAR,1-OB.FRR,color);
            xlabel('False Positive Rate')
            ylabel('True Positive Rate')
            hold off
        end
    end
end