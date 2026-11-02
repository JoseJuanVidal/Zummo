# Dashboard de producción

- `Dashboard_Zummo.html`: dashboard de planta (GAP Repuestos / Exprimidoras, Documentación, IDMs).
- `dashboard.config.js`: GAPs, KPIs con objetivos, checklist de la rutina y `apiUrl` (dirección del servicio cuando se abre el HTML como fichero). Sin contraseñas.

Los datos se guardan en BC (tablas 17207..17214, servicios web `Dash*` de esta extensión) a través del servicio **DashboardProduccion** (repo aparte: `Extensiones\Proyectos\DashboardProduccion`, ver su README). Safety y Documentación planta siguen guardándose en el navegador (IndexedDB).

Uso:
- Desde la red: `http://SERVIDOR:5090` (lo sirve el propio servicio).
- Desde la carpeta de SharePoint: abrir `Dashboard_Zummo.html` con `apiUrl: 'http://SERVIDOR:5090'` en `dashboard.config.js`.
