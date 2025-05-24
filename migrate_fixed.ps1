# SCRIPT DE MIGRACIÓN ULTRA-SIMPLE - CORAZONES PELUDOS
# Sin funciones complejas, solo comandos básicos

Write-Host "🚀 Iniciando migración..." -ForegroundColor Green

# Verificar directorio
if (!(Test-Path "html\index.html")) {
    Write-Host "❌ Error: No se encuentra html\index.html" -ForegroundColor Red
    pause
    exit
}

# Crear backup
Write-Host "📦 Creando backup..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item -Recurse "html" "html_backup_$timestamp"
Write-Host "✅ Backup creado" -ForegroundColor Green

# Crear estructura
Write-Host "📁 Creando estructura..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "corazones-peludos\assets\css" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\assets\js" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\assets\img" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\pages" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\api\config" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\api\auth" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\api\pets" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\api\adoption" | Out-Null
New-Item -ItemType Directory -Force -Path "corazones-peludos\api\users" | Out-Null

# Copiar CSS
Write-Host "📦 Copiando CSS..." -ForegroundColor Yellow
if (Test-Path "CSS\style.css") {
    Copy-Item "CSS\style.css" "corazones-peludos\assets\css\"
}

# Copiar JS
Write-Host "📦 Copiando JavaScript..." -ForegroundColor Yellow
if (Test-Path "JS\script.js") {
    Copy-Item "JS\script.js" "corazones-peludos\assets\js\"
}
if (Test-Path "JS\scripad.js") {
    Copy-Item "JS\scripad.js" "corazones-peludos\assets\js\"
}
if (Test-Path "JS\scriplogin.js") {
    Copy-Item "JS\scriplogin.js" "corazones-peludos\assets\js\"
}
if (Test-Path "JS\scriptEditarInfo.js") {
    Copy-Item "JS\scriptEditarInfo.js" "corazones-peludos\assets\js\"
}
if (Test-Path "JS\scriptRegister.js") {
    Copy-Item "JS\scriptRegister.js" "corazones-peludos\assets\js\"
}
if (Test-Path "JS\scriptVerificarSesion.js") {
    Copy-Item "JS\scriptVerificarSesion.js" "corazones-peludos\assets\js\"
}

# Copiar imágenes
Write-Host "📦 Copiando imágenes..." -ForegroundColor Yellow
if (Test-Path "img") {
    Copy-Item "img\*" "corazones-peludos\assets\img\" -Recurse
}

# Copiar HTML
Write-Host "📦 Copiando HTML..." -ForegroundColor Yellow
if (Test-Path "html\index.html") {
    Copy-Item "html\index.html" "corazones-peludos\pages\"
}
if (Test-Path "html\login.html") {
    Copy-Item "html\login.html" "corazones-peludos\pages\"
}
if (Test-Path "html\register.html") {
    Copy-Item "html\register.html" "corazones-peludos\pages\"
}
if (Test-Path "html\account.html") {
    Copy-Item "html\account.html" "corazones-peludos\pages\"
}
if (Test-Path "html\admin-dashboard.html") {
    Copy-Item "html\admin-dashboard.html" "corazones-peludos\pages\"
}
if (Test-Path "html\adopt.html") {
    Copy-Item "html\adopt.html" "corazones-peludos\pages\"
}
if (Test-Path "html\about.html") {
    Copy-Item "html\about.html" "corazones-peludos\pages\"
}
if (Test-Path "html\contact.html") {
    Copy-Item "html\contact.html" "corazones-peludos\pages\"
}
if (Test-Path "html\locate.html") {
    Copy-Item "html\locate.html" "corazones-peludos\pages\"
}
if (Test-Path "html\associates.html") {
    Copy-Item "html\associates.html" "corazones-peludos\pages\"
}
if (Test-Path "html\process.html") {
    Copy-Item "html\process.html" "corazones-peludos\pages\"
}
if (Test-Path "html\conditions.html") {
    Copy-Item "html\conditions.html" "corazones-peludos\pages\"
}
if (Test-Path "html\terms.html") {
    Copy-Item "html\terms.html" "corazones-peludos\pages\"
}

# Copiar PHP - Config
Write-Host "📦 Copiando PHP Config..." -ForegroundColor Yellow
if (Test-Path "html\conexion.php") {
    Copy-Item "html\conexion.php" "corazones-peludos\api\config\"
}

