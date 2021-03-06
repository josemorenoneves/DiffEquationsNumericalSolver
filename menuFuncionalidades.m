function menuFuncionalidades (strFuncao, pontoInicial, extremoDireito)
% Permite escolher o modo de utiliza��o do programa 
funcao = str2func(['@(t,y)', strFuncao]);

cond = 1;
while cond == 1
    fprintf(2,'\n             Menu Funcionalidades               \n');
    fprintf('--------------------------------------------------\n');
    fprintf('|Escolha o modo de utiliza��o:                   |\n');
    fprintf('--------------------------------------------------\n');
    fprintf('|A - Resolver numericamente a equa��o diferencial|\n');
    fprintf('|B - Analisar o erro cometido em fun��o do passo |\n');
    fprintf('|C - Alterar o ponto inicial                     |\n');
    fprintf('|D - Alterar o extremo direito                   |\n');
    fprintf('|E - Alterar a equa��o                           |\n');
    fprintf('|S - Sair                                        |\n');
    fprintf('--------------------------------------------------\n');
    opcao = input('--> ','s');
    
    switch opcao
        case 'A'
            syms yAnali(t) t
            numIntervalos = getNumIntervalos('A');
            metodo = getMetodo;
            
            yAnali = calculaSolucaoAnali(pontoInicial,strFuncao);
            [xNum, yNum] = calculaSolucaoNum(funcao, pontoInicial, ...
                                             extremoDireito, ...
                                             numIntervalos, metodo);
            erro = abs(yAnali(extremoDireito) - yNum(length(yNum)));
                  
            fprintf('A aproxima��o tem um erro absoluto de %f.\n', erro);
            plot(xNum, yNum, '-r+', xNum, yAnali(xNum), 'g');
            alteraGraf(metodo, strFuncao, 'R');
            fprintf('\nClique qualquer bot�o para voltar ao menu ');
            input('Funcionalidades -->','s');
            close;
        case 'B'
            numIntervalos = getNumIntervalos('B');
            numPassos = getNumPassos;
            metodo = getMetodo;
            
            [h, erros] = calculaErro(strFuncao, pontoInicial, ...
                                     extremoDireito, metodo, ...
                                     numIntervalos, numPassos);
            p = polyfit(log(h), log(erros), 1);
            e = p(1);
            k = exp(p(2));
            fprintf('Regress�o linear: Erro = %f * h^%f.\n', k, e);
            
            loglog(h, erros);
            alteraGraf(metodo, strFuncao, 'E');
            fprintf('\nClique qualquer bot�o para voltar ao menu ');
            input('Funcionalidades -->','s');
            close;
        case 'C'
            pontoInicial = getPontoInicial(extremoDireito);
        case 'D'
            extremoDireito = getExtremoDireito(pontoInicial(1));
        case 'E'
            strFuncao = getStrFuncao;
            funcao = str2func(['@(t,y)',strFuncao]);
        case 'S'
            cond = 0;
        otherwise
            fprintf(2, 'Op��o inv�lida\n');
    end
end