# credito_veiculos
Estudo de mercado: SQL e Power BI para dados históricos públicos de crédito a veículos 

Esta análise trata de créditos oferecidos por instituições financeiras a pessoas físicas e jurídicas, na aquisição e no arrendamento de veículos. A ideia deste estudo é oferecer um parâmetro do mercado na transição do período pandêmico para o momento atual. Por isso foram utilizados dados de março de 2020 (sobre a frota nacional, com segmentação por tipo de veículo e por estado), além de informações sobre o crédito ofertado vs inadimplência, e custos operacionais das referidas instituições financeiras num cenário macro (em que não há identificação de clientes individualmente, por exemplo). São dados históricos. Os dashboards permitem entender o cenário para ajudar no posicionamento da empresa. Foram pensados dois dashboards, para oferecer opções ao cliente - um que foca em sintetizar informações centrais de concessão de crédito, e outro que trata também do custo médio das operações. Seu uso é recomendável para organizações já existentes, servindo de comparativo com o mercado vs dados internos (que não serão tratados nesse repositório por uma questão de confidencialidade e respeito à LGPD). 

O tratamento inicial dos dados se deu com uso de Microsoft SQL Server (MSSQLS) e, posteriormente, Power BI para visualização com gráficos. Na parte de visualização não houve necessidade de criar um fundo personalizado, pois a prioridade era mostrar os dados em um trabalho que iria compor outros materiais a organização - como relatórios e planos de longo prazo. 

Foram utilizados dados do Banco Central do Brasil e Renavam, extraídos de portal aberto de dados públicos do governo. 
Este estudo respeita a LGPD e os cânones da Governança de Dados.
