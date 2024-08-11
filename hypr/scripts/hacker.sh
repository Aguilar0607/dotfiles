#!/bin/bash

# Verificar si se proporcionó la ruta de la imagen
if [ -z "$1" ]; then
    echo "Error: No se proporcionó la ruta de la imagen."
    echo "Uso: $0 [ruta_a_la_imagen]"
    exit 1
fi

# Variables
IMAGE_PATH=$1
EDITED_IMAGE_PATH="${IMAGE_PATH%.*}_edited.png"
FG_COLOR='#edeff0'
BG_COLOR='#343637'
BG_SIZE=0
ROUNDED_CORNER=12
SHADOW_SIZE='100x40+0+16'
FONT_SIZE=30
FONT='Hack-Nerd-Font-Regular'  # Nombre exacto de la fuente como se identifica en tu sistema
AUTHOR_NAME=" $USER"
AUTHOR_COLOR='#6791c9'

# Aplicar esquinas redondeadas
magick "$IMAGE_PATH" \
\( +clone  -alpha extract \
-draw 'fill black polygon 0,0 0,'$ROUNDED_CORNER' '$ROUNDED_CORNER',0 fill white circle '$ROUNDED_CORNER','$ROUNDED_CORNER' '$ROUNDED_CORNER',0' \
\( +clone -flip \) -compose Multiply -composite \
\( +clone -flop \) -compose Multiply -composite \
\) -alpha off -compose CopyOpacity -composite \
"$EDITED_IMAGE_PATH"

# Agregar sombra
magick "$EDITED_IMAGE_PATH" \
\( +clone -background black -shadow $SHADOW_SIZE \) +swap -background none -layers merge +repage "$EDITED_IMAGE_PATH"

# Añadir bordes y color de fondo
magick "$EDITED_IMAGE_PATH" -bordercolor $BG_COLOR -border $BG_SIZE "$EDITED_IMAGE_PATH"

# Agregar texto del autor
echo -en "  $AUTHOR_NAME  " | magick "$EDITED_IMAGE_PATH" -gravity South -pointsize $FONT_SIZE -fill $AUTHOR_COLOR -undercolor none -font "$FONT" -annotate +0+15 @- "$EDITED_IMAGE_PATH"

echo "La imagen editada se ha guardado como $EDITED_IMAGE_PATH"

