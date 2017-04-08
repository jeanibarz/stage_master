% Etude pour le cas particulier d'une matrice adjacente :
% booleenne,
% non obligatoirement symetrique,
% de taille 3,
% et avec une diagonale de 1...
clear;
clc;

% M=[0 1 0;
%    1 0 0;
%    0 1 0]
for i=1:100
    M=randn(3,3)>0.5;
    M=M|eye(3,3);
    % Coefficients
    % [1 A B
    %  C 1 D
    %  E F 1]
    A=M(1,2);
    B=M(1,3);
    C=M(2,1);
    D=M(2,3);
    E=M(3,1);
    F=M(3,2);
    
    M2a=(M^2)>0;
    M2a;

    % Permutations horizontales...
    % [1 A B      [1 B A
    %  C 1 D  ==>  D 1 C
    %  E F 1]      F E 1]
    Mp1=M;
    Mp1(1,2)=B;
    Mp1(1,3)=A;
    Mp1(2,1)=D;
    Mp1(2,3)=C;
    Mp1(3,1)=F;
    Mp1(3,2)=E;
    
    % Permutations verticales...
    % [1 A B      [1 F D
    %  C 1 D  ==>  E 1 B
    %  E F 1]      C A 1]
    Mp2=M;
    Mp2(1,2)=F;
    Mp2(1,3)=D;
    Mp2(2,1)=E;
    Mp2(2,3)=B;
    Mp2(3,1)=C;
    Mp2(3,2)=A;

    M2b=M|(Mp1&Mp2);

    M;
    Mp1;
    Mp2;
    fprintf('Egalite : ');
    if(sum(sum(M2a == M2b))==9)
        display('ok')
    else
        display('ko')
    end
end