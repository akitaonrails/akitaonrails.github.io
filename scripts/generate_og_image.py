#!/usr/bin/env python3
"""Generate the default Open Graph card for the blog (1200x630).

Deterministic and dependency-light (Pillow + a system serif). Re-run after a
branding or tagline change:

    python3 scripts/generate_og_image.py

Output: static/og-default.png
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
PAPER = (251, 249, 244)
INK = (28, 33, 30)
MUTED = (90, 95, 88)
ACCENT = (29, 72, 54)
RULE = (214, 208, 197)

SERIF_BOLD = "/usr/share/fonts/liberation/LiberationSerif-Bold.ttf"
SERIF = "/usr/share/fonts/liberation/LiberationSerif-Regular.ttf"

WORDMARK = "AkitaOnRails"
TAGLINE = "Engenharia de software, IA e a disciplina de não terceirizar as próprias decisões."
FOOTER_LEFT = "akitaonrails.com"
FOOTER_RIGHT = "Fabio Akita"

MARGIN = 84


def font(path: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(path, size)


def wrap(draw: ImageDraw.ImageDraw, text: str, f: ImageFont.FreeTypeFont, max_w: int) -> list[str]:
    words, lines, cur = text.split(), [], ""
    for w in words:
        probe = f"{cur} {w}".strip()
        if draw.textlength(probe, font=f) <= max_w:
            cur = probe
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


def main() -> None:
    img = Image.new("RGB", (W, H), PAPER)
    d = ImageDraw.Draw(img)

    # Top and bottom hairlines, echoing the site's editorial rules.
    d.line([(MARGIN, 72), (W - MARGIN, 72)], fill=RULE, width=2)
    d.line([(MARGIN, H - 92), (W - MARGIN, H - 92)], fill=RULE, width=2)
    # Accent bar above the wordmark.
    d.rectangle([MARGIN, 118, MARGIN + 64, 126], fill=ACCENT)

    d.text((MARGIN, 168), WORDMARK, font=font(SERIF_BOLD, 104), fill=INK)

    tag_font = font(SERIF, 34)
    lines = wrap(d, TAGLINE, tag_font, W - 2 * MARGIN)
    y = 330
    for line in lines[:3]:
        d.text((MARGIN, y), line, font=tag_font, fill=MUTED)
        y += 48

    small = font(SERIF, 26)
    d.text((MARGIN, H - 68), FOOTER_LEFT, font=small, fill=ACCENT)
    right_w = d.textlength(FOOTER_RIGHT, font=small)
    d.text((W - MARGIN - right_w, H - 68), FOOTER_RIGHT, font=small, fill=MUTED)

    out = Path(__file__).resolve().parent.parent / "static" / "og-default.png"
    img.save(out, "PNG", optimize=True)
    print(f"wrote {out} ({out.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
