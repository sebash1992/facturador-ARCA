# Imagen del bot. Multi-arch: funciona igual en la Raspberry (ARM64) y en x86.
FROM python:3.14-slim

WORKDIR /app

COPY requirements.txt .
# tzdata: fallback para ZoneInfo por si la imagen slim no trae la base de zonas.
RUN pip install --no-cache-dir -r requirements.txt tzdata

COPY facturador.py bot_telegram.py ./

ENV TZ=America/Argentina/Buenos_Aires

CMD ["python", "bot_telegram.py"]
