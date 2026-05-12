/* FocusDex — pixel-art renderer for the promo site
   Renders sprite grids from the design package into inline SVG, DOM-only. */
(function () {
  'use strict';

  const SVGNS = 'http://www.w3.org/2000/svg';

  const PAL = {
    '.': null,
    'k': '#06010f', 'K': '#1a0f2e',
    'w': '#ffffff', 'c': '#fff7df',
    'm': '#2EE6A0', 'M': '#1aa370', 'L': '#9af2ce',
    'p': '#FF6B6B', 'P': '#a83a3a', 'q': '#ffb3b3',
    'g': '#C147FF', 'G': '#7a2da8', 'h': '#e4a6ff',
    'b': '#47A0FF', 'B': '#2a64a8', 'l': '#a8d4ff',
    'y': '#FFD960', 'Y': '#a88f33', 'e': '#fff0b3',
    'n': '#3a2050', 'o': '#ff9a3a',
  };

  const SPRITES = {
    codesprite: [
      "................",
      "......kkkk......",
      ".....kmmmmk.....",
      "....kmLLmmmk....",
      "...kmLLmmmmmk...",
      "..kmmmmmmmmmmk..",
      "..kmmwwmmwwmmk..",
      "..kmmwwmmwwmmk..",
      "..kmmmmmmmmmmk..",
      "..kmmmmmmmmmmk..",
      "...kmmmmmmmmk...",
      "....kmmmmmmk....",
      ".....kkmmkk.....",
      ".......kk.......",
      "................",
      "................",
    ],
    inkling: [
      "................",
      ".......mm.......",
      "......mmmm......",
      ".....kggggk.....",
      "....kghhhhgk....",
      "...kghhwwhhgk...",
      "...kghwwhhwgk...",
      "...kghhhhhhgk...",
      "....kgggggGk....",
      "...kg.g.g.g.k...",
      "..kg.kg.kgk.gk..",
      ".kpkkpkkpkkpkk..",
      ".p..p..p..p..p..",
      "................",
      "................",
      "................",
    ],
    pixibrush: [
      "................",
      "......mmmm......",
      ".....kmmmmk.....",
      "...kkkqqqqkkk...",
      "..kpkkqqqqkkpk..",
      "..kpgmkqqkmgpk..",
      "..kpbymqqmybpk..",
      "..kpgmykkymgpk..",
      "..kpkkqqqqkkpk..",
      "...kkkqqqqkkk...",
      "....kqwwwwqk....",
      "....kqqqqqqk....",
      "....kqqyyqqk....",
      ".....kkqqkk.....",
      ".......y........",
      "................",
    ],
    notchy: [
      "............................",
      "....kkkkkkkkkkkkkkkkkkkk....",
      "...kKKKKKKKKKKKKKKKKKKKKk...",
      "..kKKKKKKKKKKKKKKKKKKKKKKk..",
      ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
      ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
      ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
      ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
      ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
      ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
      ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
      ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
      ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
      ".kKKqqKKKKKkkkkkkkKKKKqqKKk.",
      "..kKKKKKKKKKKKKKKKKKKKKKKk..",
      "...kKKKKKKKKKKKKKKKKKKKKk...",
      "....kkkkkkkkkkkkkkkkkkkk....",
      "............................",
    ],
    focusball: [
      "................",
      "....kkkkkkkk....",
      "...kmmmmmmmmk...",
      "..kmmLLmmmmmmk..",
      "..kmLLmmmmmmmk..",
      ".kmmmmmmmmmmmmk.",
      ".kmmmmmmmmmmmmk.",
      ".kkkkkkkkkkkkkk.",
      ".kkkkkkkkkkkkkk.",
      ".kwwwwwkkwwwwwk.",
      ".kwwwwkccwwwwwk.",
      "..kwwkccccwwwk..",
      "..kwwwkccwwwwk..",
      "...kwwwwwwwwk...",
      "....kkkkkkkk....",
      "................",
    ],
  };

  function makeSVG(name) {
    const grid = SPRITES[name];
    if (!grid) return null;
    const cols = grid[0].length;
    const rows = grid.length;
    const svg = document.createElementNS(SVGNS, 'svg');
    svg.setAttribute('viewBox', '0 0 ' + cols + ' ' + rows);
    svg.setAttribute('shape-rendering', 'crispEdges');
    svg.setAttribute('xmlns', SVGNS);
    svg.style.imageRendering = 'pixelated';
    svg.style.width = '100%';
    svg.style.height = '100%';
    svg.style.maxWidth = '140px';
    svg.style.maxHeight = '140px';
    for (let y = 0; y < rows; y++) {
      for (let x = 0; x < cols; x++) {
        const ch = grid[y][x];
        const color = PAL[ch];
        if (!color) continue;
        const rect = document.createElementNS(SVGNS, 'rect');
        rect.setAttribute('x', String(x));
        rect.setAttribute('y', String(y));
        rect.setAttribute('width', '1');
        rect.setAttribute('height', '1');
        rect.setAttribute('fill', color);
        svg.appendChild(rect);
      }
    }
    return svg;
  }

  document.querySelectorAll('[data-pixel-art]').forEach(function (el) {
    const name = el.getAttribute('data-pixel-art');
    const svg = makeSVG(name);
    if (svg) {
      while (el.firstChild) el.removeChild(el.firstChild);
      el.appendChild(svg);
    }
  });

  window.FocusDexPixels = { makeSVG, SPRITES, PAL };
})();
