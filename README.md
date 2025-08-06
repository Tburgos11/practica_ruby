# Taller - Scraping de Ofertas Laborales

Este proyecto es un script en Ruby que realiza web scraping sobre el sitio [talently.tech](https://talently.tech/trabajos) para extraer información de ofertas de trabajo y guardarlas en un archivo CSV.

## ¿Qué hace este script?

1. **Scraping de la web:**
   - Accede a la web de Talently y recorre varias páginas de ofertas de trabajo.
   - Extrae información relevante de cada oferta: título, empresa, modalidad, salario, enlace y descripción.
   - Muestra por consola un resumen de cada oferta encontrada.

2. **Almacenamiento en CSV:**
   - Guarda todas las ofertas extraídas en un archivo llamado `jobs.csv`.
   - El archivo CSV contiene las siguientes columnas: Título, Empresa, Modalidad, Salario, Link, Descripción.

## ¿Cómo funciona?

- El script utiliza las gemas `nokogiri` y `open-uri` para descargar y parsear el HTML de la web.
- Define una clase `Job` para representar cada oferta y una clase `Scraper` para gestionar la extracción de datos.

## ¿Cómo ejecutar?

1. Instala las dependencias necesarias:
   ```bash
   gem install nokogiri
   ```
2. Ejecuta el script:
   ```bash
   ruby main.rb
   ```
3. Al finalizar, encontrarás el archivo `jobs.csv` en el mismo directorio con todas las ofertas extraídas.

**Autor:Thomas Burgos** Taller de Ruby - Scraping
