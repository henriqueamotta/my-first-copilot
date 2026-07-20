# 🧩 Modos do Copiloto (Ask, Plan, Agent)

![IA](https://img.shields.io/badge/IA-Assistente%20Inteligente-blue)
![Prompt](https://img.shields.io/badge/Prompt-engineering-yellow)
![Ruby](https://img.shields.io/badge/Ruby-3.3-red)
![Tests](https://img.shields.io/badge/tests-Minitest-red)
![Validate](https://github.com/henriqueamotta/copilot-modes-rails/actions/workflows/validate.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 🎯 Finalidade

Este repositório empacota um copiloto técnico para **Ruby on Rails** como três **custom agents** do GitHub Copilot Chat - Ask, Plan e Agent - cada um com um nível diferente de autonomia:

- **Ask**, pra tirar dúvida e entender código sem risco de nada ser alterado.
- **Plan**, pra planejar mudanças maiores antes de sair codando.
- **Agent**, pra delegar a implementação de ponta a ponta.

A ideia central é que a restrição de cada modo não dependa só de instrução em texto ("não edite nada") - ela é **imposta pela própria ferramenta**, através da lista de `tools` disponível em cada agente. Ask e Plan literalmente não têm acesso a ferramentas de edição ou execução de comando; só o Agent tem.

---

## 🚀 Instalação

1. Copie a pasta [.github/agents/](.github/agents/) (e opcionalmente `.github/instructions/` e `.github/copilot-instructions.md`) para o seu projeto ou clone este repositório dentro dele.
2. Abra o Copilot Chat no VS Code e selecione o modo desejado (Ask, Plan ou Agent) no dropdown de agentes.
3. Se o seu projeto **não** for Ruby on Rails, ajuste [.github/instructions/stack.instructions.md](.github/instructions/stack.instructions.md) - como esse arquivo é referenciado pelos três modos, editar em um lugar só já propaga a mudança pra todos.

Não é necessário instalar nada além do VS Code com a extensão do GitHub Copilot Chat - os arquivos são só configuração declarativa (Markdown + YAML frontmatter).

---

## ⚙️ Como funciona

1. **Você seleciona um modo** no dropdown de agentes do Copilot Chat (Ask, Plan ou Agent).
2. **O Copilot Chat carrega o `.agent.md`** correspondente, que define no frontmatter YAML a `description`, o `name` e a lista de `tools` permitidas para aquele modo.
3. **O corpo do arquivo** traz a identidade, as regras do modo e o formato de resposta esperado e referencia dois arquivos compartilhados por todos os modos:
   - [.github/instructions/stack.instructions.md](.github/instructions/stack.instructions.md) — a stack de referência (Ruby on Rails + JS + PostgreSQL) e como se adaptar quando o projeto for outra stack;
   - [.github/instructions/persona.instructions.md](.github/instructions/persona.instructions.md) — o tom de voz usado nas respostas.
4. **Fora dos três modos**, [.github/copilot-instructions.md](.github/copilot-instructions.md) garante que a stack de referência também vale pra qualquer conversa padrão do Copilot Chat neste repositório, mesmo sem selecionar um modo customizado.
5. **No modo Plan**, ao final de um plano aprovado, existe um handoff pronto ("Implementar este plano") que passa o plano direto pro modo Agent, com `send: false` - você revisa antes de disparar a implementação.
6. **Uma suíte de testes** ([test/validate_repository_test.rb](test/validate_repository_test.rb)) roda em todo push e Pull Request via GitHub Actions, garantindo que essas garantias não se percam: frontmatter válido, Ask/Plan sem ferramentas de escrita, Agent com `edit`, links do README íntegros e ausência de conteúdo duplicado fora de `.github/instructions/`.

---

## 🎛️ Modos

| | Ask | Plan | Agent |
|---|---|---|---|
| **Edita arquivos?** | ❌ | ❌ | ✅ |
| **Executa comandos?** | ❌ | ❌ | ✅ |
| **Gera código completo?** | Só se pedido explicitamente | Só pseudocódigo/assinaturas | Sim |
| **Perguntas de esclarecimento (máx.)*** | 2 | 3 | Minimiza, sem limite fixo |
| **Saída principal** | Diagnóstico/orientação curta | Plano estruturado revisável | Implementação + testes |
| **Arquivo** | [ask.agent.md](.github/agents/ask.agent.md) | [plan.agent.md](.github/agents/plan.agent.md) | [agent.agent.md](.github/agents/agent.agent.md) |

<sub>* Quantas perguntas o próprio Copiloto pode fazer pra você antes de seguir com suposições declaradas — não um limite sobre o que você pode perguntar a ele.</sub>

### ❓ Ask
Pra fazer perguntas e entender coisas, **sem alterar o código**. Pergunte sobre um arquivo específico, um erro, uma função, uma stack trace ou conceitos gerais - o Copiloto lê o contexto do projeto e responde como um "mentor técnico", explicando o que está acontecendo e por quê.

📄 **Prompt:** [prompts/prompt-ask.md](prompts/prompt-ask.md) · 🤖 **Custom agent:** [.github/agents/ask.agent.md](.github/agents/ask.agent.md)

### 📝 Plan
Pra planejar mudanças maiores antes de sair codando: divide o problema em etapas, explica o que vai fazer e só depois executa. Útil pra features grandes ou quando você quer validar a abordagem antes de mexer no código.

📄 **Prompt:** [prompts/prompt-plan.md](prompts/prompt-plan.md) · 🤖 **Custom agent:** [.github/agents/plan.agent.md](.github/agents/plan.agent.md)

### 🤖 Agent
O modo mais autônomo: navega pelo projeto, cria e modifica arquivos, mantém contexto entre passos, como um dev júnior trabalhando com você. Você dá um objetivo (ex.: "implemente login com Devise") e ele decide o que precisa ser feito em vários arquivos pra chegar lá.

📄 **Prompt:** [prompts/prompt-agent.md](prompts/prompt-agent.md) · 🤖 **Custom agent:** [.github/agents/agent.agent.md](.github/agents/agent.agent.md)

---

## 🗂️ Estrutura do repositório

```
.github/
  agents/                  # os três custom agents (o que o Copilot Chat carrega)
  instructions/             # STACK e PERSONALIDADE compartilhados entre os modos
  copilot-instructions.md   # aplicado a toda conversa do Copilot neste repo
  workflows/validate.yml    # roda a suíte de testes a cada push/PR
prompts/                    # versão legível dos três prompts (mesmo conteúdo, fora do formato de agent)
test/                       # suíte Minitest que valida as invariantes acima
```

---

## 🧠 Resumo mental rápido
- **Ask** → entender
- **Plan** → planejar antes de agir
- **Agent** → executar tarefas grandes sozinho

---

## ⚖️ Licença

[MIT](LICENSE)
