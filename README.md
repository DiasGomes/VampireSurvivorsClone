# Vampire Survivors Clone

Jogo 2D roguelike de sobrevivência desenvolvido em **Godot 4.5** com GDScript. O jogador controla um cavaleiro que enfrenta ondas infinitas de inimigos, ganha XP, sobe de nível e desbloqueia upgrades.

---

## Stack

| Item | Detalhe |
|---|---|
| Engine | Godot 4.5 |
| Linguagem | GDScript |
| Renderer | Forward Plus |
| Resolução base | 640×360 (janela 1280×720) |
| Stretch | canvas_items / integer scale |

---

## Estrutura de pastas

```
VampireSurvivorsClone/
├── Assets/
│   ├── Fonts/              # Fontes pixel
│   ├── Shaders/            # Shaders GLSL (outline, blink)
│   └── Sprites/            # Spritesheets dos personagens e objetos
├── Scenes/
│   ├── Characters/
│   │   ├── Player/         # Cena + estados do jogador
│   │   │   └── SpawnerBullet/
│   │   └── Enemys/
│   │       ├── Green_Slime/
│   │       └── PurpleSlime/
│   ├── Components/
│   │   ├── Enemy_Spawner/  # Gerenciador de spawn orbital
│   │   ├── Enemy_State_machine/
│   │   ├── State_machine/
│   │   ├── Spawner/        # SceneSpawner genérico
│   │   └── Powers/         # (em desenvolvimento)
│   ├── Main/Game/          # Cena raiz
│   ├── Objects/            # bullet.tscn, orbe.tscn
│   └── Particles/          # Efeitos visuais
└── Scripts/
    ├── Audio_Manager/      # AudioManager + MusicManager
    ├── Character/          # Entity.gd (base), enemy.gd
    ├── Components/         # scene_spawner.gd
    ├── Resource/           # status.gd, enemy_definition.gd
    └── State_machine/      # node_state_machine.gd (base)
```

---

## Arquitetura

### Padrões usados

- **State Machine** — jogador e inimigos controlados por máquinas de estados explícitas (`NodeStateMachine` / `NodeEnemyStateMachine`). Cada estado é um nó filho com métodos virtuais: `_on_enter`, `_on_exit`, `_on_process`, `_on_physics_process`, `_on_next_transitions`.
- **Component** — `SceneSpawner` é um componente reutilizável que qualquer nó pode usar para instanciar cenas.
- **Resource** — `Status` e `EnemyDefinition` são recursos Godot (`.tres`) exportados, separando dados de lógica.
- **Signal** — comunicação entre sistemas via sinais: `shoot`, `upgrade`, `died`.

### Hierarquia de cenas em runtime

```
Game
├── Player
│   ├── StateMachine → [Idle, Run]
│   └── Spawn_Bullet → bullet.tscn
└── Spawner
    ├── SpawnerEnemy (Green Slime) → green_slime.tscn + orbe.tscn
    └── SpawnerEnemy (Purple Slime)
```

---

## Sistemas

### Jogador (`Scenes/Characters/Player/player.gd`)
- Herda `Entity`
- Movimento via WASD / setas
- Disparo via clique esquerdo → emite sinal `shoot(dir, damage, critical)`
- XP acumulado em `xp`; array `xp_level[]` define o custo por nível
- Ao subir de nível emite sinal `upgrade` e reinicia XP
- Vitória ao atingir nível 10 → `new_game()` é chamado

### Entidade base (`Scripts/Character/Entity.gd`)
Atributos: `my_health`, `my_max_health`, `my_speed`, `my_damage`, `my_direction`, `my_velocity`.  
Métodos relevantes: `apply_damage(value)`, `blink(duration)`, `show_damage(number, critical)`, `outline(value)`, `spring()`.

### Inimigos (`Scripts/Character/enemy.gd`)
- Herda `Entity`
- Estado **Idle**: persegue o jogador frame a frame
- Estado **Hit**: para o movimento, reproduz animação, aguarda timer
- Estado **Died**: emite sinal `died`, remove o nó
- Ao morrer: `SpawnerEnemy` cria um `orbe.tscn` na posição

### Spawn orbital (`Scenes/Components/Enemy_Spawner/spawner_enemy.gd`)
- Spawner gira em órbita ao redor do jogador (raio + ângulo atualizados por frame)
- `limit_increase(level)` → `enemy_limit = 30 + 10 * level`
- Definições por tipo via recurso `EnemyDefinition` (cena, qtd_max, raio, ângulo inicial)

### Projétil (`Scenes/Objects/bullet.gd`)
- Velocidade fixa (escalar 2.0 × `move_and_collide`)
- Vida útil: 2 segundos (Timer)
- Dano crítico: `randf() < critical_per` (padrão 30%)
- Destrói a si mesmo ao colidir com layer **Enemys**

### Camadas de física (physics layers)

| Layer | Nome | Colidindo com |
|---|---|---|
| 1 | Geral | — |
| 2 | Enemys | Enemys, Player |
| 3 | Player | Enemys, Orbe |
| 4 | Bullet | Enemys |
| 5 | Orbe | Player |

---

## Status dos recursos

| Recurso | HP | Velocidade | Dano |
|---|---|---|---|
| Jogador | 10 | 100 | 1 |
| Green Slime | 3 | 50 | 1 |
| Purple Slime | 7 | 75 | 2 |

---

## Controles

| Ação | Tecla |
|---|---|
| Mover | WASD / setas |
| Disparar | Clique esquerdo |

---

## Estado de implementação

### Implementado
- Movimentação 8 direções
- Disparo com dano crítico e camera shake
- State machine para jogador e inimigos
- Sistema de XP e nivelamento (10 níveis)
- Dois tipos de inimigo com stats distintos
- Spawn orbital dinâmico com limite crescente
- Efeitos visuais: blink, outline, partículas, shake

### Em desenvolvimento / não integrado
- Áudio (infraestrutura `AudioManager` + `MusicManager` existe, sem sons ativos)
- Sistema de Powers (`Scenes/Components/Powers/` existe vazio)
- Atributos `recovery` e `armor` no `Status` — definidos mas sem lógica
- Menu, Game Over, persistência de dados
- Upgrades selecionáveis ao subir de nível (sinal `upgrade` já existe)

---

## Convenções do projeto

- Scripts de estado ficam **dentro da pasta da cena** que os usa, não em `Scripts/`
- Recursos de dados (`.tres`) ficam junto da cena que os referencia
- `Entity.gd` e `enemy.gd` ficam em `Scripts/Character/` por serem bases reutilizáveis
- Nomes de cenas e pastas em inglês; variáveis e comentários em português
- Sem autoloads ativos (AudioManager existe mas não está registrado como singleton)

---

## Como rodar

1. Abrir o projeto no **Godot 4.5+**
2. Cena principal: `Scenes/Main/Game/game.tscn`
3. Pressionar **F5** ou o botão Play

---

## Versões

| Tag | Data | Branch |
|---|---|---|
| v0.1.3 | 24/04/2026 | main |
| v0.1.2 | 09/04/2026 | develop |
| v0.1.1 | 08/04/2026 | develop |
| v0.1.0 | 08/04/2026 | main |
