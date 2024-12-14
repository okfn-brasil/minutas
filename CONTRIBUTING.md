# Como contribuir?

### Guia para build local e contribuição ao repositório

Ambiente de desenvolvimento Local
Requisitos
* ruby 3.0.2
* bundler 2.3.20
* node 16
* yarn

## Instalação
Em nosso exemplo estamos usando Ubuntu 24.04, mas esse guia pode se adaptar a outras distribuições Linux sem maiores problemas.
Instale o rbenv seguindos as instruções da documentação oficial [https://github.com/rbenv/rbenv?tab=readme-ov-file#basic-git-checkout] para instalar e gerenciar versões do ruby.

Use o rbenv para instalar a versão correta do ruby
`rbenv install 3.0.2`
`rbenv global 3.0.2`

Instale a versão correta do bundler
`gem install bundler -v 2.3.20`

Instale o rbenv-vars para gerenciamento de variáveis de ambiente
`git clone https://github.com/rbenv/rbenv-vars.git "$(rbenv root)"/plugins/rbenv-vars`

Instale o nvm para instalar e gerenciar versões do NodeJS
https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

Instale o NodeJs na versão 16
`nvm install 16.20`

Instale o Yarn
        npm install --global yarn

Instale o Postgres
`sudo apt-get install postgresql`
Acesse o console do postgres
`sudo -u postgres psql`
Crie um usuário e senha (subistitua devdecidim pelo usuário de sua escolha e a senha 'minhasenha' por uma outra de sua escolha)
`create user decidimdev with superuser password 'minhasenha';`


Clone o repositório
`git clone https://github.com/okfn-brasil/minutas.git`

Acesse o diretório
`cd minutas`

Crie o arquivo .rbenv-vars com o seguinte conteúdo
DATABASE_HOST=localhost
DATABASE_USERNAME=decidimdev
DATABASE_PASSWORD=minhasenha

Instale as gems necessárias (esse processo pode demorar alguns minutos)
bundle

Crie o Banco de dados
bin/rails db:create

Rode as migrations
bin/rails db:migrate

Alimente o banco (opicional)
bin/rails db:seed