"""Draws Futoshiki's app icon and writes every size the platforms need.

A small grid with < and > signs between the numbers. On brand navy with an amber edge, in the App Verse Games house style
(see Fanorona and Surakarta). Re-run after tweaking:

    python tool/generate_icons.py      (from the project folder, needs Pillow)
"""

import pathlib

from PIL import Image, ImageDraw, ImageFont

ROOT = pathlib.Path(__file__).resolve().parent.parent
NAVY = (0x16, 0x19, 0x3A)
NAVY_DEEP = (0x0E, 0x10, 0x26)
NAVY_SURFACE = (0x1E, 0x22, 0x50)
AMBER = (0xF2, 0xA5, 0x41)
AMBER_DARK = (0xD9, 0x87, 0x2A)
IVORY = (0xF6, 0xF3, 0xEC)
IVORY_DARK = (0xCF, 0xC8, 0xB8)
IVORY_TEXT = (0xED, 0xE9, 0xDF)
TEAL = (0x4F, 0xB3, 0xA9)
LINE = (0x8A, 0x8C, 0x9E)

S = 1024  # drawn large, then scaled down

# The game's own bundled font (OFL), for the digits.
FONT = ROOT / "assets/fonts/Nunito-Bold.ttf"


def text(d, xy, s, size, fill):
    font = ImageFont.truetype(str(FONT), int(size))
    d.text(xy, s, font=font, fill=fill, anchor="mm")


def stone(d, cx, cy, r, light, dark):
    d.ellipse((cx - r, cy - r + r * 0.12, cx + r, cy + r + r * 0.12), fill=(8, 9, 24))
    d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=dark)
    k = r * 0.86
    d.ellipse((cx - k - r * 0.08, cy - k - r * 0.1, cx + k - r * 0.08, cy + k - r * 0.1), fill=light)
    k = r * 0.6
    d.ellipse((cx - k, cy - k, cx + k, cy + k), outline=dark, width=int(r * 0.08))


def art(full_bleed, content_scale=1.0):
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if full_bleed:
        d.rectangle((0, 0, S, S), fill=NAVY)
    else:
        m = S * 0.04
        d.rounded_rectangle((m, m, S - m, S - m), radius=S * 0.2, fill=NAVY,
                            outline=AMBER, width=int(S * 0.035))

    def at(x, y):
        """A point given as fractions of S, scaled around the centre."""
        return (S / 2 + (x - 0.5) * S * content_scale,
                S / 2 + (y - 0.5) * S * content_scale)

    k = S * content_scale  # fractions of the icon -> pixels
    # A 2 x 2 puzzle: 1 < 3 on top, 4 > 2 below.
    cell, gap = 0.27, 0.12
    x0 = 0.5 - cell - gap / 2
    xs = (x0, x0 + cell + gap)
    digits = [["1", "3"], ["4", "2"]]
    for row, y in enumerate(xs):
        for col, x in enumerate(xs):
            selected = (row, col) == (1, 1)
            d.rounded_rectangle((*at(x, y), *at(x + cell, y + cell)), radius=0.05 * k,
                                fill=TEAL if selected else IVORY_TEXT)
            text(d, at(x + cell / 2, y + cell / 2 + 0.005), digits[row][col], 0.2 * k, NAVY)
        text(d, at(0.5, y + cell / 2 - 0.01), "<" if row == 0 else ">", 0.17 * k, AMBER)
    return img


def save(img, path, size, rgb=False):
    out = img.resize((size, size), Image.LANCZOS)
    if rgb:
        bg = Image.new("RGB", out.size, NAVY)
        bg.paste(out, mask=out.split()[3])
        out = bg
    path.parent.mkdir(parents=True, exist_ok=True)
    out.save(path)
    print(f"{path.relative_to(ROOT)}  {size}px")


rounded = art(full_bleed=False)
square = art(full_bleed=True)
maskable = art(full_bleed=True, content_scale=0.78)  # inside the safe zone

save(rounded, ROOT / "web/favicon.png", 32)
save(rounded, ROOT / "web/icons/Icon-192.png", 192)
save(rounded, ROOT / "web/icons/Icon-512.png", 512)
save(maskable, ROOT / "web/icons/Icon-maskable-192.png", 192)
save(maskable, ROOT / "web/icons/Icon-maskable-512.png", 512)

for folder, size in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
    save(rounded, ROOT / f"android/app/src/main/res/mipmap-{folder}/ic_launcher.png", size)

# iOS wants square, opaque icons; keep each existing file's size.
for png in sorted((ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset").glob("*.png")):
    save(square, png, Image.open(png).size[0], rgb=True)

ico = ROOT / "windows/runner/resources/app_icon.ico"
rounded.resize((256, 256), Image.LANCZOS).save(
    ico, sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
print(f"{ico.relative_to(ROOT)}  16-256px")
