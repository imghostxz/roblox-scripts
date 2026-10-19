# Roblox Scripts — ImGhostDev

Scripts prontos em Luau para usar no seu jogo do Roblox. É só copiar, colar e mudar os IDs.
Todos têm comentários em português explicando o que cada parte faz.

🔗 Portfólio: **https://imghostxz.github.io** · Discord: **imghostxz**

---

## Como usar

1. Abra o arquivo aqui no GitHub e copie o código.
2. No Roblox Studio, crie o tipo certo de script no lugar indicado na tabela:
   - `.server.luau` → **Script**
   - `.client.luau` → **LocalScript**
   - `.luau` (sem nada no meio) → **ModuleScript**
3. Dê ao script o **mesmo nome** do arquivo, sem a extensão (ex.: `PlayerData`).
4. Troque os valores em MAIÚSCULO no topo (ID do grupo, da badge, do GamePass…).

> Para testar DataStore no Studio: **Home → Game Settings → Security → Enable Studio Access to API Services**.

---

## Lista de scripts

| Script | Tipo | Onde colocar | O que faz |
|---|---|---|---|
| [PlayerData](dados/PlayerData.luau) | ModuleScript | ServerScriptService | Salva e carrega os dados do jogador do jeito seguro |
| [Leaderstats](dados/Leaderstats.server.luau) | Script | ServerScriptService | Mostra moedas e nível na lista de jogadores |
| [DailyReward](dados/DailyReward.server.luau) | Script | ServerScriptService | Recompensa a cada 24 horas |
| [GroupJoinPrompt](grupo/GroupJoinPrompt.client.luau) | LocalScript | StarterPlayerScripts | Pede para o jogador entrar no seu grupo |
| [GroupReward](grupo/GroupReward.server.luau) | Script | ServerScriptService | Bônus para quem é membro do grupo |
| [DevProducts](compras/DevProducts.server.luau) | Script | ServerScriptService | Entrega compras de Developer Products sem duplicar |
| [GamePass](compras/GamePass.server.luau) | Script | ServerScriptService | Benefício de GamePass (VIP) |
| [RateLimiter](seguranca/RateLimiter.luau) | ModuleScript | ServerScriptService | Bloqueia spam em RemoteEvents |
| [ButtonHover](interface/ButtonHover.client.luau) | LocalScript | Dentro de um botão | Animação ao passar o mouse e clicar |
| [Sprint](jogador/Sprint.client.luau) | LocalScript | StarterPlayerScripts | Correr com Shift (botão no celular) |
| [BadgeOnJoin](jogador/BadgeOnJoin.server.luau) | Script | ServerScriptService | Badge de boas-vindas |
| [ProximityDoor](mapa/ProximityDoor.server.luau) | Script | Dentro da porta | Porta que abre com E |

---

## Dados (DataStore)

### PlayerData
O coração dos outros scripts de dados. Carrega o save quando o jogador entra, salva quando ele sai,
a cada 2 minutos e quando o servidor fecha.

**Por que ele não perde dados:**
- Usa `pcall` e tenta de novo quando o Roblox falha (isso acontece de vez em quando).
- Se o save **não carregar**, o jogador é expulso com uma mensagem, em vez de jogar com dados vazios
  e apagar o save verdadeiro ao sair. Esse é o erro mais comum.
- Usa `BindToClose` para o servidor esperar os saves antes de desligar.
- Campos novos que você adicionar no `TEMPLATE` aparecem sozinhos para quem já tinha save.

**Erros comuns que ele evita:** salvar sem `pcall`, salvar dados que não carregaram, esquecer o
`BindToClose`, e salvar toda hora (o Roblox tem limite de pedidos).

Em outros scripts do servidor:
```lua
local PlayerData = require(game.ServerScriptService.PlayerData)

local data = PlayerData.waitFor(player)       -- espera os dados carregarem
PlayerData.increment(player, "Coins", 50)     -- soma 50 moedas
PlayerData.set(player, "Level", 2)            -- muda um valor
```

### Leaderstats
Cria a pasta `leaderstats` com os valores do PlayerData e atualiza sozinho quando eles mudam.
Escolha o que aparece na lista `SHOW`.

### DailyReward
Quando o jogador entra, confere se já passaram 24 horas desde a última recompensa e dá as moedas.
Usa o relógio do servidor, então mudar a hora do computador não adianta.

---

## Grupo

### GroupJoinPrompt
Alguns segundos depois de entrar, abre a janela oficial do Roblox para entrar no seu grupo.
Quem já é membro não recebe o pedido. Coloque o ID do grupo em `GROUP_ID`
(é o número no link: `roblox.com/communities/`**`12345678`**`/...`).

### GroupReward
Dá um bônus para membros do grupo (exemplo: mais velocidade e o atributo `GroupMember`).
Dá para limitar a cargos maiores com `MIN_RANK`.
O Roblox guarda a resposta durante a partida, então quem acabou de entrar no grupo recebe o bônus
na próxima vez que entrar no mapa.

---

## Compras

### DevProducts
Para produtos que dá para comprar várias vezes (moedas, boosts…).
Cada compra tem um código único, que fica guardado nos dados do jogador. Assim, se o Roblox
mandar a mesma compra de novo, ela não é entregue duas vezes. A compra só é confirmada depois de salvar.
**Só pode existir um `ProcessReceipt` no jogo**, então coloque todos os produtos na tabela `PRODUCTS`.

### GamePass
Confere se o jogador tem o GamePass quando entra e também quando compra durante a partida.
O exemplo dá o atributo `VIP` e mais velocidade. Troque pelo benefício que quiser.

---

## Segurança

### RateLimiter
Limita quantas vezes cada jogador pode disparar um RemoteEvent por segundo.
Exploiters costumam spammar eventos; isso corta o problema. Exemplo de uso dentro do próprio arquivo.
Regra de ouro: **o servidor nunca confia no que o cliente manda** (preço, dano, quantidade).

---

## Interface

### ButtonHover
Coloque dentro de qualquer botão. Ele cresce um pouco quando o mouse passa e afunda quando clica,
usando `UIScale` (não estraga o tamanho que você definiu).

---

## Jogador

### Sprint
Segure Shift para correr. No celular, aparece um botão "Correr" automaticamente.
Ajuste `WALK_SPEED` e `RUN_SPEED`.

### BadgeOnJoin
Entrega uma badge de boas-vindas na primeira vez que a pessoa entra.
A badge precisa estar criada e ativada na página do seu jogo.

---

## Mapa

### ProximityDoor
Coloque dentro da Part da porta. Aperte E para abrir; ela gira pela lateral e fecha sozinha
depois de `AUTO_CLOSE` segundos. Use `OPEN_ANGLE = -90` para abrir para o outro lado.

---

Feito por **ImGhostDev**. Pode usar nos seus jogos, inclusive comerciais (licença MIT).
Se ajudou, deixa uma ⭐ no repositório.
