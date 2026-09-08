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