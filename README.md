# Margen de Abastecimiento | Calculadora — GLP (Solgas)

Página interna de Abastecimiento para proyectar y comparar el margen de
importación de GLP. Reemplaza un archivo Excel rústico usado para el mismo fin.
Base de datos: la planilla `margen-importacion-historico.xlsx`.

## Qué es hoy

Un único archivo HTML (`index.html`), sin build. **Sin clave de acceso**: quien
tenga el enlace puede ver la proyección, simular y guardar. La proyección vigente
se comparte por Supabase (el mismo proyecto de `glp-dashboard`); si no hay
conexión, usa `localStorage` del navegador como respaldo.

Pestañas:

1. **Proyección** (la que ve el gerente) — estado de la proyección vigente
   (fecha de guardado y conexión), 2 tarjetas resumen (Margen importado YTD
   Enero–Agosto y Margen Set–Dic proyectado, cada una con el total en miles de
   US$ y el margen unitario US$/TM), la tabla mensual solo en USD (volumen,
   primas, margen unitario, margen importado, RAD, cabotaje Pluspetrol,
   DELTA VS 40 — sin tipo de cambio ni soles), la tabla de comparación de
   proveedores por transacción (solo lectura, mismo contenido que el Excel) y
   el detalle de buques. Incluye **Descargar Excel** (esa hoja sí conserva el
   tipo de cambio y el total en soles, igual que la planilla original).
   Se actualiza sola cada minuto.
2. **Nueva simulación** — por mes (Set–Dic): buques (proveedor, capacidad,
   demurrage, procura, otros), volumen, cabotaje Pluspetrol, primas y RAD.
   **Simular** muestra el resultado comparado contra la vigente; solo
   **Guardar como vigente** (con confirmación) la reemplaza para todos.
3. **RAD** — tabla de referencia 2024–2026 (solo lectura).
4. **Parámetros** — prima base de Geogas (contrato) y prima base sugerida de
   Trafigura (US$/TM); se guardan solas y se comparten.

La tabla de comparación de proveedores (transacciones que alimentan la prima
histórica de cada proveedor) ya no es editable desde la página; sus datos son
los de `defaultState.comp` en `index.html` y, si se editaron antes desde la
pestaña que existía, cada navegador solo guardaba su propia copia (nunca se
compartió por Supabase). Para actualizarla hay que editar `index.html`.

## Configuración de Supabase (una sola vez)

Ejecutar `margen-proyeccion.sql` en el SQL Editor de Supabase. Crea la tabla
`margen_proyeccion` (una fila `vigente`) con permisos para que cualquiera con el
enlace pueda leer y guardar. Sin este paso la página funciona, pero solo
guarda en el navegador de cada persona y lo avisa en pantalla.

Nota: no hay historial ni control de usuarios; guardar reemplaza la vigente.
Los datos base están dentro de `index.html`, así que si el repositorio o la
publicación son públicos, esos datos son públicos.

## Fórmulas (de la planilla)

- `Margen unitario = Prima Pluspetrol − Prima all in Importado`
- `Margen del importado US$ = Margen unitario × Volumen` (Ene–Ago: valor fijo de la planilla)
- `Total Soles = Margen del importado US$ × TC del mes`
- `Margen Cabotaje Pluspetrol = RAD × Volumen Cabotaje Pluspetrol`
- `DELTA VS 40 local = (RAD − 40) × Cabotaje`
- `DELTA VS 40 total = (RAD − 40) × (Volumen + Cabotaje)`
- Prima de un buque = prima base + demurrage + procura + otros gastos. La prima
  base es automática (contrato Geogas, prima sugerida de Trafigura o promedio
  ponderado del histórico de los demás proveedores) y se puede fijar a mano en
  cada buque.

## Pendiente / abierto

- Revisar los promedios históricos de proveedores con primas muy distintas al
  resto (posible otra base de cálculo) antes de simular con ellos.
- Decidir la fuente de la tabla de proveedores (la planilla trae menos
  transacciones que la tabla de comparación) y si conviene volver a hacerla
  editable (y, en ese caso, compartirla por Supabase).
- Sin clave ni historial: cualquiera con el enlace puede sobrescribir la vigente.
