-- TIPOS DE DADOS
-- Aluno armazena os dados originais de cada estudante.
-- Status limita a situação aos valores Aprovado e Reprovado.
-- Resultado armazena os dados obtidos após avaliar o aluno.

data Aluno = Aluno
    { nome   :: String
    , notaA1 :: Double
    , notaA2 :: Double
    , faltas :: Int
    } deriving (Show)


data Status
    = Aprovado
    | Reprovado
    deriving (Show, Eq)


data Resultado = Resultado
    { nomeAluno  :: String
    , notaFinal  :: Double
    , frequencia :: Double
    , situacao   :: Status
    } deriving (Show)


-- CONFIGURAÇÃO DA DISCIPLINA
-- O programa considera que a disciplina possui
-- uma carga horária total de 60 horas.
-- Cada falta representa uma hora de ausência.

quantidadeHoras :: Int
quantidadeHoras = 60


-- DADOS DOS ALUNOS
-- Lista usada para demonstrar o funcionamento do programa.
-- Cada aluno possui nome, nota A1, nota A2 e número de faltas.

alunos :: [Aluno]
alunos =
    [ Aluno "Mariana Costa"   3.0 3.0 15
    , Aluno "Rafael Martins"  4.5 4.0  3
    , Aluno "Beatriz Ramos"   2.5 3.0 10
    , Aluno "Caio Ferreira"   4.0 3.5 16
    , Aluno "Larissa Gomes"   2.0 3.0 20
    , Aluno "Pedro Almeida"   5.0 5.0  0
    , Aluno "Isabela Nunes"   3.5 2.5 12
    , Aluno "Thiago Ribeiro"  1.5 2.0 25
    , Aluno "Sofia Carvalho"  4.0 3.0 15
    , Aluno "Matheus Barbosa" 2.8 3.1  5
    ]


-- AVALIAÇÃO DO ALUNO
-- Recebe um Aluno e gera um Resultado.
-- A nota final é a soma de A1 e A2.
-- A frequência é calculada usando as faltas e as 60 horas.
-- Para ser aprovado, o aluno precisa de nota mínima 6,0
-- e frequência mínima de 75%.

avaliarAluno :: Aluno -> Resultado
avaliarAluno aluno =
    Resultado
        (nome aluno)
        totalNota
        frequenciaAluno
        status
  where
    totalNota =
        notaA1 aluno + notaA2 aluno

    frequenciaAluno =
        100.0
            - ( fromIntegral (faltas aluno)
                / fromIntegral quantidadeHoras
                * 100.0
              )

    status
        | totalNota >= 6.0
            && frequenciaAluno >= 75.0 = Aprovado
        | otherwise = Reprovado


-- FILTROS
-- filter percorre a lista de resultados e mantém somente
-- os elementos que atendem à condição informada.
-- Uma função seleciona os aprovados e a outra os reprovados.

filtrarAprovados :: [Resultado] -> [Resultado]
filtrarAprovados =
    filter ((== Aprovado) . situacao)


filtrarReprovados :: [Resultado] -> [Resultado]
filtrarReprovados =
    filter ((== Reprovado) . situacao)


-- MÉDIA DAS NOTAS
-- foldl percorre a lista e soma todas as notas finais.
-- Depois, a soma é dividida pela quantidade de resultados.
-- Se a lista estiver vazia, a função retorna zero.

mediaNotas :: [Resultado] -> Double
mediaNotas [] = 0.0
mediaNotas resultados =
    somaNotas / fromIntegral (length resultados)
  where
    somaNotas =
        foldl
            (\acumulador resultado ->
                acumulador + notaFinal resultado
            )
            0.0
            resultados


-- MÉDIA DAS FREQUÊNCIAS
-- foldl percorre a lista e soma todas as frequências.
-- Depois, a soma é dividida pela quantidade de resultados.
-- Se a lista estiver vazia, a função retorna zero.

mediaFrequencia :: [Resultado] -> Double
mediaFrequencia [] = 0.0
mediaFrequencia resultados =
    somaFrequencias / fromIntegral (length resultados)
  where
    somaFrequencias =
        foldl
            (\acumulador resultado ->
                acumulador + frequencia resultado
            )
            0.0
            resultados


-- APRESENTAÇÃO DOS NÚMEROS
-- Arredonda um número para uma casa decimal.
-- Essa função apenas deixa o relatório mais legível.
-- Ela não interfere na aprovação ou reprovação.

arredondarUmaCasa :: Double -> Double
arredondarUmaCasa valor =
    fromIntegral (round (valor * 10)) / 10.0


-- FORMATAÇÃO DOS ALUNOS
-- Recebe um Resultado e cria a linha de texto que será
-- apresentada no relatório.
-- A função apenas cria o texto; putStrLn realiza a impressão.

formatarLinhaAluno :: Resultado -> String
formatarLinhaAluno resultado =
    "   - "
        ++ nomeAluno resultado
        ++ " [Nota Final: "
        ++ show (arredondarUmaCasa (notaFinal resultado))
        ++ " | Frequência: "
        ++ show (arredondarUmaCasa (frequencia resultado))
        ++ "%]"


-- FUNÇÃO PRINCIPAL
-- map transforma cada Aluno em um Resultado.
-- filter separa os aprovados e reprovados.
-- As funções de média usam foldl para somar os valores.
-- Por fim, o relatório é exibido no terminal.

main :: IO ()
main = do
    putStrLn "RELATÓRIO"
    putStrLn ""

    let resultados =
            map avaliarAluno alunos

        aprovados =
            filtrarAprovados resultados

        reprovados =
            filtrarReprovados resultados

        totalAlunos =
            length resultados

        quantidadeAprovados =
            length aprovados

        quantidadeReprovados =
            length reprovados

        mediaDaTurma =
            mediaNotas resultados

        mediaGeralFrequencia =
            mediaFrequencia resultados

    putStrLn "DADOS DA TURMA"

    putStrLn $
        "Carga horária considerada  : "
            ++ show quantidadeHoras
            ++ " horas"

    putStrLn $
        "Total de alunos analisados : "
            ++ show totalAlunos

    putStrLn $
        "Quantidade de aprovados    : "
            ++ show quantidadeAprovados

    putStrLn $
        "Quantidade de reprovados   : "
            ++ show quantidadeReprovados

    putStrLn $
        "Média de notas da turma    : "
            ++ show (arredondarUmaCasa mediaDaTurma)

    putStrLn $
        "Média de frequência geral  : "
            ++ show (arredondarUmaCasa mediaGeralFrequencia)
            ++ "%"

    putStrLn "\nALUNOS APROVADOS"

    if null aprovados
        then putStrLn "   (Nenhum aluno aprovado)"
        else mapM_ (putStrLn . formatarLinhaAluno) aprovados

    putStrLn "\nALUNOS REPROVADOS"

    if null reprovados
        then putStrLn "   (Nenhum aluno reprovado)"
        else mapM_ (putStrLn . formatarLinhaAluno) reprovados
