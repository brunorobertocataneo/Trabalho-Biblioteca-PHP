# Checklist — Avaliação Prática BibliotecaORM

| Requisito | Implementação | Status |
|---|---|---|
| R1 — Banco, PK e FKs | `sql/schema.sql` | Implementado |
| R2 — Encapsulamento e validação | `src/Domain` | Implementado; testes de domínio aprovados |
| R3 — RepositoryInterface | `src/Infrastructure/RepositoryInterface.php` | Implementado |
| R4 — Herança e abstração | `AbstractRepository` + repositórios concretos | Implementado |
| R5 — Polimorfismo | `ConsultaPolimorfica.php`, `demo.php` | Implementado |
| R6 — CRUD e listar | Repositórios e `demo.php` | Implementado; confirmar no MySQL |
| R7 — Hidratação | `LivroRepository` e `AutorRepository` | Implementado; confirmar no MySQL |
| R8 — N:N com dois autores | `buscarComAutores()` | Implementado; confirmar no MySQL |
| R9 — Segurança e rollback | PDO, FK, transações e `demo.php` | Implementado; confirmar no MySQL |
| R10 — Organização e testes | `README`, `sql/`, `tests/` | Implementado |
| Evidências 1 a 7 | `demo.php` | Gerar log de execução real |
| UML e relatório | `diagramas/`; PDF para anexar no portal | Diagrama incluído; PDF externo ao GitHub |

**Nota:** não afirmar que os 13 testes integrados passaram sem registrar execução autenticada no MySQL.
