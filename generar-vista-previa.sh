#!/bin/bash
# Regenera vista-previa.html a partir de src/App.jsx y src/index.css
# para verla con doble clic, sin instalar Node.  Uso: bash generar-vista-previa.sh
cd "$(dirname "$0")"
{
cat <<'HTML'
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Narcoflix · Vista previa</title>
HTML
grep -E "<meta name=\"(description|theme-color)\"|<link rel=" index.html | sed -e "s#href=\"/#href=\"public/#" -e "s/^    /  /"
cat <<'HTML'
  <!-- Generado por generar-vista-previa.sh: no editar a mano -->
  <script src="https://cdn.tailwindcss.com/3.4.16"></script>
  <script src="https://unpkg.com/react@18.3.1/umd/react.production.min.js"></script>
  <script src="https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js"></script>
  <script src="https://unpkg.com/@babel/standalone@7.26.4/babel.min.js"></script>
  <style>
HTML
grep -v '^@import' src/index.css
cat <<'HTML'
  </style>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel" data-presets="react">
const { useCallback, useEffect, useRef, useState } = React;
HTML
# Los videos de public/ se sirven en "/" con Vite; aquí se leen desde public/
grep -v '^import ' src/App.jsx | sed -e 's/export default function App/function App/' -e "s#= '/\([^']*\)'#= 'public/\1'#"
cat <<'HTML'
ReactDOM.createRoot(document.getElementById('root')).render(<App />);
  </script>
</body>
</html>
HTML
} > vista-previa.html
echo "vista-previa.html actualizado"
