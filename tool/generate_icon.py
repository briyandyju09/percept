"""Generates Percept's app icon: a minimal eye/iris glyph on a solid
Percept Slate ground, in the brand's own color tokens (see
lib/theme/colors.dart). Produces:

  assets/icon/icon.png             - flat 1024x1024, no transparency
                                      (iOS App Store icon + legacy Android)
  assets/icon/icon_foreground.png  - eye glyph only, transparent background,
                                      padded to Android's adaptive-icon safe
                                      zone (foreground content should sit
                                      within the center ~66% to survive
                                      circular/rounded-square OS masking)

Run once with `python3 tool/generate_icon.py`, then `flutter pub run
flutter_launcher_icons` regenerates every platform size from these two
files (see flutter_launcher_icons.yaml).
"""

from PIL import Image, ImageDraw, ImageChops

SIZE = 1024

# Brand tokens, from lib/theme/colors.dart
SLATE = (0x33, 0x41, 0x5C, 255)  # PerceptColors.primaryLight
AMBER = (0xC9, 0x8A, 0x3B, 255)  # PerceptColors.accent
SCLERA = (0xF7, 0xF7, 0xF5, 255)  # PerceptColors.backgroundLight


def make_eye_mask(size: int, width_ratio: float, height_ratio: float) -> Image.Image:
    """A vesica-piscis (almond) "eye" shape: the intersection of two
    overlapping circles, which reads as a classic stylized eye outline.

    Two equal circles offset VERTICALLY (stacked, centers above/below the
    midline) intersect in a lens whose pointed tips sit on the horizontal
    axis (left/right) and whose belly bulges vertically at the center —
    i.e. exactly a natural wide, short "eye" almond, for the right choice
    of radius/offset. Given a target half-width w and half-height h:
        R - d = h            (bulge half-height at the horizontal center)
        sqrt(R^2 - d^2) = w  (half-width at the tips' meeting line)
    solving: R = (h + w^2/h) / 2, d = (w^2/h - h) / 2.
    """
    mask_size = size * 4  # supersample for smooth edges, downscale later
    w = (mask_size * width_ratio) / 2
    h = (mask_size * height_ratio) / 2
    radius = (h + (w * w) / h) / 2
    offset = ((w * w) / h - h) / 2
    cx = mask_size // 2
    cy = mask_size // 2

    circle_a = Image.new('L', (mask_size, mask_size), 0)
    ImageDraw.Draw(circle_a).ellipse(
        [cx - radius, cy - offset - radius, cx + radius, cy - offset + radius],
        fill=255,
    )
    circle_b = Image.new('L', (mask_size, mask_size), 0)
    ImageDraw.Draw(circle_b).ellipse(
        [cx - radius, cy + offset - radius, cx + radius, cy + offset + radius],
        fill=255,
    )
    lens = ImageChops.multiply(circle_a, circle_b)

    return lens.resize((size, size), Image.LANCZOS)


def draw_eye(canvas: Image.Image, cx: int, cy: int, scale: float, sclera_color, draw_background: bool):
    """Draws the full eye glyph (sclera lens + amber iris + slate pupil)
    centered at (cx, cy), sized relative to `scale` * canvas size."""
    glyph_size = int(SIZE * scale)
    lens_mask = make_eye_mask(glyph_size, width_ratio=0.86, height_ratio=0.40)

    sclera_layer = Image.new('RGBA', (glyph_size, glyph_size), (0, 0, 0, 0))
    sclera_solid = Image.new('RGBA', (glyph_size, glyph_size), sclera_color)
    sclera_layer.paste(sclera_solid, (0, 0), lens_mask)

    canvas.paste(
        sclera_layer,
        (cx - glyph_size // 2, cy - glyph_size // 2),
        sclera_layer,
    )

    draw = ImageDraw.Draw(canvas)
    iris_r = int(glyph_size * 0.145)
    draw.ellipse(
        [cx - iris_r, cy - iris_r, cx + iris_r, cy + iris_r], fill=AMBER
    )
    pupil_r = int(iris_r * 0.42)
    pupil_color = SLATE if draw_background else (0x14, 0x16, 0x1A, 255)
    draw.ellipse(
        [cx - pupil_r, cy - pupil_r, cx + pupil_r, cy + pupil_r],
        fill=pupil_color,
    )


# --- 1. Flat icon (solid background, for iOS + legacy Android) ---
flat = Image.new('RGBA', (SIZE, SIZE), SLATE)
draw_eye(flat, SIZE // 2, SIZE // 2, scale=0.62, sclera_color=SCLERA, draw_background=True)
flat.convert('RGB').save('assets/icon/icon.png')
print('Wrote assets/icon/icon.png')

# --- 2. Adaptive-icon foreground (transparent bg, padded safe zone) ---
foreground = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
# Android's adaptive icon foreground canvas is 108dp with only the center
# 66dp (~61%) guaranteed visible after masking, so keep the glyph smaller
# and centered relative to the full canvas.
draw_eye(foreground, SIZE // 2, SIZE // 2, scale=0.42, sclera_color=SCLERA, draw_background=False)
foreground.save('assets/icon/icon_foreground.png')
print('Wrote assets/icon/icon_foreground.png')
