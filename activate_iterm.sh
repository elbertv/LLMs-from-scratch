#!/bin/zsh
# Activar un entorno virtual y personalizar el prompt
# Uso: source activate_env.sh

# ─── Configuración ────────────────────────────────────────────
PROJECT_DIR=~/LLMs-from-scratch   # Directorio del proyecto
ENV_NAME=_pyllm                   # Nombre de la carpeta del entorno
PROMPT_LABEL="env"                # Texto que aparece en el prompt: (env) >>>
# ──────────────────────────────────────────────────────────────

#cd "$PROJECT_DIR"
source "$ENV_NAME/bin/activate"
export PS1="($ENV_NAME) >>> "