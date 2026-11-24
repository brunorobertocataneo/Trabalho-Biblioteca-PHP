# Guia para apresentar BibliotecaORM — Programação II

**Apresentação curta:** O BibliotecaORM é um mini-ORM em PHP e MySQL, estruturado pelo padrão Data Mapper. Entidades representam dados e validações sem SQL. Uma interface estabelece contrato; uma classe abstrata compartilha CRUD; repositórios especializados executam o mapeamento usando PDO.

## Demonstração

Abra `INICIAR_BIBLIOTECAORM.cmd` no Windows e informe a senha do MySQL localmente. O programa prepara os bancos, executa 5 testes de domínio e 13 integrados e imprime sete evidências:

1. Insere Livro e dois Autores em transação, exibindo IDs.
2. Busca Livro por ID e reconstrói o objeto.
3. Altera título e recupera o novo valor.
4. Reconstrói coleção de dois Autores por tabela N:N.
5. Usa `ConsultaPolimorfica::buscar()` com ambos os repositórios.
6. Provoca falha de FK e comprova `rollBack()`.
7. Exclui livro temporário e demonstra FK que bloqueia excluir autor vinculado.

## Perguntas e respostas

**Por que é ORM e não só PDO?** Porque as funções `extrair()` e `hidratar()` fazem o mapeamento entre objetos e registros.

**Onde há herança?** Nas subclasses `LivroRepository` e `AutorRepository`, derivadas de `AbstractRepository`.

**Como funciona o polimorfismo?** `ConsultaPolimorfica` recebe `RepositoryInterface` e funciona com diferentes implementações.

**INSERT ou UPDATE?** `AbstractRepository::salvar()` usa INSERT quando o ID é null e UPDATE quando já há ID.

**Por que dois bancos?** A demonstração mantém registros, enquanto os testes integrados usam `biblioteca_orm_teste` com rollback.

**Como evita SQL injection?** Usa `prepare()`/`execute()` para os valores e não recebe nomes arbitrários de tabela/coluna.

**Por que uma tabela N:N?** Um livro pode ter vários autores, e um autor pode participar de vários livros; a PK composta evita vínculos repetidos.

**Limitações?** Sem lazy loading, migrations, identity map, batch loading ou controle de concorrência.
