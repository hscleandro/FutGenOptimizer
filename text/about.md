## Como Executar

### Preparando a Lista de Jogadores

Para executar o FutGenOptimizer, siga os passos abaixo:

1. Cole a lista de jogadores com as informações de posição e nota no seguinte formato:

    ```
    1. Jogador 1 (GOL) - 8,2
    2. Jogador 2 (ATA) - 7,8
    
    ...
    21. Jogador 21 (ATA) - 6,9
    ```

### Pontos Importantes

- Os jogadores devem ser numerados de 1 a 21, começando com o número do jogador na lista seguido de um ponto (ex: "1.").
- Deixe um espaço entre o nome do jogador e seu número na lista.
- Evite caracteres especiais nos nomes dos jogadores.
- As posições devem estar em maiúsculas e entre parênteses (ex: "(GOL)"), separadas do nome do jogador por um espaço.
- O algoritmo reconhece quatro posições: (GOL), (ZAG), (MEI) e (ATA).
- As notas devem estar em formato numérico decimal utilizando vírgula (ex: 7,2), e separadas por um hífen da posição do jogador.
- O campo "Taxa de aleatoriedade" serve para buscar soluções diferentes considerando duas execuções que contém a mesma lista de jogadores. O ideal é que esse valor fique entre 0.05 e 0.3.
- O campo "tempo de espera" propicia soluções mais rápidas, porém com menor equilíbrio entre os times. O ideal é que esse valor seja maior que 10.

### Executando o Aplicativo

Após copiar a lista de jogadores e colar na caixa "Lista de jogadores incluindo posição + nota", clique em "Run selection". Uma mensagem de "Loading" no canto superior esquerdo indicará o processamento do algorithmo.

## Resultados da Execução

Os resultados incluem a divisão dos jogadores por times, suas notas, posições e a média de notas de cada time. Estes resultados serão exibidos automaticamente na seção "Times Selecionados".

## Outras Informações

- **Repositório do projeto no GitHub**: Confira o [FutGenOptimizer no GitHub](https://github.com/hscleandro/FutGenOptimizer).
- **Artigo no LinkedIn**: Saiba mais sobre o desenvolvimento do projeto neste [artigo no LinkedIn](https://www.linkedin.com/pulse/futgenoptimizer-o-desafio-de-encontrar-harmonia-dentro-corr%2525C3%2525AAa-ddsyf%3FtrackingId=NtrTyxd1R%252BG4qLkbFXYD%252BQ%253D%253D/?trackingId=NtrTyxd1R%2BG4qLkbFXYD%2BQ%3D%3D).