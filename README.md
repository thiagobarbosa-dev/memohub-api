# MemoHub - API

Este é um projeto de API inspirado no Microsoft OneNote, um aplicativo de bloco de anotações que permite aos usuários organizar suas ideias em cadernos, seções e páginas.

## 🚀 Começando

Para começar a usar a API MemoHub, siga as instruções abaixo:

### Pré-requisitos

Para utilizar esta API, você precisará ter instalado:

- Ruby 3.2.3
- Rails 7.0.8.1
- Bundler
- PostgreSQL >= 14

### Instalação

Siga estes passos para configurar a API localmente:

1. Clone o repositório: `git clone https://github.com/thiagobarbosa-dev/memohub-api.git`
2. Instale as dependências: `bundle install`
3. Crie o banco de dados, execute as migrações do banco de dados: `rails db:create db:migrate db:seed`

### Uso

Para começar a usar a API MemoHub:

1. Inicie o servidor local: `rails s -b 0.0.0.0`
2. Acesse a API em suas rotas definidas, por exemplo: `http://localhost:3000/api/v1/login`
3. Use os dados do login criado através do seed:
  ````
  {
    "login": "admin",
    "password": "123456"
  }
  ````

## 🤝 Contribuindo

Se você quiser contribuir com este projeto, por favor, siga estas instruções:

- Faça um fork do projeto
- Crie uma nova branch: `git checkout -b feature/nova-feature`
- Faça commit das suas alterações: `git commit -am 'Adicione uma nova feature'`
- Faça push para a branch: `git push origin feature/nova-feature`
- Envie um pull request

## 📬 Contato

Para dúvidas, sugestões ou suporte, entre em contato pelo email: thiagobarbosa.dev@icloud.com.
