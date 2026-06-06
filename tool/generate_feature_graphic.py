#!/usr/bin/env python3
"""Generate the Play Store feature graphic (1024×500).

Dark background with coral K logo, app name, tagline, and phone mockup.
Matches the Kadence dark theme aesthetic.
"""

import os
from PIL import Image, ImageDraw, ImageFont

# Brand colors
BG_DARK = (0x0E, 0x0E, 0x0C)
BG_SUBTLE = (0x1A, 0x1A, 0x17)
CORAL = (0xFF, 0x7A, 0x45)
FG_PRIMARY = (0xF4, 0xF2, 0xEC)
FG_SECONDARY = (0x8A, 0x88, 0x80)
PHONE_BEZEL = (0x2A, 0x2A, 0x26)

PROJECT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT_PATH = "/tmp/Sora.ttf"
SCREENSHOT_PATH = os.path.join(PROJECT, "landing", "img", "weekly_view_en.jpg")

WIDTH = 1024
HEIGHT = 500


def draw_k_glyph(draw, cx, cy, size, stroke_width, color=CORAL):
    """Draw the K monogram centered at (cx, cy)."""
    half = size / 2
    mid = cy
    left = cx - half + size * 0.31
    right = cx - half + size * 0.72
    top = cy - half + size * 0.20
    bottom = cy - half + size * 0.80

    draw.line([(left, top), (left, bottom)], fill=color, width=stroke_width)
    draw.line([(left, mid), (right, top)], fill=color, width=stroke_width)
    draw.line([(left, mid), (right, bottom)], fill=color, width=stroke_width)

    r = stroke_width / 2
    for pt in [(left, top), (left, bottom), (left, mid),
               (right, top), (right, bottom)]:
        x, y = pt
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)


def draw_rounded_rect(draw, xy, radius, fill):
    """Draw a rounded rectangle."""
    x0, y0, x1, y1 = xy
    r = radius
    draw.ellipse([x0, y0, x0 + 2*r, y0 + 2*r], fill=fill)
    draw.ellipse([x1 - 2*r, y0, x1, y0 + 2*r], fill=fill)
    draw.ellipse([x0, y1 - 2*r, x0 + 2*r, y1], fill=fill)
    draw.ellipse([x1 - 2*r, y1 - 2*r, x1, y1], fill=fill)
    draw.rectangle([x0 + r, y0, x1 - r, y1], fill=fill)
    draw.rectangle([x0, y0 + r, x1, y1 - r], fill=fill)


def create_phone_mockup(screenshot_path, phone_height):
    """Create a phone mockup with the screenshot inside a bezel frame."""
    screenshot = Image.open(screenshot_path)
    ss_w, ss_h = screenshot.size

    # Phone proportions
    bezel = 8
    corner_r = 20
    screen_h = phone_height - bezel * 2
    screen_w = int(screen_h * ss_w / ss_h)
    phone_w = screen_w + bezel * 2
    phone_h = phone_height

    # Create phone frame with rounded corners
    phone = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    phone_draw = ImageDraw.Draw(phone)

    # Bezel (rounded rect)
    draw_rounded_rect(phone_draw, [0, 0, phone_w, phone_h], corner_r, PHONE_BEZEL)

    # Screen area (rounded rect, slightly smaller radius)
    inner_r = max(corner_r - bezel, 4)
    draw_rounded_rect(phone_draw,
                      [bezel, bezel, phone_w - bezel, phone_h - bezel],
                      inner_r, (0, 0, 0, 255))

    # Resize screenshot to fit screen
    resized = screenshot.resize((screen_w, screen_h), Image.LANCZOS)

    # Create a mask for rounded corners on the screenshot
    mask = Image.new("L", (screen_w, screen_h), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, screen_w, screen_h], inner_r, fill=255)

    # Paste screenshot into the phone
    phone.paste(resized, (bezel, bezel), mask)

    return phone


def main():
    img = Image.new("RGB", (WIDTH, HEIGHT), BG_DARK)
    draw = ImageDraw.Draw(img)

    draw = ImageDraw.Draw(img)

    # Left side: logo + text
    logo_size = 100
    logo_x = 180
    logo_y = HEIGHT // 2

    # Fonts
    try:
        font_name = ImageFont.truetype(FONT_PATH, 44)
        font_tagline = ImageFont.truetype(FONT_PATH, 20)
    except OSError:
        font_name = ImageFont.load_default()
        font_tagline = ImageFont.load_default()

    rect_size = logo_size
    text_x = logo_x + rect_size // 2 + 30

    # Measure title text width to compute bg rect right edge
    title_bbox = font_name.getbbox("Kadence Sports")
    title_w = title_bbox[2] - title_bbox[0]

    # Background rect: left padding from logo = right padding from text
    bg_rect_padding = 40
    bg_rect_x0 = logo_x - logo_size // 2 - bg_rect_padding
    bg_rect_y0 = logo_y - logo_size // 2 - bg_rect_padding
    bg_rect_x1 = text_x + title_w + bg_rect_padding
    bg_rect_y1 = logo_y + logo_size // 2 + bg_rect_padding
    draw_rounded_rect(draw,
                      [bg_rect_x0, bg_rect_y0, bg_rect_x1, bg_rect_y1],
                      20, (0x1F, 0x14, 0x0F))

    # Draw dark rounded rect behind the K
    rect_radius = int(rect_size * 0.22)
    draw_rounded_rect(
        draw,
        [logo_x - rect_size // 2, logo_y - rect_size // 2,
         logo_x + rect_size // 2, logo_y + rect_size // 2],
        rect_radius, BG_SUBTLE
    )

    # Draw K glyph
    draw_k_glyph(draw, logo_x, logo_y, logo_size, stroke_width=4)

    # Text
    logo_top = logo_y - rect_size // 2
    logo_bottom = logo_y + rect_size // 2

    draw.text((text_x, logo_top), "Kadence Sports", fill=FG_PRIMARY,
              font=font_name, anchor="lt")
    draw.text((text_x, logo_bottom), "Plan & Track Your Training",
              fill=FG_SECONDARY, font=font_tagline, anchor="lb")

    # Right side: phone mockup
    phone_h = int(HEIGHT * 0.76)
    phone = create_phone_mockup(SCREENSHOT_PATH, phone_h)
    phone_w = phone.width

    # Position: right side, vertically centered, within 100px safe zone
    phone_x = WIDTH - phone_w - 110
    phone_y = (HEIGHT - phone_h) // 2

    # Paste phone onto main image
    img_rgba = img.convert("RGBA")
    img_rgba.paste(phone, (phone_x, phone_y), phone)
    img = img_rgba.convert("RGB")

    # Save
    out_path = os.path.join(PROJECT, "assets", "feature_graphic.png")
    img.save(out_path, "PNG")
    print(f"  {out_path} ({WIDTH}×{HEIGHT})")
    print("Done!")


if __name__ == "__main__":
    main()
