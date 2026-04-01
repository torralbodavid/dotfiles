# 🚀 Dotfiles

Configuración personal de macOS. Clona, ejecuta, y tu Mac queda listo para trabajar.

## ⚡ Instalación rápida

```bash
git clone https://github.com/tu-usuario/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
chmod +x install.sh
./install.sh
```

Eso es todo. El script se encarga de **todo**.

## 📦 ¿Qué hace `install.sh`?

El instalador ejecuta estos pasos de forma automática e interactiva:

### 1. 🍺 Instala Homebrew
Si no tienes Homebrew instalado, lo instala automáticamente (compatible con Apple Silicon e Intel).

### 2. 📦 Instala aplicaciones
Instala todas las aplicaciones del `Brewfile` usando `brew bundle`. El script te preguntará antes de instalar las apps opcionales:

| App | Siempre | Opcional | Default |
|-----|:-------:|:--------:|:-------:|
| Airtable | ✅ | | |
| Antigravity | ✅ | | |
| Cursor | ✅ | | |
| Discord | ✅ | | |
| Docker Desktop | ✅ | | |
| Firefox | ✅ | | |
| Google Chrome | ✅ | | |
| Herd | ✅ | | |
| Hidden Bar | ✅ | | |
| DBngin | ✅ | | |
| MacDown | ✅ | | |
| OpenVPN Connect | ✅ | | |
| PhpStorm | ✅ | | |
| Spotify | ✅ | | |
| TablePlus | ✅ | | |
| Thunderbird | ✅ | | |
| Zoom | ✅ | | |
| AppCleaner | ✅ | | |
| Postman / Insomnia | | ✅ | Postman |
| Notion | | ✅ | Sí |
| Rectangle | | ✅ | Sí |
| Sequel Ace | | ✅ | Sí |
| Warp | | ✅ | Sí |
| FileZilla | | ✅ | No (descarga manual) |
| Chrome Canary | | ✅ | No |

> **Nota:** FileZilla fue eliminado de Homebrew. Si eliges instalarlo, se abrirá la web de descarga automáticamente.

### 3. 🔧 Configura Git
Te preguntará tu **nombre** y **email** para generar `~/.gitconfig` con la configuración correcta. También linkea el `.gitignore_global`.

### 4. 🔗 Crea symlinks
Crea enlaces simbólicos desde tu `$HOME` hacia los archivos de configuración del repositorio:

```
~/.zshrc             → dotfiles/configs/.zshrc
~/.gitconfig         → dotfiles/configs/.gitconfig
~/.gitignore_global  → dotfiles/configs/.gitignore_global
```

> Si ya existen estos archivos, se crea un backup automático (`.backup`).

### 5. 🍎 Aplica configuración de macOS
Ejecuta `macos/defaults.sh` que configura:

- **Finder:** Muestra archivos ocultos y extensiones
- **Trackpad:** Tap-to-click activado
- **Dock:** Tamaño 48, posición abajo, auto-hide
- **Teclado:** Repetición rápida
- **Screenshots:** Se guardan en `~/Screenshots`

## 📂 Estructura del proyecto

```
dotfiles/
├── Brewfile                    # Apps de Homebrew (base)
├── install.sh                  # Script de instalación interactivo
├── README.md                   # Este archivo
├── configs/
│   ├── .zshrc                  # Aliases y funciones de shell
│   ├── .gitconfig              # (generado por install.sh)
│   └── .gitignore_global       # Gitignore global
└── macos/
    └── defaults.sh             # Preferencias de macOS
```

## 🐚 Aliases incluidos

### SSH
```bash
par01, par04, par05, par06, par07, par08, mia03, bp02
```

### Laravel / PHP
```bash
artisan    → php artisan
dump       → php artisan dump-server
tinker     → php artisan tinker
```

### macOS
```bash
hidedesktop    # Oculta los iconos del escritorio
showdesktop    # Muestra los iconos del escritorio
emptytrash     # Vacía la papelera y limpia logs del sistema
```

### IDE
```bash
ps    # Abre PhpStorm con argumentos
```

### Funciones
```bash
killport 3000    # Mata el proceso que escucha en el puerto indicado
```

## 🔄 Actualización

Si modificas los archivos de configuración en este repo, los cambios se aplican directamente gracias a los symlinks. Solo necesitas:

```bash
source ~/.zshrc   # Para recargar aliases
```

Para re-aplicar la configuración de macOS:
```bash
bash ~/Code/dotfiles/macos/defaults.sh
```

## 📝 Notas

- El `.gitconfig` **no se sube al repositorio** porque contiene datos personales (nombre, email, ruta `$HOME`). Se genera durante la instalación.
- Compatible con **macOS Monterey** o superior.
- Compatible con **Apple Silicon (M1/M2/M3/M4)** e **Intel**.
