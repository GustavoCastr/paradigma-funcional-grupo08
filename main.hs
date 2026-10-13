data Aluno = Aluno {
    nome   :: String,
    notaA1 :: Double,
    notaA2 :: Double,
    faltas :: Int
} deriving (Show)

data ResultadoAluno = ResultadoAluno {
    rNome       :: String,
    notaFinal   :: Double,
    frequencia  :: Double,
    situacao    :: String
} deriving (Show)

-- Lista de dados de exemplo
alunosExemplo :: [Aluno]
alunosExemplo = [
    Aluno "Amanda Vieira" 4.2 3.8 6,   
    Aluno "Breno Cardoso" 1.5 2.0 16,  
    Aluno "Camila Antunes" 5.0 4.5 2,  
    Aluno "Daniel Mendes" 3.0 2.5 22,  
    Aluno "Fernanda Lima" 4.0 1.8 12,  
    Aluno "Gabriel Santos" 2.5 3.5 15, 
    Aluno "Heloisa Rocha" 5.5 4.0 4,   
    Aluno "Igor Silveira" 2.0 3.8 10,  
    Aluno "Juliana Moraes" 3.2 4.1 0,  
    Aluno "Lucas Teixeira" 1.0 4.0 25  
 ]
processarAluno :: Aluno -> ResultadoAluno
processarAluno aluno = ResultadoAluno (nome aluno) totalNota porcentagemFrequencia status
  where
    totalNota = notaA1 aluno + notaA2 aluno
    -- Assumindo um total padrão de 60 horas/aulas para a conta fazer sentido com os dados fornecidos:
    -- 15 faltas em 60 aulas representa exatamente 25% de faltas (75% de presença).
    totalAulas = 60.0
    porcentagemFrequencia = 100.0 - ((fromIntegral (faltas aluno) / totalAulas) * 100.0)
    
    -- Ajuste de margem pequena (epsilon) para evitar problemas de arredondamento do Double
    status | totalNota >= 6.0 && (porcentagemFrequencia + 0.0001) >= 75.0 = "Aprovado"
           | otherwise                                                    = "Reprovado"

filtrarAprovados :: [ResultadoAluno] -> [ResultadoAluno]
filtrarAprovados resultados = filter (\r -> situacao r == "Aprovado") resultados

filtrarReprovados :: [ResultadoAluno] -> [ResultadoAluno]
filtrarReprovados resultados = filter (\r -> situacao r == "Reprovado") resultados

calcularMediaNotas :: [ResultadoAluno] -> Double
calcularMediaNotas resultados =
    let somaNotas = foldl (\acc r -> acc + notaFinal r) 0.0 resultados
    in somaNotas / fromIntegral (length resultados)

calcularMediaFrequencia :: [ResultadoAluno] -> Double
calcularMediaFrequencia resultados =
    let somaFreq = foldl (\acc r -> acc + frequencia r) 0.0 resultados
    in somaFreq / fromIntegral (length resultados)

formatarLinhaAluno :: ResultadoAluno -> String
formatarLinhaAluno r = 
    "   - " ++ rNome r ++ " [Nota Final: " ++ show (notaFinal r) ++ 
    " | Frequência: " ++ show (fromIntegral (round (frequencia r * 10)) / 10) ++ "%]"

main :: IO ()
main = do
    putStrLn "====================================================="
    putStrLn "RELATÓRIO"
    putStrLn "=====================================================\n"
    
    let resultados = map processarAluno alunosExemplo
    
    let aprovados = filtrarAprovados resultados
    let reprovados = filtrarReprovados resultados
    
    let totalAlunos = length resultados
    let qtdAprovados = length aprovados
    let qtdReprovados = length reprovados
    let mediaNotas = calcularMediaNotas resultados
    let mediaFreq = calcularMediaFrequencia resultados
    
    putStrLn "DADOS DA TURMA"
    putStrLn $ "Total de Alunos Analisados : " ++ show totalAlunos
    putStrLn $ "Quantidade de Aprovados    : " ++ show qtdAprovados
    putStrLn $ "Quantidade de Reprovados   : " ++ show qtdReprovados
    putStrLn $ "Média de Notas da Turma    : " ++ show (fromIntegral (round (mediaNotas * 10)) / 10)
    putStrLn $ "Média de Frequência Geral  : " ++ show (fromIntegral (round (mediaFreq * 10)) / 10) ++ "%"
    
    putStrLn "\nALUNOS APROVADOS"
    if null aprovados 
        then putStrLn "   (Nenhum aluno aprovado)"
        else mapM_ (putStrLn . formatarLinhaAluno) aprovados
        
    putStrLn "\nALUNOS REPROVADOS"
    if null reprovados 
        then putStrLn "   (Nenhum aluno reprovado)"
        else mapM_ (putStrLn . formatarLinhaAluno) reprovados
        
    putStrLn "\n====================================================="
