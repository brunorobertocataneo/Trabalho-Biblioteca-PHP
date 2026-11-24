# BibliotecaORM

Trabalho desenvolvido para a disciplina de Programação II, do curso de Ciência da Computação da UNOESC Videira.

Professor: Leandro Otavio Cordova Vieira.

## Sobre o projeto

O BibliotecaORM é um projeto em PHP que faz o cadastro e a consulta de livros e autores usando MySQL. A ideia da atividade foi criar um mini-ORM próprio, sem utilizar frameworks prontos.

Separei as classes dos livros e autores das classes que fazem as operações no banco. Assim, os repositórios ficam responsáveis por salvar, buscar, listar, atualizar e excluir os registros.

O projeto também trabalha com um livro que pode ter vários autores, além de usar interface, herança, polimorfismo e transações com PDO.

Não fiz uma tela para navegador porque a atividade é voltada ao funcionamento do ORM. A demonstração é feita pelo terminal.

## O que precisa para executar

- PHP 8.2 ou superior, com a extensão `pdo_mysql`;
- MySQL 8 instalado e iniciado;
- No Windows, PowerShell para utilizar o arquivo de inicialização.

## Como executar

1. Baixe o projeto e extraia os arquivos.
2. Confira se o PHP e o MySQL estão instalados.
3. Abra o arquivo `INICIAR_BIBLIOTECAORM.cmd` com dois cliques.
4. Informe o usuário e a senha do MySQL na janela que abrir.

O usuário precisa ter permissão para criar os bancos e as tabelas na primeira execução. A senha é solicitada no próprio computador e não fica salva no projeto.

O arquivo de inicialização prepara os bancos `biblioteca_orm` e `biblioteca_orm_teste`, executa os testes e depois roda o `demo.php`, mostrando as operações do sistema. A saída fica registrada na pasta `evidencias` após a execução.

Se preferir usar o terminal manualmente, primeiro configure `DB_HOST`, `DB_USER`, `DB_PASS` e `DB_NAME` no ambiente. Depois, execute os arquivos nesta ordem:

```powershell
php preparar_bancos.php
php tests/domain.php
$env:DB_NAME = 'biblioteca_orm_teste'
php tests/smoke.php
$env:DB_NAME = 'biblioteca_orm'
php demo.php
```

## Organização dos arquivos

- `src/Domain`: classes `Livro` e `Autor`, com os dados e validações.
- `src/Infrastructure`: conexão com o banco, interface e repositórios.
- `src/Application`: exemplo de consulta usando polimorfismo.
- `sql`: scripts de criação dos bancos.
- `tests`: testes das classes e das operações com MySQL.
- `demo.php`: demonstra cadastro, consulta, listagem, atualização, associação de autores, exclusão e rollback.
- `autoload.php`: carrega as classes do projeto.

## Testes

O projeto possui 5 testes das classes e 13 testes de integração com MySQL. Os testes das classes já foram executados com sucesso. Os de integração ainda precisam ter a execução confirmada em um MySQL configurado; o código dos testes estar pronto não significa que eles passaram.

O arquivo `demo.php` também mostra o que acontece quando tentamos relacionar um livro com um autor inexistente. Nesse caso, a chave estrangeira impede a operação e a transação é desfeita.

## Relatório e diagrama

O [relatório técnico em PDF](relatorio/Relatorio_Tecnico_BibliotecaORM_UNOESC.pdf) contém a explicação do desenvolvimento, o diagrama de classes, os testes e as limitações do projeto.

O [diagrama editável](diagramas/diagrama_classes.drawio) pode ser aberto no diagrams.net.

O projeto é uma implementação simples para estudo. Não possui todos os recursos de um ORM completo, mas permite demonstrar os conceitos pedidos na atividade.
