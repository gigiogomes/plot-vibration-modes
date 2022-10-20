function plotar_modos(nno,nel,gcoord,nodel,om,mod,nglpn,ngl,LN)
%
%Função para plotar modos de vibração de estruturas de pórtico e treliças
%
%Dinâmica das estruturas, PosMEC UFABC Q2022.1 - Prof.: Reyolando Brasil
%Aluno: Geovane Gomes | Data: maio/2022
%
%-------------------------------------------------------------------------
%Argumentos:
%nno=número de nós; nel=número de elementos; gcoord=coordenadas dos nós
%nodel=connectividade dos elementos, om=frequências naturais
%mod=modos de vibração; nglpn=número de graus de liberdade por nó
%ngl=número de graus de liberdade livres; LN=matriz que relaciona os nós
%com os graus de liberdade, se LN(i,j)>ngl, restrito.
%-------------------------------------------------------------------------
%
%normalização dos modos
modos=zeros(nno,nglpn,ngl);
for k=1:ngl
    for i=1:nno
        for j=1:nglpn
            if LN(i,j)<=ngl
                modos(i,j,k)=mod(LN(i,j),k);
            end
        end
    end
end
desloc=zeros(size(modos));
for k=1:ngl
    for i=1:nno
        for j=1:nglpn
            desloc(i,j,k)=modos(i,j,k)./max(abs(modos(:,:,k)),[],'all');
        end
    end
end
u=zeros(nno,10,ngl); %horizontais
v=zeros(nno,10,ngl); %verticais
for k=1:ngl
    for i=1:nno
        u(i,:,k)=linspace(desloc(i,1,k),-desloc(i,1,k),10);
        v(i,:,k)=linspace(desloc(i,2,k),-desloc(i,2,k),10);
    end
end
u=[u -u];
v=[v -v];
%
%configuração de plotagem
%
eixo_x=(max(abs(gcoord(:,1)))-min(abs(gcoord(:,1)))+10)/2;
eixo_y=(max(abs(gcoord(:,2)))-min(abs(gcoord(:,2)))+10)/2;
set(gcf,'Visible','off');
M(20) = struct('cdata',[],'colormap',[]);
%
%loop principal
n=4;
if ngl<4
    n=ngl;
end
%
for j=1:20
    for i=1:nel
        for k=1:n
            no1=nodel(i,1); no2=nodel(i,2);
            x1=gcoord(no1,1); y1=gcoord(no1,2);
            x2=gcoord(no2,1); y2=gcoord(no2,2);
            x1_def=x1+u(no1,j,k); y1_def=y1+v(no1,j,k);
            x2_def=x2+u(no2,j,k); y2_def=y2+v(no2,j,k);
            subplot(round(n/2),2,k)
            hold on
            box on
            title([num2str(k),'º modo de vibração'])
            subtitle(['freq = ',num2str(om(k)),' rad/s'])
            axis square
            xlim([min(gcoord(:,1))-eixo_x max(gcoord(:,1))+eixo_x])
            ylim([min(gcoord(:,2))-eixo_y max(gcoord(:,2))+eixo_y])
            %h1(i,j,k)=plot([x1 x2],[y1 y2],'.--k','MarkerSize',10,...
            %    'MarkerEdgeColor','k');
            h2(i,j,k)=plot([x1_def x2_def],[y1_def y2_def],'.-b',...
                'MarkerSize',10,'MarkerEdgeColor','b');
            if j>1
             %   set(h1(i,j-1,k),'Visible','off')
                set(h2(i,j-1,k),'Visible','off')
            end
        end
    end
    M(j)=getframe(gcf);
end
%
%animação e vídeo
%
close all
movie(figure,M,24);
video=VideoWriter('modos','MPEG-4');
video.FrameRate=12;
open(video);
writeVideo(video,M);
close(video);
%
%%%%%%%%%%%%%% Fim da função plotar_modos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%