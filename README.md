# AGRA — Gestão de Recebimento de Mercadorias

Conferência de mercadorias por XML da NF-e e leitor de código de barras. Cada empresa pode criar um cadastro próprio com nome, e-mail e senha; CNPJ e telefone são opcionais. Não é preciso ter conta Google ou ChatGPT. O acesso anterior pelo ChatGPT continua disponível. Notas e leituras ficam separadas por empresa no D1, sem rotina de exclusão automática.

## Implantação

O arquivo `.openai/hosting.json` declara o banco D1 `DB`. As migrações em `drizzle/` são aplicadas no fluxo de publicação do Sites. O valor mensal exibido é R$ 49,99 por loja. A cobrança recorrente ainda não está integrada; o acesso atual continua no piloto gratuito. A consulta ao Linx Big Farma pelo número da nota também depende de integração autorizada. A recuperação de senha por e-mail ainda não está implementada.

## Gestão do proprietário

A aba Gestão é apresentada somente à conta proprietária e as APIs verificam a identidade recebida do login ChatGPT. Exibe empresas, notas, atividade e registros financeiros lançados manualmente. O proprietário pode bloquear e desbloquear o acesso de uma empresa ou excluir permanentemente o cadastro e todos os dados associados após confirmação pelo nome. Também pode selecionar uma plataforma de pagamentos para a futura integração; essa escolha ainda não conecta o provedor nem habilita cobrança ou confirmação automática. Não há bloqueio automático por vencimento.

## Teste do Mercado Pago

Na aba Gestão, o proprietário configura o Access Token da aplicação de teste, o User ID do Vendedor de teste e, após cadastrar a URL de Webhooks de teste, a assinatura secreta de teste. Os segredos são criptografados com AES-GCM no D1 usando a chave de ambiente `AGRA_CREDENTIAL_KEY` (64 caracteres hexadecimais), criada separadamente como segredo do Site. Essa chave nunca fica no código ou no banco. A conta de teste é validada contra `/users/me` antes da criação de assinatura. O endpoint de notificações é `https://sistema.nandoagra.shop/api/mp-test/webhook` e o tópico necessário é `subscription_preapproval` em Planos e assinaturas. As assinaturas de teste de R$ 49,99/mês não modificam cobertura nem registram recebimentos. A cobrança real continua desligada.