# Copiar PHP - Auth
Write-Host "📦 Copiando PHP Auth..." -ForegroundColor Yellow
if (Test-Path "html\login.php") {
    Copy-Item "html\login.php" "corazones-peludos\api\auth\"
}
if (Test-Path "html\logout.php") {
    Copy-Item "html\logout.php" "corazones-peludos\api\auth\"
}
if (Test-Path "html\registro_usuario.php") {
    Copy-Item "html\registro_usuario.php" "corazones-peludos\api\auth\"
}

# Copiar PHP - Pets
Write-Host "📦 Copiando PHP Pets..." -ForegroundColor Yellow
if (Test-Path "html\add_pet.php") {
    Copy-Item "html\add_pet.php" "corazones-peludos\api\pets\"
}
if (Test-Path "html\get_pets.php") {
    Copy-Item "html\get_pets.php" "corazones-peludos\api\pets\"
}
if (Test-Path "html\get_pet.php") {
    Copy-Item "html\get_pet.php" "corazones-peludos\api\pets\"
}
if (Test-Path "html\update_pet.php") {
    Copy-Item "html\update_pet.php" "corazones-peludos\api\pets\"
}
if (Test-Path "html\delete_pet.php") {
    Copy-Item "html\delete_pet.php" "corazones-peludos\api\pets\"
}
if (Test-Path "html\update_pet_status.php") {
    Copy-Item "html\update_pet_status.php" "corazones-peludos\api\pets\"
}

# Copiar PHP - Adoption
Write-Host "📦 Copiando PHP Adoption..." -ForegroundColor Yellow
if (Test-Path "html\submit_adoption.php") {
    Copy-Item "html\submit_adoption.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\get_adoption_requests.php") {
    Copy-Item "html\get_adoption_requests.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\get_adoption_request.php") {
    Copy-Item "html\get_adoption_request.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\get_user_adoptions.php") {
    Copy-Item "html\get_user_adoptions.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\approve_request.php") {
    Copy-Item "html\approve_request.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\reject_request.php") {
    Copy-Item "html\reject_request.php" "corazones-peludos\api\adoption\"
}
if (Test-Path "html\delete_adoption_request.php") {
    Copy-Item "html\delete_adoption_request.php" "corazones-peludos\api\adoption\"
}

# Copiar PHP - Users
Write-Host "📦 Copiando PHP Users..." -ForegroundColor Yellow
if (Test-Path "html\get_user_info.php") {
    Copy-Item "html\get_user_info.php" "corazones-peludos\api\users\"
}
if (Test-Path "html\update_user.php") {
    Copy-Item "html\update_user.php" "corazones-peludos\api\users\"
}
if (Test-Path "html\check_adopter.php") {
    Copy-Item "html\check_adopter.php" "corazones-peludos\api\users\"
}
if (Test-Path "html\register_adopter.php") {
    Copy-Item "html\register_adopter.php" "corazones-peludos\api\users\"
}

Write-Host "✅ Archivos copiados" -ForegroundColor Green

# Actualizar rutas básicas - HTML
Write-Host "🔄 Actualizando rutas HTML..." -ForegroundColor Yellow

