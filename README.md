# 🧩 Modos do Copiloto (Ask, Plan, Agent)

![IA](https://img.shields.io/badge/IA-Assistente%20Inteligente-blue)
![Prompt](https://img.shields.io/badge/Prompt-engineering-yellow)

O Copiloto oferece diferentes **modos de interação** para você escolher como quer trabalhar: para **tirar dúvidas sem mexer no código**, **planejar mudanças maiores** ou **delegar tarefas mais complexas** com um modo mais autônomo. A ideia é simples: você seleciona o modo que melhor combina com seu objetivo no momento e ganha velocidade com mais controle.

---

## 🚀 Como usar

Os três modos estão prontos como **custom agents** do GitHub Copilot Chat no VS Code, em [.github/agents/](.github/agents/):

1. Copie a pasta `.github/agents/` para o seu projeto (ou clone este repositório dentro dele).
2. Abra o Copilot Chat no VS Code e selecione o modo desejado (Ask, Plan ou Agent) no dropdown de agentes.
3. Ajuste a seção `STACK (EDITÁVEL)` de cada arquivo `.agent.md` se seu projeto não for Ruby on Rails.

No Ask e no Plan, a restrição de edição não depende só da instrução do prompt — o frontmatter (`tools:`) restringe as ferramentas disponíveis a leitura/busca, então esses modos **não têm acesso** a ferramentas de edição ou execução de comandos. O Plan também tem um handoff pronto ("Implementar este plano") que passa o plano aprovado direto para o modo Agent.

---

## ❓ Ask
O modo **Ask** é para fazer perguntas e entender coisas, **sem alterar seu código**. Você pode perguntar sobre um arquivo específico, um erro, uma função, uma stack trace ou até conceitos gerais.

O Copiloto lê o contexto do projeto (arquivos abertos, seleção, etc.) e responde como um **“mentor técnico”**, explicando o que está acontecendo e por quê. **Ele não modifica nada** — só analisa e explica.

📄 **Prompt:** [prompts/prompt-ask.md](prompts/prompt-ask.md) · 🤖 **Custom agent:** [.github/agents/ask.agent.md](.github/agents/ask.agent.md)

---

## 🧭 Plan
Quando você pede algo mais complexo, o Copiloto pode entrar em um modo de **planejamento**, onde ele **pensa e descreve os passos antes de sair codando**.

Ele:
- divide o problema em etapas
- explica o que vai fazer
- só depois executa

Isso é muito útil para **mudanças grandes**, **novas features** ou quando você quer **validar a abordagem** antes de mexer no código.

📄 **Prompt:** [prompts/prompt-plan.md](prompts/prompt-plan.md) · 🤖 **Custom agent:** [.github/agents/plan.agent.md](.github/agents/plan.agent.md)

---

## 🤖 Agent
O **Agent** é o modo mais “autônomo”. Ele pode **navegar pelo projeto**, **criar arquivos**, **modificar múltiplos pontos** e **manter contexto entre passos**, como se fosse um dev júnior trabalhando com você.

Você dá um objetivo (ex.: “implemente login com Devise”) e ele decide o que precisa ser feito em vários arquivos para chegar lá.

📄 **Prompt:** [prompts/prompt-agent.md](prompts/prompt-agent.md) · 🤖 **Custom agent:** [.github/agents/agent.agent.md](.github/agents/agent.agent.md)

---

## 🧠 Resumo mental rápido
- **Ask** → entender  
- **Plan** → planejar antes de agir  
- **Agent** → executar tarefas grandes sozinho  
