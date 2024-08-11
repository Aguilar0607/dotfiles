#!/bin/bash

# Verificar el modo de captura
if [ "$1" = "full" ]; then
    # Captura de pantalla completa
    CAPTURE_CMD="grim"
elif [ "$1" = "region" ]; then
    # Captura de una región seleccionada
    CAPTURE_CMD="grim -g \"\$(slurp)\""
else
    echo "Modo no especificado o incorrecto. Uso: $0 [full|region]"
    exit 1
fi

# Configuración de variables y rutas
OUTPUT_DIR=~/Pictures/Screenshots
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_NAME="Screenshot_$DATE.png"
FILE_PATH="$OUTPUT_DIR/$FILE_NAME"
EDITED_PATH="${FILE_PATH%.*}_edited.png"
LOG_FILE="$OUTPUT_DIR/screenshot_log.txt"

# Función para loguear mensajes
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >> "$LOG_FILE"
}

# Captura de pantalla
eval $CAPTURE_CMD "$FILE_PATH" && log "Captura realizada: $FILE_PATH" || { log "Error capturando pantalla"; exit 1; }

# Edición de la imagen
magick "$FILE_PATH" \
\( +clone  -alpha extract \
-draw 'fill black polygon 0,0 0,'20' '20',0 fill white circle '20','20' '20',0' \
\( +clone -flip \) -compose Multiply -composite \
\( +clone -flop \) -compose Multiply -composite \
\) -alpha off -compose CopyOpacity -composite \
"$EDITED_PATH"

magick "$EDITED_PATH" \
\( +clone -background black -shadow '100x40+0+16' \) +swap -background none -layers merge +repage "$EDITED_PATH"

magick "$EDITED_PATH" -bordercolor '#343637' -border 0 "$EDITED_PATH"

echo -en "    eaguilarm  " | magick "$EDITED_PATH" -gravity South -pointsize 30 -fill '#6791c9' -undercolor none -font 'Hack-Nerd-Font-Regular' -annotate +0+15 @- "$EDITED_PATH"

log "Imagen editada: $EDITED_PATH"

# Copia al portapapeles
wl-copy < "$EDITED_PATH" && log "Imagen copiada al portapapeles" || { log "Error copiando al portapapeles"; exit 1; }

# Notificar al usuario
~/.config/hypr/scripts/screenshot_notify && log "Notificación enviada" || log "Error enviando notificación"

log "Proceso completado exitosamente"
echo "Proceso completado: La imagen editada se ha guardado y copiado al portapapeles."

