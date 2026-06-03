#!/usr/bin/env python3
"""Generate Kadence app icons from the K monogram design.

Produces:
- Android adaptive icon layers (foreground + background XML)
- Legacy launcher PNGs at all densities
- 512×512 Play Store icon
"""

import math
import os
from PIL import Image, ImageDraw

# Brand colors
CORAL = (0xFF, 0x7A, 0x45)        # dark theme accent — used for the K glyph
BG_DARK = (0x0E, 0x0E, 0x0C)      # bgBase dark from kadence_colors.dart
BG_CARD = (0x1A, 0x1A, 0x17)      # bgCard dark — slightly lighter, used for store
WHITE = (0xFF, 0xFF, 0xFF)

PROJECT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(PROJECT, "android", "app", "src", "main", "res")


def draw_k_glyph(draw, size, stroke_width, color=WHITE):
    """Draw the K monogram matching _KGlyphPainter from welcome_step.dart."""
    mid = size / 2
    left = size * 0.31
    right = size * 0.72
    top = size * 0.20
    bottom = size * 0.80

    draw.line([(left, top), (left, bottom)], fill=color, width=stroke_width)
    draw.line([(left, mid), (right, top)], fill=color, width=stroke_width)
    draw.line([(left, mid), (right, bottom)], fill=color, width=stroke_width)

    # Round caps — draw circles at endpoints
    r = stroke_width / 2
    for pt in [(left, top), (left, bottom), (left, mid),
               (right, top), (right, bottom)]:
        x, y = pt
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)


def draw_rounded_rect(draw, xy, radius, fill):
    """Draw a rounded rectangle (Pillow <9 compat)."""
    x0, y0, x1, y1 = xy
    r = radius
    # Four corner circles
    draw.ellipse([x0, y0, x0 + 2*r, y0 + 2*r], fill=fill)
    draw.ellipse([x1 - 2*r, y0, x1, y0 + 2*r], fill=fill)
    draw.ellipse([x0, y1 - 2*r, x0 + 2*r, y1], fill=fill)
    draw.ellipse([x1 - 2*r, y1 - 2*r, x1, y1], fill=fill)
    # Two rectangles to fill the body
    draw.rectangle([x0 + r, y0, x1 - r, y1], fill=fill)
    draw.rectangle([x0, y0 + r, x1, y1 - r], fill=fill)


def generate_legacy_icon(size):
    """Dark square with rounded corners and coral K glyph (legacy launcher)."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    radius = int(size * 0.22)  # ~20% corner radius like the in-app logo
    draw_rounded_rect(draw, [0, 0, size, size], radius, BG_DARK)
    stroke = max(int(size * 0.039), 2)
    draw_k_glyph(draw, size, stroke, color=CORAL)
    return img


def generate_adaptive_foreground(size):
    """108dp-equivalent foreground: K glyph centered in the safe zone.
    Android adaptive icons use 108dp canvas with 72dp safe zone centered.
    The glyph occupies the inner ~66% of the canvas.
    """
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    # The safe zone is 72/108 of the canvas = 66.67%, centered
    # Draw the glyph slightly smaller within the safe zone
    glyph_size = int(size * 0.55)
    offset = (size - glyph_size) // 2
    # Create a temp image for the glyph, then paste
    glyph_img = Image.new("RGBA", (glyph_size, glyph_size), (0, 0, 0, 0))
    glyph_draw = ImageDraw.Draw(glyph_img)
    stroke = max(int(glyph_size * 0.045), 2)
    draw_k_glyph(glyph_draw, glyph_size, stroke, color=CORAL)
    img.paste(glyph_img, (offset, offset), glyph_img)
    return img


def generate_store_icon():
    """512×512 Play Store icon — dark background with coral K glyph."""
    size = 512
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    # Play Store applies its own rounding, so we draw a rounded rect
    radius = int(size * 0.18)
    draw_rounded_rect(draw, [0, 0, size, size], radius, BG_DARK)
    stroke = max(int(size * 0.042), 2)
    draw_k_glyph(draw, size, stroke, color=CORAL)
    return img


# Android mipmap sizes (legacy)
DENSITIES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

# Adaptive icon foreground sizes (108dp equiv)
ADAPTIVE_SIZES = {
    "mipmap-mdpi": 108,
    "mipmap-hdpi": 162,
    "mipmap-xhdpi": 216,
    "mipmap-xxhdpi": 324,
    "mipmap-xxxhdpi": 432,
}


def main():
    # 1. Legacy launcher icons
    for density, size in DENSITIES.items():
        folder = os.path.join(RES, density)
        os.makedirs(folder, exist_ok=True)
        icon = generate_legacy_icon(size)
        path = os.path.join(folder, "ic_launcher.png")
        icon.save(path, "PNG")
        print(f"  {path} ({size}×{size})")

    # 2. Adaptive icon foreground
    for density, size in ADAPTIVE_SIZES.items():
        folder = os.path.join(RES, density)
        os.makedirs(folder, exist_ok=True)
        fg = generate_adaptive_foreground(size)
        path = os.path.join(folder, "ic_launcher_foreground.png")
        fg.save(path, "PNG")
        print(f"  {path} ({size}×{size})")

    # 3. Adaptive icon XML (background = coral, foreground = PNG)
    anydpi_folder = os.path.join(RES, "mipmap-anydpi-v26")
    os.makedirs(anydpi_folder, exist_ok=True)

    ic_launcher_xml = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
'''
    with open(os.path.join(anydpi_folder, "ic_launcher.xml"), "w") as f:
        f.write(ic_launcher_xml)
    print(f"  {anydpi_folder}/ic_launcher.xml")

    # 4. Background color resource
    values_folder = os.path.join(RES, "values")
    os.makedirs(values_folder, exist_ok=True)
    colors_path = os.path.join(values_folder, "ic_launcher_background.xml")
    colors_xml = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#0E0E0C</color>
</resources>
'''
    with open(colors_path, "w") as f:
        f.write(colors_xml)
    print(f"  {colors_path}")

    # 5. 512×512 Play Store icon
    store_icon = generate_store_icon()
    store_path = os.path.join(PROJECT, "assets", "play_store_icon.png")
    store_icon.save(store_path, "PNG")
    print(f"  {store_path} (512×512)")

    print("\nDone! All icons generated.")


if __name__ == "__main__":
    main()
