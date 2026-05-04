from pathlib import Path
from PIL import Image

# Configuración de recorte
COLUMNS = 8  # 0..7
ROWS = 5    # 0..4
OUT_NAME = 'fusion.png'
EXTENSIONS = ['png', 'jpg', 'jpeg', 'bmp', 'gif']

base_dir = Path(__file__).resolve().parent

# --------------------------------------------------------------
# Dividir la imagen fusionada de vuelta en 0_0..7_4
# --------------------------------------------------------------

def split_fusion_image():
    fusion_path = base_dir / OUT_NAME
    if not fusion_path.exists():
        raise FileNotFoundError(f"No existe la imagen fusionada: {fusion_path}")

    img = Image.open(fusion_path)
    full_w, full_h = img.size

    if full_w % COLUMNS != 0 or full_h % ROWS != 0:
        raise ValueError(
            f"Dimensiones de fusion.png ({full_w}x{full_h}) no son múltiples de {COLUMNS}x{ROWS}"
        )

    tile_w = full_w // COLUMNS
    tile_h = full_h // ROWS

    for y in range(ROWS):
        for x in range(COLUMNS):
            left = x * tile_w
            upper = y * tile_h
            right = left + tile_w
            lower = upper + tile_h
            tile = img.crop((left, upper, right, lower))
            out_tile_path = base_dir / f"{x}_{y}.png"
            tile.save(out_tile_path)

    print(f"División completada de {fusion_path} en {COLUMNS*ROWS} piezas")

# Ejecución: dividir fusion.png en 0_0..7_4
split_fusion_image()

def split_fusion_image():
    fusion_path = base_dir / OUT_NAME
    if not fusion_path.exists():
        raise FileNotFoundError(f"No existe la imagen fusionada: {fusion_path}")

    img = Image.open(fusion_path)
    full_w, full_h = img.size

    if full_w % COLUMNS != 0 or full_h % ROWS != 0:
        raise ValueError(
            f"Dimensiones de fusion.png ({full_w}x{full_h}) no son múltiples de {COLUMNS}x{ROWS}"
        )

    tile_w = full_w // COLUMNS
    tile_h = full_h // ROWS

    for y in range(ROWS):
        for x in range(COLUMNS):
            left = x * tile_w
            upper = y * tile_h
            right = left + tile_w
            lower = upper + tile_h
            tile = img.crop((left, upper, right, lower))
            out_tile_path = base_dir / f"{x}_{y}.png"
            tile.save(out_tile_path)

    print(f"División completada de {fusion_path} en {COLUMNS*ROWS} piezas")

# Ejecución secuencial: fusionar y luego dividir
split_fusion_image()
