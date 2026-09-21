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
   (fecha de guardado y conexión), tarjetas resumen, la tabla mensual con las
   filas de la planilla (TC, volumen, primas, margen importado, Total Soles,
   RAD, cabotaje, DELTA VS 40) y el detalle de buques. Incluye
   **Descargar Excel**. Se actualiza sola cada minuto.
2. **Nueva simulación** — por mes (Set–Dic): buques (proveedor, capacidad,
   demurrage, procura, otros), volumen, cabotaje, primas, TC y RAD. **Simular**
   muestra el resultado comparado contra la vigente; solo **Guardar como
   vigente** (con confirmación) la reemplaza para todos.
3. **Comparación de proveedores** — tabla editable con transacciones Ene–Sep 2026.
4. **RAD** — tabla de referencia 2024–2026 (solo lectura).
5. **Parámetros** — prima base de Geogas (contrato) y prima base sugerida de
   Trafigura (US$/TM); se guardan solas y se comparten.

## Configuración de Supabase (una sola vez)

Ejecutar `margen-proyeccion.sql` en el SQL Editor de Supabase. Crea la tabla
`margen_proyeccion` (una fila `vigente`) con permisos para que cualquiera con el
enlace pueda leer y guardar. Sin este paso la página funciona, pero solo
guarda en el navegador de cada persona y lo avisa en pantalla.

Nota: no hay historial ni control de usuarios; guardar reemplaza la vigente.
Los datos base están dentro de `index.html`, así que si el repositorio o la
publicación son públicos, esos datos son públicos.

## Fórmulas (de la planilla)

- `Margen unitario = Prima PPC − Precio Importado`
- `Margen importado US$ = Margen unitario × Volumen` (Ene–Ago: valor fijo de la planilla)
- `Total Soles = Margen importado US$ × TC del mes`
- `Margen Cabotaje = RAD × Volumen Cabotaje Plus`
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
  transacciones que la pestaña Comparación).
- Sin clave ni historial: cualquiera con el enlace puede sobrescribir la vigente.
