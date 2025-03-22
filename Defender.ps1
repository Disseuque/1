# Define a política de execução para Bypass
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Verifica se o script está sendo executado como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Se não estiver, abre uma nova instância do PowerShell como administrador e executa o script
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    return
}

# Função para verificar se o Windows Defender está desativado
function VerificarDefenderDesativado {
    try {
        $status = Get-MpComputerStatus
        return $status.AntispywareEnabled -eq $false -and $status.AntivirusEnabled -eq $false
    } catch [System.Management.Automation.MethodInvocationException] {
        if ($_.Exception.HResult -eq -2147023834) {
            Write-Host "Erro ao verificar o status do Windows Defender: O Windows Defender está desativado ou um antivírus de terceiros está em execução."
            return $true
        } else {
            Write-Host "Erro ao verificar o status do Windows Defender: $_"
            return $true
        }
    } catch {
        Write-Host "Erro ao verificar o status do Windows Defender: $_"
        return $true
    }
}

# Cumprimenta o usuário
Write-Host "============================================="
Write-Host "      Bem-vindo ao Script de Configuração      "
Write-Host "============================================="
Write-Host "Oi Disseuque, bom te ver outra vez hoje."
Write-Host "Por favor, escolha uma das opções abaixo:"
Write-Host "1 - Ativar o Modo Ninja"
Write-Host "2 - Ativar o Modo Super Ninja"
Write-Host "3 - Ativar o Modo Mega Ninja"
Write-Host "============================================="

# Lê a escolha do usuário
$choice = Read-Host "Digite o número da sua escolha"

# Verifica se o Windows Defender já está desativado
if (VerificarDefenderDesativado) {
    Write-Host "O Modo Ninja já está ativado ou um antivírus de terceiros está em execução."
    Read-Host "Pressione Enter para sair..."
    return
}

# Executa a ação correspondente à escolha do usuário
switch ($choice) {
    1 {
        Write-Host "Ativando o Modo Ninja..."
        try {
            Set-MpPreference -DisableRealtimeMonitoring $true
            Write-Host "Modo Ninja ativado."
        } catch {
            Write-Host "Erro ao ativar o Modo Ninja. Pode ser que um antivírus de terceiros já esteja em execução."
            Write-Host "Detalhes do erro: $_"
        }
    }
    2 {
        Write-Host "Ativando o Modo Super Ninja..."
        try {
            Set-MpPreference -DisableRealtimeMonitoring $true
            Set-MpPreference -DisableBehaviorMonitoring $true
            Set-MpPreference -DisableBlockAtFirstSeen $true
            Set-MpPreference -DisableIOAVProtection $true
            Set-MpPreference -DisablePrivacyMode $true
            Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
            Set-MpPreference -DisableArchiveScanning $true
            Set-MpPreference -DisableIntrusionPreventionSystem $true
            Set-MpPreference -DisableScriptScanning $true
            Set-MpPreference -SubmitSamplesConsent 2
            Write-Host "Modo Super Ninja ativado."
        } catch {
            Write-Host "Erro ao ativar o Modo Super Ninja. Pode ser que um antivírus de terceiros já esteja em execução."
            Write-Host "Detalhes do erro: $_"
        }
    }
    3 {
        Write-Host "Ativando o Modo Mega Ninja..."
        try {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
            Write-Host "Modo Mega Ninja ativado."
        } catch {
            Write-Host "Erro ao ativar o Modo Mega Ninja. Pode ser que um antivírus de terceiros já esteja em execução."
            Write-Host "Detalhes do erro: $_"
        }
    }
    default {
        Write-Host "Opção inválida. Por favor, execute o script novamente e escolha uma opção válida."
    }
}

# Pausa para permitir que o usuário veja as mensagens antes de fechar
Read-Host "Pressione Enter para sair..."