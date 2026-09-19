# WhatsApp Downloads

⬇️ **[Baixar o instalador](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest/download/WhatsApp.Downloads.dmg)** (`WhatsApp Downloads.dmg`, macOS 13+)

🇬🇧 [English](README.md) · 🇨🇳 [简体中文](README.zh.md) · 🇮🇳 [हिन्दी](README.hi.md) · 🇪🇸 [Español](README.es.md) · 🇸🇦 [العربية](README.ar.md) · 🇫🇷 [Français](README.fr.md) · 🇧🇷 [Português](README.pt.md) · 🇷🇺 [Русский](README.ru.md) · 🇯🇵 [日本語](README.ja.md) · 🇩🇪 [Deutsch](README.de.md) · 🇮🇩 [Bahasa Indonesia](README.id.md) · 🇹🇷 [Türkçe](README.tr.md)

O WhatsApp para Mac joga tudo o que você baixa direto em `~/Downloads` e não oferece
nenhuma opção para mudar isso. Esta ferramenta dá a ele uma pasta só sua, como o
Telegram Desktop já faz.

Tudo o que o WhatsApp salvar aparece em `~/Downloads/WhatsApp` poucos segundos depois.
O resto da sua pasta `~/Downloads` continua intacto.

## Instalação arrastando

O arquivo está na [página da versão mais recente](https://github.com/m12studio-ru/whatsapp-downloads-mac/releases/latest).

Baixe `WhatsApp Downloads.dmg`, abra e arraste **WhatsApp Downloads** para
*Aplicativos*. Depois abra o app **pela pasta Aplicativos**, não pela imagem de disco, e
ele se instala sozinho em segundo plano.

O app não é assinado com um certificado de desenvolvedor da Apple, então a primeira
abertura é bloqueada com *"o arquivo está danificado"* ou *"não foi possível verificar"*.
Escolha um dos caminhos:

- clique com o botão direito no app e escolha **Abrir**; se a janela oferecer apenas
  *OK* / *Mover para o Lixo*, vá em *Ajustes do Sistema → Privacidade e Segurança* e
  clique em **Abrir Mesmo Assim**; ou
- remova a marca de quarentena uma vez:

```sh
xattr -dr com.apple.quarantine "/Applications/WhatsApp Downloads.app"
```

Se você já tinha instalado a versão de linha de comando, abrir o app substitui o agente
em segundo plano por um que aponta para `/Applications/WhatsApp Downloads.app`.

O app é assinado no seu próprio Mac, não pela Apple. Por isso cada build nova parece
um app diferente para o macOS e, depois de substituí-lo, ele pede acesso à pasta
Downloads outra vez.

Para gerar a imagem de disco você mesmo são necessárias as Ferramentas de Linha de
Comando do Xcode (`xcode-select --install`). Depois:

```sh
./build.sh
```

## Instalação pela linha de comando

```sh
git clone https://github.com/m12studio-ru/whatsapp-downloads-mac.git
cd whatsapp-downloads-mac
./install.sh
```

Em seguida o macOS vai pedir que o **WhatsAppDownloads** tenha acesso à sua pasta
Downloads — clique em **Permitir**. Se a janela passar batido, você pode liberar
depois em *Ajustes do Sistema → Privacidade e Segurança → Arquivos e Pastas*.

Para testar: coloque um arquivo chamado `WhatsApp test.jpg` dentro de `~/Downloads`.

## Desinstalação

```sh
./uninstall.sh
```

Seus arquivos ficam onde estão; só o "carregador" é removido.

## O que é instalado

| Caminho | O que é |
| --- | --- |
| `~/.local/bin/whatsapp-downloads.sh` | o script que move os arquivos, um script zsh curto |
| `~/Applications/WhatsAppDownloads.app` | um app minúsculo que só executa o script |
| `~/Library/LaunchAgents/WhatsAppDownloads.plist` | acorda o script quando `~/Downloads` muda |

A versão instalada arrastando deixa apenas `/Applications/WhatsApp Downloads.app` e o
mesmo `~/Library/LaunchAgents/WhatsAppDownloads.plist`. `./uninstall.sh` remove o agente e tudo
que ele instalou na sua pasta pessoal; apagar `/Applications/WhatsApp Downloads.app` pode
exigir um administrador, e o script avisa se não conseguiu.

Por que empacotar como app? O macOS concede acesso a pastas por aplicativo. Um script
de shell solto, iniciado pelo launchd, enxerga uma pasta Downloads vazia e não faz nada
— sem avisar. Por isso o script mora dentro de um app, que é quem pode guardar a permissão.

Ele aparece em *Ajustes do Sistema → Geral → Itens de Início de Sessão → Permitir em
Segundo Plano* como **WhatsAppDownloads**, e ali dá para desligá-lo.

## Comportamento

- Move arquivos cujo nome começa com `WhatsApp ` — é assim que o app os nomeia.
- Nunca sobrescreve nada: em caso de conflito, o arquivo vira `WhatsApp Image ... (1).jpeg`.
- Ignora arquivos `.crdownload`, `.part` e `.download` até o download terminar.
- Não mexe em pastas nem em nenhum outro arquivo.

## Configuração

Edite as três variáveis no topo de `whatsapp-downloads.sh` ou defina `WA_SRC`,
`WA_DST` e `WA_PREFIX`. Se você apontar `WA_SRC` para uma pasta fora de `~/Downloads`,
o macOS vai pedir acesso a essa outra pasta.

## Testes

```sh
./test.sh
```

Leva cerca de 90 segundos e testa o caminho real, em segundo plano — launchd, o app e a
permissão — em vez de chamar o script diretamente. Ele só cria arquivos com `cctest` no
nome e apaga todos no final.

## Requisitos

macOS 13 ou mais recente. Sem dependências.

## Suporte

Este é um projeto pessoal pequeno, distribuído como está. Issues e pull requests são
bem-vindos, mas não há garantia de resposta.

## Licença

MIT

## Marca registrada

Este projeto não é afiliado nem endossado pela WhatsApp Inc. ou pela Meta Platforms, Inc. WhatsApp é uma marca registrada de seu proprietário.
