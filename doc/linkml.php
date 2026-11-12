<?php
$yamlParam = isset($_GET['yaml']) ? basename($_GET['yaml']) : '';
$filePath = __DIR__ . '/../yaml/' . $yamlParam;

if (empty($yamlParam) || !file_exists($filePath)) {
    http_response_code(404);
    echo "File LinkML non trovato.";
    exit;
}
$safeYamlUrl = htmlspecialchars($yamlParam, ENT_QUOTES, 'UTF-8');
?>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>LinkML Schema Viewer</title>
  <!-- Parser YAML e Renderer di Diagrammi -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/js-yaml/4.1.0/js-yaml.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <style>
    body { font-family: system-ui, -apple-system, sans-serif; margin: 20px; background: #f8f9fa; color: #333; }
    h1 { border-bottom: 2px solid #0066cc; padding-bottom: 8px; color: #0066cc; }
    .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; }
    th { background: #f1f3f5; }
    .mermaid { text-align: center; }
  </style>
</head>
<body>

  <h1>LinkML Schema: <?= $safeYamlUrl ?></h1>

  <div class="card">
    <h2>Diagramma delle Classi</h2>
    <div id="mermaid-diagram" class="mermaid">Caricamento diagramma...</div>
  </div>

  <div class="card">
    <h2>Dettaglio Classi e Attributi</h2>
    <div id="schema-details"></div>
  </div>

  <script>
    mermaid.initialize({ startOnLoad: false });

    // Carica il file LinkML direttamente dal server
    fetch('../yaml/<?= $safeYamlUrl ?>')
      .then(response => response.text())
      .then(yamlText => {
        const schema = jsyaml.load(yamlText);
        renderDiagram(schema);
        renderTables(schema);
      })
      .catch(err => {
        document.body.innerHTML = '<h3>Errore durante il caricamento del file LinkML.</h3>';
        console.error(err);
      });

    function renderDiagram(schema) {
      if (!schema.classes) return;
      let mermaidGraph = 'classDiagram\n';

      for (const [className, classDef] of Object.entries(schema.classes)) {
        mermaidGraph += `  class ${className} {\n`;
        const slots = classDef.slots || (classDef.attributes ? Object.keys(classDef.attributes) : []);
        slots.forEach(slot => {
          mermaidGraph += `    +${slot}\n`;
        });
        mermaidGraph += `  }\n`;

        if (classDef.is_a) {
          mermaidGraph += `  ${classDef.is_a} <|-- ${className}\n`;
        }
      }

      const container = document.getElementById('mermaid-diagram');
      container.removeAttribute('data-processed');
      container.innerHTML = mermaidGraph;
      mermaid.run({ nodes: [container] });
    }

    function renderTables(schema) {
      const detailsDiv = document.getElementById('schema-details');
      if (!schema.classes) {
        detailsDiv.innerHTML = '<p>Nessuna classe trovata nello schema.</p>';
        return;
      }

      let html = '';
      for (const [className, classDef] of Object.entries(schema.classes)) {
        html += `<h3>Classe: ${className}</h3>`;
        if (classDef.description) html += `<p><em>${classDef.description}</em></p>`;
        
        html += `<table><thead><tr><th>Campo (Slot)</th><th>Tipo / Range</th></tr></thead><tbody>`;
        
        const slots = classDef.attributes || {};
        if (classDef.slots) {
          classDef.slots.forEach(s => {
            const range = (schema.slots && schema.slots[s] && schema.slots[s].range) ? schema.slots[s].range : 'string';
            html += `<tr><td><strong>${s}</strong></td><td>${range}</td></tr>`;
          });
        }
        for (const [attrName, attrDef] of Object.entries(slots)) {
          html += `<tr><td><strong>${attrName}</strong></td><td>${attrDef.range || 'string'}</td></tr>`;
        }
        
        html += `</tbody></table><br>`;
      }
      detailsDiv.innerHTML = html;
    }
  </script>
</body>
</html>
