# Relatório técnico — BibliotecaORM (versão em Markdown)

**UNOESC — Ciência da Computação — Programação II**  
**Aluno:** Bruno Roberto Cataneo  
**Professor:** Leandro Otavio Cordova Vieira  
**Atividade:** Desenvolvimento de ORM próprio com PHP puro e MySQL 8

> Esta é uma versão textual complementar ao relatório PDF de 3 páginas preparado para entrega no portal. O professor solicita o **PDF**, que deve ser anexado separadamente.

## 1. Problema e proposta

A biblioteca da universidade precisa cadastrar, recuperar e relacionar livros e autores. A solução implementa um mini-ORM próprio usando o padrão Data Mapper, sem frameworks nem ORMs de terceiros. As entidades mantêm seus dados e validações, enquanto os repositórios fazem a persistência com PDO e MySQL.

## 2. Decisões arquiteturais

- **Encapsulamento:** `Livro` e `Autor` contêm atributos privados e validações para títulos, nomes e identidades.
- **Interface:** `RepositoryInterface` define `buscar()`, `listar()`, `salvar()` e `excluir()`.
- **Herança e abstração:** `AbstractRepository` implementa o CRUD comum; as duas subclasses selecionam tabelas, colunas, extração e hidratação.
- **Polimorfismo:** `ConsultaPolimorfica` recebe a interface e trabalha com ambos os repositórios.
- **Associação N:N:** `livros_autores` usa PK composta e duas FKs; `buscarComAutores()` reconstrói a coleção.

O diagrama editável encontra-se em [diagramas/diagrama_classes.drawio](../diagramas/diagrama_classes.drawio); o README também exibe UML em Mermaid.

## 3. Segurança e integridade

O banco tem tabelas `livros`, `autores`, `livros_autores` e `exemplares`. Prepared statements com parâmetros protegem os valores e os nomes de tabelas/colunas não vêm de entrada arbitrária. Chaves estrangeiras impedem relacionamentos incorretos. Operações de livro e vínculos usam `beginTransaction()`, `commit()` e `rollBack()`.

## 4. Evidências exigidas e demonstradas no código

| Evidência | Local de implementação |
|---|---|
| 1. Cadastro de Livro e Autores com IDs | `demo.php` — [1] |
| 2. Busca por ID e hidratação | `demo.php` — [2/4] |
| 3. UPDATE e nova consulta | `demo.php` — [3] |
| 4. Dois autores e recuperação N:N | `demo.php` — [2/4] |
| 5. Polimorfismo com mesmo contrato | `demo.php` — [5] |
| 6. Falha de FK seguida de rollback | `demo.php` — [6] |
| 7. Exclusão e restrição de FK | `demo.php` — [7] |

As chamadas são reproduzidas pelo iniciador `INICIAR_BIBLIOTECAORM.cmd`.

## 5. Verificações e evidências

Cinco testes de domínio foram executados e aprovados. Os arquivos PHP foram verificados quanto à sintaxe. Os 13 testes de integração estão implementados, mas **não há comprovação aqui de execução autenticada no MySQL**. O iniciador grava logs locais que devem ser revisados e anexados ao portal após sua execução verdadeira.

## 6. Limitações

O mini-ORM usa chave primária `id` inteira e não possui migrations, query builder genérico, reflection, identity map, lazy loading, carregamento em lote, controle de concorrência ou exclusão em cascata automática. Essas escolhas são compatíveis com o escopo didático do exercício.

## 7. Entrega

Entregar link do repositório Git, relatório técnico em **PDF de 2 a 4 páginas** (separadamente), diagrama UML, README, `sql/schema.sql`, evidências de execução real e explicação das decisões. Código com funções de teste não deve ser apresentado como prova de sucesso sem os logs correspondentes.
