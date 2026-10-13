# MG4-Radio-Dash : construit l'APK radio redessinée à partir de l'APK patchée DAB+ d'origine.
#  1. compile le module d'aide (helper/src, Java) en smali ;
#  2. décode apk/Radio_patched_signed.apk avec apktool ;
#  3. applique les fichiers de dash/ (ressources, smali modifiés) et le smali du module ;
#  4. reconstruit et signe avec la clé plateforme AOSP (comme l'appli SAIC d'origine).
# Résultat : dist\Radio_Dash_signed.apk
param(
    [string]$Apktool = "$PSScriptRoot\..\tools\apktool.jar",
    [string]$KeyDir = "$PSScriptRoot\..\MG4Launcher\keys"
)
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$jdk = if ($env:JAVA_HOME) { $env:JAVA_HOME } else { "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot" }
$java = "$jdk\bin\java.exe"
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$bt = Get-ChildItem "$sdk\build-tools" -Directory | Sort-Object Name -Descending | Select-Object -First 1
$androidJar = "$sdk\platforms\android-28\android.jar"
$work = Join-Path $root "build"

# 1. Module d'aide → dex → smali
$h = Join-Path $work "helper"
New-Item -ItemType Directory -Force "$h\classes", "$h\dex" | Out-Null
$src = Get-ChildItem "$root\helper\src" -Recurse -Filter *.java | ForEach-Object FullName
& "$jdk\bin\javac.exe" --release 8 -encoding UTF-8 -cp $androidJar -d "$h\classes" $src
if ($LASTEXITCODE -ne 0) { throw "Échec de compilation du module d'aide" }
$classes = Get-ChildItem "$h\classes" -Recurse -Filter *.class | ForEach-Object FullName
& "$($bt.FullName)\d8.bat" --min-api 28 --lib $androidJar --output "$h\dex" $classes
Compress-Archive -Force -Path "$h\dex\classes.dex" -DestinationPath "$h\helper.zip"
Copy-Item "$h\helper.zip" "$h\helper.apk" -Force
& $java -jar $Apktool d -r -f -o "$h\decoded" "$h\helper.apk" | Out-Null

# 2. Décodage de l'APK patchée DAB+
$app = Join-Path $work "radio_src"
& $java -jar $Apktool d -f -o $app "$root\apk\Radio_patched_signed.apk" | Out-Null

# 3. Superposition
Copy-Item -Recurse -Force "$root\dash\*" $app
New-Item -ItemType Directory -Force "$app\smali\app\mg4dash\radiodash" | Out-Null
Copy-Item -Force "$h\decoded\smali\app\mg4dash\radiodash\*.smali" "$app\smali\app\mg4dash\radiodash\"

# 4. Reconstruction + signature
New-Item -ItemType Directory -Force "$root\dist" | Out-Null
& $java -jar $Apktool b -o "$work\radio_unsigned.apk" $app
if ($LASTEXITCODE -ne 0) { throw "Échec apktool b" }
& "$($bt.FullName)\zipalign.exe" -f -p 4 "$work\radio_unsigned.apk" "$work\radio_aligned.apk"
& "$($bt.FullName)\apksigner.bat" sign --key "$KeyDir\platform.pk8" --cert "$KeyDir\platform.x509.pem" `
    --v1-signing-enabled true --v2-signing-enabled true --out "$root\dist\Radio_Dash_signed.apk" "$work\radio_aligned.apk"
if ($LASTEXITCODE -ne 0) { throw "Échec de la signature" }
Write-Host "APK : dist\Radio_Dash_signed.apk"
