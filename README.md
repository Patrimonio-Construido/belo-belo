# Belô Belô

## Estrutura

```
lib/
├── main.dart                    # entry point
├── models/                      # classes
│   ├── player_model.dart
│   ├── question_model.dart
│   └── boardsquare_model.dart
|   └── ...
├── data/                        # listas estáticas / mocks
│   ├── player_data.dart
│   ├── question_data.dart
│   └── boardsquare_data.dart
|   └── ...
└── widgets/                     # UI
    ├── player_widget.dart
    ├── dice_widget.dart
    ├── boardsquare_widget.dart
    └── ...
```

Padrão para cada entidade: `model` define a classe/enum, `data` expõe uma
lista estática (`final List<X> xs = [...]`) com os valores de exemplo/mock, e
`widget` recebe uma instância do model e sabe desenhá-la. Ao adicionar uma
nova entidade (ex.: cartas, tabuleiro em si), siga o mesmo trio
model → data → widget.

## Rodando o projeto

```bash
flutter pub get
flutter run
```
## To-do

- [ ] Tela Inicial
  - [ ] Widgets dos botões
  - [ ] Botão para Jogar, Créditos
- [ ] Tela Créditos
- [ ] Tela Jogo
  - [ ] Montar a HUD
  - [ ] Tabuleiro
  - [ ] Organizar as casas do tabuleiro
  - [ ] Animação de passar a vez
  - [ ] Animação de rolar o dado
  - [ ] Animação andar o jogador
  - [ ] Animação de ganhar o jogo
  - [ ] Música de fundo
  - [ ] Som de rodar dado
  - [ ] Som de andar o jogador
  - [ ] Som de ganhar o jogo
  - [ ] Som de passar a vez
- [ ] Tela de Quiz
  - [ ] Widget de temporizador
  - [ ] Widget de pergunta/resposta
  - [ ] Som de acerto/erro
  - [ ] Música do quiz

## Créditos

Coordenação:
- Profª. Dra. Gláucia Nolasco de Almeida Mello
- Profª. Dra. Cynara Fidler Bremer

Desenvolvimento:

- [Felipe Guerzoni Martins Flôres Maia](https://github.com/flp2113)
- [Alex de Castro Mendes Marques](https://github.com/AlexMarques00)

Texto:

- Camila Mara de Brito Bomfim
- Dyana Virgínia Soares Madureira
- Maria Clara Lara Ferreira

Diagramação:

- Camila Mara de Brito Bomfim
- Clara Brunialti Godard

Ilustração:

- Estevam Gomes
