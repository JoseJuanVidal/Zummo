"""HTML -> PDF con Edge headless + barra roja superior y pie en cada página.
Uso: python -I build_pdf.py <html> <pdf destino> <texto pie>"""
import io
import pathlib
import subprocess
import sys
import tempfile

from pypdf import PdfReader, PdfWriter
from reportlab.lib.colors import HexColor
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas

EDGE = r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
html, out, footer = pathlib.Path(sys.argv[1]).resolve(), pathlib.Path(sys.argv[2]), sys.argv[3]

with tempfile.TemporaryDirectory() as tmp:
    raw = pathlib.Path(tmp) / 'raw.pdf'
    subprocess.run([EDGE, '--headless', '--disable-gpu', '--no-pdf-header-footer',
                    f'--user-data-dir={tmp}\\edge', f'--print-to-pdf={raw}', html.as_uri()],
                   check=True, capture_output=True, timeout=120)
    reader = PdfReader(str(raw))
    pdfmetrics.registerFont(TTFont('SegoeUI', r'C:\Windows\Fonts\segoeui.ttf'))
    writer = PdfWriter()
    for n, page in enumerate(reader.pages, start=1):
        w, h = float(page.mediabox.width), float(page.mediabox.height)
        buf = io.BytesIO()
        c = canvas.Canvas(buf, pagesize=(w, h))
        c.setFillColor(HexColor('#e3260f'))
        c.rect(18 * mm, h - 12 * mm, w - 36 * mm, 1.1 * mm, stroke=0, fill=1)
        c.setFillColor(HexColor('#8a8a8a'))
        c.setFont('SegoeUI', 7.5)
        c.drawString(18 * mm, 9 * mm, footer)
        c.drawRightString(w - 18 * mm, 9 * mm, f'Página {n}')
        c.save()
        buf.seek(0)
        page.merge_page(PdfReader(buf).pages[0])
        writer.add_page(page)
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, 'wb') as f:
        writer.write(f)
print(out, len(reader.pages), 'páginas')
