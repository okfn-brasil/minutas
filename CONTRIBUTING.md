## Ambiente de Desenvolvimento Local

### Requisitos

- Ruby 3.0.2
- Bundler 2.3.20
- Node.js 16
- Yarn

### Instalação

Este guia usa Ubuntu 24.04 como exemplo, mas pode ser adaptado para outras distribuições Linux.

1. Instale o rbenv seguindo as [instruções oficiais](https://github.com/rbenv/rbenv?tab=readme-ov-file#basic-git-checkout) para gerenciar versões do Ruby.

2. Use o rbenv para instalar a versão correta do Ruby:

   ```bash
   rbenv install 3.0.2
   rbenv global 3.0.2
   ```

3. Instale a versão correta do Bundler:

   ```bash
   gem install bundler -v 2.3.20
   ```

4. Instale o rbenv-vars para gerenciamento de variáveis de ambiente:

   ```bash
   git clone https://github.com/rbenv/rbenv-vars.git "$(rbenv root)"/plugins/rbenv-vars
   ```

5. Instale o nvm para gerenciar versões do Node.js seguindo as [instruções oficiais](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating).

6. Instale o Node.js na versão 16:

   ```bash
   nvm install 16.20
   ```

7. Instale o Yarn:

   ```bash
   npm install --global yarn
   ```

8. Instale o PostgreSQL:

   ```bash
   sudo apt-get install postgresql
   ```

9. Configure o PostgreSQL:

   ```bash
   sudo -u postgres psql
   create user decidimdev with superuser password 'minhasenha';
   ```

   Substitua 'decidimdev' e 'minhasenha' conforme necessário.

10. Clone o repositório:

    ```bash
    git clone https://github.com/okfn-brasil/minutas.git
    cd minutas
    ```

11. Crie o arquivo `.rbenv-vars` com o seguinte conteúdo:

    ```
    DATABASE_HOST=localhost
    DATABASE_USERNAME=decidimdev
    DATABASE_PASSWORD=minhasenha
    ```

12. Instale as gems necessárias:

    ```bash
    bundle
    ```

13. Crie o banco de dados e execute as migrações:

    ```bash
    bin/rails db:create
    bin/rails db:migrate
    ```

14. (Opcional) Alimente o banco de dados:

    ```bash
    bin/rails db:seed
    ```