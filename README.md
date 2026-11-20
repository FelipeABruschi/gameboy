# Gameboy PICO-8

Jogos originais feitos em [PICO-8](https://www.lexaloffle.com/pico-8.php) para o meu projeto de console portátil.

## Jogar no navegador

Não precisa instalar nada, é só abrir o link:

**https://felipeabruschi.github.io/gameboy/**

Jogos disponíveis:

- Caça-níquel
- Labirinto
- Space Run

## Rodar na sua máquina (Linux)

O PICO-8 é um software proprietário da Lexaloffle e **não está incluído neste repositório**. É preciso ter uma cópia dele.

1. Clone o repositório:

   ```bash
   git clone https://github.com/FelipeABruschi/gameboy.git
   cd gameboy
   ```

2. Baixe o PICO-8 para Linux em https://www.lexaloffle.com/pico-8.php (é necessário ter comprado) e extraia o conteúdo numa pasta chamada `pico-8/` dentro do projeto, de forma que o executável fique em `pico-8/pico8`.

3. Dê permissão e execute o script:

   ```bash
   chmod +x run.sh
   ./run.sh
   ```

   O script abre o PICO-8 usando a pasta `carts/` deste projeto.

4. Dentro do PICO-8, liste e carregue os jogos:

   ```
   ls
   load spacerun.p8
   run
   ```

Também dá para abrir um jogo direto pelo terminal:

```bash
./pico-8/pico8 -home "$(pwd)" -run carts/spacerun.p8
```

## Controles

| Tecla | Botão |
|-------|-------|
| Setas | Direcional |
| Z | Botão O |
| X | Botão X |

## Estrutura do projeto

```
gameboy/
├── carts/     # código-fonte dos jogos (.p8)
├── docs/      # versão web (HTML5) publicada no GitHub Pages
├── pico-8/    # PICO-8 (não versionado, baixe separadamente)
└── run.sh     # abre o PICO-8 usando a pasta carts/ do projeto
```

## Atualizar a versão web

Depois de alterar um jogo, exporte de novo no PICO-8 (`load jogo.p8` e `export jogo.html`), copie o `.html` e o `.js` para `docs/` e faça commit e push. O GitHub Pages atualiza em um ou dois minutos.