# Index.html
if (Test-Path "corazones-peludos\pages\index.html") {
    $content = Get-Content "corazones-peludos\pages\index.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="../JS/script.js"', 'src="../assets/js/script.js"')
    $content = $content.Replace('src="/JS/scriptVerificarSesion.js"', 'src="../assets/js/scriptVerificarSesion.js"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\index.html" $content -Encoding UTF8
}

# Login.html
if (Test-Path "corazones-peludos\pages\login.html") {
    $content = Get-Content "corazones-peludos\pages\login.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="../JS/scriplogin.js"', 'src="../assets/js/scriplogin.js"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\login.html" $content -Encoding UTF8
}

# Register.html
if (Test-Path "corazones-peludos\pages\register.html") {
    $content = Get-Content "corazones-peludos\pages\register.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="/JS/scriptRegister.js"', 'src="../assets/js/scriptRegister.js"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\register.html" $content -Encoding UTF8
}

# Account.html
if (Test-Path "corazones-peludos\pages\account.html") {
    $content = Get-Content "corazones-peludos\pages\account.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="../JS/script.js"', 'src="../assets/js/script.js"')
    $content = $content.Replace('src="/JS/scriptEditarInfo.js"', 'src="../assets/js/scriptEditarInfo.js"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\account.html" $content -Encoding UTF8
}

# Admin-dashboard.html
if (Test-Path "corazones-peludos\pages\admin-dashboard.html") {
    $content = Get-Content "corazones-peludos\pages\admin-dashboard.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="../JS/script.js"', 'src="../assets/js/script.js"')
    $content = $content.Replace('src="/JS/scriptEditarInfo.js"', 'src="../assets/js/scriptEditarInfo.js"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\admin-dashboard.html" $content -Encoding UTF8
}

# Adopt.html
if (Test-Path "corazones-peludos\pages\adopt.html") {
    $content = Get-Content "corazones-peludos\pages\adopt.html" -Raw
    $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
    $content = $content.Replace('src="../img/', 'src="../assets/img/')
    Set-Content "corazones-peludos\pages\adopt.html" $content -Encoding UTF8
}

# Resto de HTML con navegación Bootstrap
$otherHtmlFiles = @("about.html", "contact.html", "locate.html", "associates.html", "process.html", "conditions.html", "terms.html")
foreach ($htmlFile in $otherHtmlFiles) {
    if (Test-Path "corazones-peludos\pages\$htmlFile") {
        $content = Get-Content "corazones-peludos\pages\$htmlFile" -Raw
        $content = $content.Replace('href="../CSS/style.css"', 'href="../assets/css/style.css"')
        $content = $content.Replace('src="../JS/script.js"', 'src="../assets/js/script.js"')
        $content = $content.Replace('src="../img/', 'src="../assets/img/')
        Set-Content "corazones-peludos\pages\$htmlFile" $content -Encoding UTF8
    }
}

# Actualizar JavaScript
Write-Host "🔄 Actualizando rutas JavaScript..." -ForegroundColor Yellow

# scriplogin.js
if (Test-Path "corazones-peludos\assets\js\scriplogin.js") {
    $content = Get-Content "corazones-peludos\assets\js\scriplogin.js" -Raw
    $content = $content.Replace("fetch('login.php'", "fetch('../api/auth/login.php'")
    Set-Content "corazones-peludos\assets\js\scriplogin.js" $content -Encoding UTF8
}

# scriptRegister.js
if (Test-Path "corazones-peludos\assets\js\scriptRegister.js") {
    $content = Get-Content "corazones-peludos\assets\js\scriptRegister.js" -Raw
    $content = $content.Replace("fetch('registro_usuario.php'", "fetch('../api/auth/registro_usuario.php'")
    Set-Content "corazones-peludos\assets\js\scriptRegister.js" $content -Encoding UTF8
}

# Actualizar PHP includes
Write-Host "🔄 Actualizando PHP includes..." -ForegroundColor Yellow

# Función simple para actualizar PHP
$phpFiles = Get-ChildItem "corazones-peludos\api" -Recurse -Filter "*.php"
foreach ($phpFile in $phpFiles) {
    if ($phpFile.Directory.Name -ne "config") {
        $content = Get-Content $phpFile.FullName -Raw
        $content = $content.Replace("include_once 'conexion.php'", "include_once '../config/conexion.php'")
        $content = $content.Replace('include("conexion.php")', 'include("../config/conexion.php")')
        $content = $content.Replace('../img/', '../../assets/img/')
        Set-Content $phpFile.FullName $content -Encoding UTF8
    }
}

# Crear README básico
Write-Host "📄 Creando README..." -ForegroundColor Yellow
$readme = "# Corazones Peludos - Migrado`n`nEstructura nueva creada.`nBackup en: html_backup_$timestamp`n`nPara usar: abrir pages/index.html"
$readme | Out-File "corazones-peludos\README.md" -Encoding UTF8

# Estadísticas
Write-Host ""
Write-Host "🎉 ¡MIGRACIÓN COMPLETADA!" -ForegroundColor Green
Write-Host ""

$htmlCount = (Get-ChildItem 'corazones-peludos\pages\*.html' -ErrorAction SilentlyContinue).Count
$jsCount = (Get-ChildItem 'corazones-peludos\assets\js\*.js' -ErrorAction SilentlyContinue).Count
$phpCount = (Get-ChildItem 'corazones-peludos\api' -Recurse -Filter '*.php' -ErrorAction SilentlyContinue).Count

Write-Host "📊 RESUMEN:" -ForegroundColor Cyan
Write-Host "  ✅ $htmlCount archivos HTML" -ForegroundColor Green
Write-Host "  ✅ $jsCount archivos JavaScript" -ForegroundColor Green  
Write-Host "  ✅ $phpCount archivos PHP" -ForegroundColor Green
Write-Host "  ✅ Backup: html_backup_$timestamp" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 PROBAR: cd corazones-peludos && abrir pages\index.html" -ForegroundColor Yellow

pause