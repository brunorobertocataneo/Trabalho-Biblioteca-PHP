@echo off
setlocal
cd /d "%~dp0"
if errorlevel 1 (
    echo [ERRO] Nao foi possivel abrir a pasta do projeto.
    pause
    exit /b 1
)
where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo [ERRO] O Windows PowerShell nao foi encontrado.
    pause
    exit /b 1
)
set "BIBLIOTECA_CMD=%~f0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$texto = [IO.File]::ReadAllText($env:BIBLIOTECA_CMD, [Text.Encoding]::UTF8); $marcador = [char]35 + ' PS_BIBLIOTECAORM'; $indice = $texto.LastIndexOf($marcador); if ($indice -lt 0) { throw 'Script interno nao localizado.' }; & ([ScriptBlock]::Create($texto.Substring($indice + $marcador.Length)))"
set "CODIGO=%ERRORLEVEL%"
set "BIBLIOTECA_CMD="
exit /b %CODIGO%

# PS_BIBLIOTECAORM
$ErrorActionPreference = 'Stop'
$codigo = 0
$ponteiro = [IntPtr]::Zero

try {
    $projeto = Split-Path -Parent $env:BIBLIOTECA_CMD
    Set-Location -LiteralPath $projeto
    Write-Host 'BibliotecaORM - Avaliacao Pratica da Aula 11' -ForegroundColor Cyan

    $php = (Get-Command php.exe -CommandType Application -ErrorAction Stop).Source
    $opcoes = @()
    $modulos = & $php -m
    if ($LASTEXITCODE -ne 0) { throw 'Nao foi possivel verificar os modulos do PHP.' }

    if (-not ($modulos | Where-Object { $_.Trim() -eq 'pdo_mysql' })) {
        $diretorioExt = Join-Path (Split-Path -Parent $php) 'ext'
        if (-not (Test-Path -LiteralPath (Join-Path $diretorioExt 'php_pdo_mysql.dll'))) {
            throw 'Driver pdo_mysql indisponivel. Confira a instalacao do PHP e sua pasta ext.'
        }
        $opcoes = @('-d', "extension_dir=$diretorioExt", '-d', 'extension=pdo_mysql')
        $modulos = & $php @opcoes -m
        if ($LASTEXITCODE -ne 0 -or -not ($modulos | Where-Object { $_.Trim() -eq 'pdo_mysql' })) {
            throw 'Falha ao carregar a extensao pdo_mysql.'
        }
    }

    $usuario = Read-Host 'Usuario MySQL (Enter para root)'
    if ([string]::IsNullOrWhiteSpace($usuario)) { $usuario = 'root' }
    Write-Host 'Digite a senha do MySQL. Ela nao sera exibida nem gravada.' -ForegroundColor DarkGray
    $senhaSegura = Read-Host 'Senha MySQL' -AsSecureString
    $ponteiro = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($senhaSegura)
    $env:DB_PASS = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ponteiro)
    $env:DB_USER = $usuario
    $env:DB_HOST = '127.0.0.1'

    $pastaEvidencias = Join-Path $projeto 'evidencias'
    New-Item -ItemType Directory -Path $pastaEvidencias -Force | Out-Null
    $arquivoEvidencia = Join-Path $pastaEvidencias ('execucao-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.txt')
    Set-Content -LiteralPath $arquivoEvidencia -Value ('BibliotecaORM | ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')) -Encoding UTF8

    function Executar([string]$etapa, [string]$arquivo, [string]$banco) {
        $env:DB_NAME = $banco
        Write-Host ("`n==== " + $etapa + " ====") -ForegroundColor Cyan
        Add-Content -LiteralPath $arquivoEvidencia -Value ("`n==== " + $etapa + " ====") -Encoding UTF8
        $saida = & $php @opcoes $arquivo 2>&1
        $status = $LASTEXITCODE
        foreach ($linha in $saida) {
            $texto = [string]$linha
            Write-Host $texto
            Add-Content -LiteralPath $arquivoEvidencia -Value $texto -Encoding UTF8
        }
        if ($status -ne 0) { throw "Falha na etapa: $etapa (codigo $status)." }
    }

    Executar 'Preparacao dos bancos' '.\preparar_bancos.php' 'biblioteca_orm'
    Executar '5 testes de dominio' '.\tests\domain.php' 'biblioteca_orm_teste'
    Executar '13 testes de integracao' '.\tests\smoke.php' 'biblioteca_orm_teste'
    Executar '7 evidencias da demonstracao' '.\demo.php' 'biblioteca_orm'

    Write-Host "`n[SUCESSO] Todas as etapas foram executadas." -ForegroundColor Green
    Write-Host "Log salvo em: $arquivoEvidencia" -ForegroundColor Green
} catch {
    $codigo = 1
    Write-Host ("[FALHA] " + $_.Exception.Message) -ForegroundColor Red
} finally {
    if ($ponteiro -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ponteiro)
    }
    Remove-Item Env:\DB_PASS, Env:\DB_USER, Env:\DB_NAME, Env:\DB_HOST -ErrorAction SilentlyContinue
    [void](Read-Host 'Pressione Enter para fechar')
}
exit $codigo
