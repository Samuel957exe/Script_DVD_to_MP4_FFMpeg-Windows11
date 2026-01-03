# Automatizador de Ripeo de DVD con FFmpeg (NVENC)

Este script de Windows (`.bat`) automatiza el proceso de copia de seguridad de discos DVD. Está diseñado para organizar automáticamente fotos y videos, convirtiendo los archivos `.VOB` a `.mp4` utilizando aceleración por hardware de NVIDIA (NVENC) para una máxima velocidad.

## 🚀 Características

* **Procesamiento por Lotes:** Permite procesar múltiples discos secuencialmente en un bucle.
* **Organización Automática:** Crea carpetas numeradas (`VideosDisco1`, `VideosDisco2`, etc.) basadas en la entrada del usuario.
* **Respaldo de Fotos:** Detecta automáticamente si el DVD tiene una carpeta `DCIM` y copia su contenido (manteniendo subcarpetas).
* **Conversión de Video:** Convierte archivos `.VOB` a `.mp4` usando `h264_nvenc` (calidad constante 19).
* **Filtrado Inteligente:** Excluye automáticamente el archivo `VIDEO_TS.VOB` (normalmente menús o loops de copyright) para convertir solo el contenido real.
* **Cierre Automático:** Cuenta atrás de 3 segundos al finalizar para cerrar el script automáticamente.

## 📋 Requisitos Previos

Para que este script funcione correctamente, necesitas:

1.  **Windows 10 o 11**.
2.  **FFmpeg** instalado y agregado a las [Variables de Entorno (PATH)](https://es.wikihow.com/instalar-FFmpeg-en-Windows).
3.  **Tarjeta Gráfica NVIDIA** (ya que el script usa el códec `h264_nvenc`).
    * *Nota: Si no tienes NVIDIA, debes editar el script y cambiar `h264_nvenc` por `libx264` (CPU).*

## ⚙️ Configuración (IMPORTANTE)

Antes de ejecutar el script por primera vez, **debes establecer dónde quieres guardar los archivos**.

1.  Haz clic derecho sobre el archivo `.bat` y selecciona **Editar** (o abrir con el Bloc de notas).
2.  Busca la línea 5 que dice `SET "BASE_OUTPUT=..."`.
3.  Cambia la ruta por la carpeta donde quieras almacenar tus copias.

**Ejemplo:**

```batch
:: CAMBIA ESTO POR TU RUTA PREFERIDA
SET "BASE_OUTPUT=D:\MisPeliculas\CopiasDVD"
