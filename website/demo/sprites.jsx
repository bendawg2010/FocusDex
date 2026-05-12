// sprites.jsx — FocusDex pixel-art sprite library
// All creatures, Notchy, Gate, Pokeballs, sigils, type badges, etc.
// Uses a tiny pixel-grid DSL: 2D string array + palette map.

const PAL = {
  '.': null,            // transparent
  'k': '#06010f',       // dark navy outline
  'K': '#1a0f2e',       // softer dark
  'w': '#ffffff',
  'c': '#fff7df',       // cream
  'm': '#2EE6A0',       // mint
  'M': '#1aa370',       // dark mint
  'L': '#9af2ce',       // light mint
  'p': '#FF6B6B',       // pink
  'P': '#a83a3a',       // dark pink
  'q': '#ffb3b3',       // light pink
  'g': '#C147FF',       // magenta
  'G': '#7a2da8',       // dark magenta
  'h': '#e4a6ff',       // light magenta
  'b': '#47A0FF',       // blue
  'B': '#2a64a8',       // dark blue
  'l': '#a8d4ff',       // light blue
  'y': '#FFD960',       // yellow
  'Y': '#a88f33',       // dark yellow
  'e': '#fff0b3',       // light yellow
  'n': '#3a2050',       // ink purple
  'o': '#ff9a3a',       // orange
  's': 'rgba(0,0,0,0.25)', // shadow
  'z': '#0f380f',       // gameboy dark
  'Z': '#9bbc0f',       // gameboy light
};

function PixelArt({ grid, palette = PAL, scale = 1, className = '', style = {}, glow }) {
  const h = grid.length;
  const w = grid[0].length;
  const rects = [];
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const ch = grid[y][x];
      const c = palette[ch];
      if (!c) continue;
      rects.push(<rect key={`${x}-${y}`} x={x} y={y} width="1" height="1" fill={c} />);
    }
  }
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      className={`psprite ${className}`}
      width={w * scale}
      height={h * scale}
      viewBox={`0 0 ${w} ${h}`}
      style={{ filter: glow, ...style }}
    >
      {rects}
    </svg>
  );
}

// ─── Notchy (mascot) ────────────────────────────────────────────────────────
// 28×18 — wide notch-shape body, mint eye highlights, pink cheek dots
const NOTCHY = [
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
];

function Notchy({ scale = 4, glow = "drop-shadow(0 4px 10px rgba(46,230,160,.18))", style = {} }) {
  return <PixelArt grid={NOTCHY} scale={scale} glow={glow} style={style} />;
}

// Notchy waving — same body, one arm up
const NOTCHY_WAVE = [
  "............................",
  "...........mm...............",
  "...........mm...............",
  "....kkkkkkkkkkkkkkkkkkkk....",
  "...kKKKKKKKKKmmKKKKKKKKKk...",
  "..kKKKKKKKKKKKKKKKKKKKKKKk..",
  ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
  ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
  ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
  ".kKKKwwwwKKKKKKKKKKwwwwKKKk.",
  ".kKKKKwwKKKKKKKKKKKKwwKKKKk.",
  ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
  ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
  ".kKKqqKKKKKkkkkkkKKKKKqqKKk.",
  "..kKKKKKKKKKKKKKKKKKKKKKKk..",
  "...kKKKKKKKKKKKKKKKKKKKKk...",
  "....kkkkkkkkkkkkkkkkkkkk....",
  "............................",
];
function NotchyWave({ scale = 4, style = {} }) {
  return <PixelArt grid={NOTCHY_WAVE} scale={scale} style={style} glow="drop-shadow(0 4px 10px rgba(46,230,160,.22))" />;
}

// Notchy concerned (eyes wide, ! above)
const NOTCHY_ALERT = [
  "............................",
  ".............yy.............",
  ".............yy.............",
  ".............yy.............",
  "....kkkkkkkkkkkkkkkkkkkk....",
  "...kKKKKKKKKKKKKKKKKKKKKk...",
  "..kKKKKKKKKKKKKKKKKKKKKKKk..",
  ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
  ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
  ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
  ".kKKKwwwKKKKKKKKKKKKwwwKKKk.",
  ".kKKKKKKKKKKKKKKKKKKKKKKKKk.",
  ".kKKqqKKKKKKKkkkKKKKKKqqKKk.",
  ".kKKqqKKKKKKKKKKKKKKKKqqKKk.",
  "..kKKKKKKKKKKKKKKKKKKKKKKk..",
  "...kKKKKKKKKKKKKKKKKKKKKk...",
  "....kkkkkkkkkkkkkkkkkkkk....",
  "............................",
];
function NotchyAlert({ scale = 4, style = {} }) {
  return <PixelArt grid={NOTCHY_ALERT} scale={scale} style={style} glow="drop-shadow(0 0 14px rgba(255,217,96,.45))" />;
}

// ─── Creature: Codesprite ───────────────────────────────────────────────────
const CODESPRITE = [
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
  "......./........",
  "................",
];
function Codesprite(props) { return <PixelArt grid={CODESPRITE} {...props} />; }

// Codecrawler — stage 2, four-legged
const CODECRAWLER = [
  "................",
  "...kkkk.........",
  "..kmmmmk.kkkk...",
  ".kmLLmmmkmmmmk..",
  ".kmwwmmmmmmwmk..",
  ".kmmmmmmmmmmmk..",
  ".kmgggmmmgggmk..",
  ".kmmmmmmmmmmmk..",
  "..kmmmmmmmmmmk..",
  "..kkmkkmmkkmkk..",
  "...kmk.kk.kmk...",
  "...kmk....kmk...",
  "....k.....k.....",
  ".....mmmmmmmm...",
  "......mmmmm.....",
  "................",
];
function Codecrawler(props) { return <PixelArt grid={CODECRAWLER} {...props} />; }

// Codetitan — stage 3, robed monk
const CODETITAN = [
  "................",
  ".....kkkk.......",
  "....kmmmmk......",
  "...kmLLmmmk.....",
  "...kmwwmwwk.....",
  "...kmmmmmmk.....",
  "..kmgmmmmgmk....",
  ".kmmgmmmmgmmk...",
  ".kmmmmymmmmmk...",
  ".kmmmmymmmmmk...",
  "kmmgmgmgmgmmmk..",
  "kmmgmgmgmgmmmk..",
  "kmmgmgmgmgmmmk..",
  ".kmmmgmgmmmmk...",
  "..kkkkkkkkkkk...",
  "................",
];
function Codetitan(props) { return <PixelArt grid={CODETITAN} {...props} />; }

// ─── Inkling ────────────────────────────────────────────────────────────────
const INKLING = [
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
];
function Inkling(props) { return <PixelArt grid={INKLING} {...props} />; }

// Inkwarden — stage 2
const INKWARDEN = [
  "................",
  "......mmmm......",
  ".....mppppm.....",
  "....kggggggk....",
  "...kghhwwhhgk...",
  "...kghwwhhwgk...",
  "...kgggyyggk....",
  "...kgggggggk....",
  "..kgGGGGGGGgk...",
  "..kgGppppGgk....",
  "..kgGpyyppGgk...",
  "..kgGpyyppGgk...",
  "..kgGppppGgk....",
  "..kgGGGGGGGgk...",
  "...kkkkkkkkk....",
  "................",
];
function Inkwarden(props) { return <PixelArt grid={INKWARDEN} {...props} />; }

// Inkdragoon — stage 3, serpent dragon
const INKDRAGOON = [
  "................",
  "....kkkk........",
  "...kggggk.kkkk..",
  "..kghhwhgkgggk..",
  "..kghwwhhggwgk..",
  "..kggyymgggggk..",
  "..kggggmgggggk..",
  ".kggmmmmmmgggk..",
  ".kgmmmmmmmmgggk.",
  ".kgggggggggggk..",
  "..kkkkkkkkkkkk..",
  "....pp..pp..pp..",
  "...ppp..ppp.pp..",
  "................",
  "................",
  "................",
];
function Inkdragoon(props) { return <PixelArt grid={INKDRAGOON} {...props} />; }

// ─── Pixibrush ──────────────────────────────────────────────────────────────
const PIXIBRUSH = [
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
];
function Pixibrush(props) { return <PixelArt grid={PIXIBRUSH} {...props} />; }

// Brushwing — stage 2
const BRUSHWING = [
  "................",
  "..mm........mm..",
  ".pmgm......mgmp.",
  ".pgmgb....bgmgp.",
  ".pmgmbk..kbmgmp.",
  ".pgmgbymybgmgp..",
  "..pmgmkqkmgmp...",
  "...kkqqwqqkk....",
  "...kqyqqqyqk....",
  "....kkqqqkk.....",
  ".....kqqqk......",
  "......kkk.......",
  "................",
  "................",
  "................",
  "................",
];
function Brushwing(props) { return <PixelArt grid={BRUSHWING} {...props} />; }

// Maestrix — stage 3
const MAESTRIX = [
  "................",
  ".....kqqqk......",
  "....kqwwwqk.....",
  "....kqmmmqk.....",
  "..mm.kgpgk.mm...",
  ".mgm.kggk.mgm...",
  ".pbm..kk..mbp...",
  ".pyb.kggk.byp...",
  "..ppbgggggbpp...",
  "...ppgygypp.....",
  "....pgmmmgp.....",
  "....pggpggp.....",
  ".....pgpgp......",
  ".....kkkkk......",
  "................",
  "................",
];
function Maestrix(props) { return <PixelArt grid={MAESTRIX} {...props} />; }

// ─── Bracketling — Code · Pixel ─────────────────────────────────────────────
const BRACKETLING = [
  "................",
  ".....kkkkkk.....",
  "....kblllllbk...",
  "...kbll..llbk...",
  "...kbl....lbk...",
  "...kbl.ww.lbk...",
  "..k.kbwwwwbk.k..",
  "..b.kbgwwgbk.b..",
  "..k.kblllbbk.k..",
  "...kbl....lbk...",
  "...kbl....lbk...",
  "...kbll..llbk...",
  "....kblllllbk...",
  ".....kkkkkkk....",
  "......k..k......",
  "................",
];
function Bracketling(props) { return <PixelArt grid={BRACKETLING} {...props} />; }

// ─── Stickynote — Doc · Pixel ───────────────────────────────────────────────
const STICKYNOTE = [
  "................",
  "..kkkkkkkkkkkk..",
  ".kyyyyyyyyyyyk..",
  ".kyykkyyyykkyk..",
  ".kyyyyyyyyyyyk..",
  ".kygggggggggyk..",
  ".kybbbbbbbbbyk..",
  ".kypppppppppyk..",
  ".kyyyyyyyyyyyk..",
  ".kyyyyyyyyyyyk..",
  ".kyyyyyyyyyyYk..",
  ".kyyyyyyyyyYYk..",
  ".kkkkkkkkkYYkk..",
  "...k....k.YY....",
  "................",
  "................",
];
function Stickynote(props) { return <PixelArt grid={STICKYNOTE} {...props} />; }

// ─── Wavelet — Sound · Pixel ────────────────────────────────────────────────
const WAVELET = [
  "................",
  "................",
  "......kkk.......",
  ".....kmmmk......",
  "....kmwwmmk.....",
  "....kmwkmmk.....",
  "...kkmmmmkkk....",
  "..kmkkkkmmmmk...",
  "kmm.....kmmmk...",
  ".k.....km.kmk...",
  "........k..k....",
  "................",
  "................",
  "................",
  "................",
  "................",
];
function Wavelet(props) { return <PixelArt grid={WAVELET} {...props} />; }

// ─── Tickbug — Test · Code ──────────────────────────────────────────────────
const TICKBUG = [
  "................",
  ".......m........",
  "......m.m.......",
  ".....m...m......",
  "....kmkkkmk.....",
  "...kmmmmmmmk....",
  "...kmwwmwwmk....",
  "..kmkmmmmmkmk...",
  ".kmmmmmmmmmmmk..",
  ".kmmmmmmmmmmmk..",
  "..kmkmkkkmkmk...",
  "...kk.mmm.kk....",
  "...kk.mmm.kk....",
  ".......m........",
  "................",
  "................",
];
function Tickbug(props) { return <PixelArt grid={TICKBUG} {...props} />; }

// ─── Sproutmit — Doc · Zen ──────────────────────────────────────────────────
const SPROUTMIT = [
  "................",
  "......mmm.......",
  ".....mmmmm......",
  "....mmkmmm......",
  ".....mmm........",
  "....kYYYk.......",
  "...kYYpYYk......",
  "...kYwYwYk......",
  "...kYYYYYk......",
  "...kYYYYYk......",
  "...kkkkkkk......",
  "....k...k.......",
  "................",
  "................",
  "................",
  "................",
];
function Sproutmit(props) { return <PixelArt grid={SPROUTMIT} {...props} />; }

// ─── Pokeball: Focus Ball (mint top, white bottom) ──────────────────────────
const FOCUS_BALL = [
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
];
function FocusBall(props) { return <PixelArt grid={FOCUS_BALL} {...props} />; }

const GREAT_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kbbbbbgggk...",
  "..kbblllbggggk..",
  "..kblllbbgggGk..",
  ".kbbbbbbggggggk.",
  ".kbbbbbbbgggggk.",
  ".kkkkkkkkkkkkkk.",
  ".kkkkkkkkkkkkkk.",
  ".kwwwwwkkwwwwwk.",
  ".kwwwwkmmwwwwwk.",
  "..kwwkmmmmwwwk..",
  "..kwwwkmmwwwwk..",
  "...kwwwwwwwwk...",
  "....kkkkkkkk....",
  "................",
];
function GreatBall(props) { return <PixelArt grid={GREAT_BALL} {...props} />; }

const ULTRA_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kKKKKKKKKk...",
  "..kKKKwwKKKKKk..",
  "..kKwwwwKKKKKk..",
  ".kKKKKKKKKKKKKk.",
  ".kKKKKKKKKKKKKk.",
  ".kkkkkkkkkkkkkk.",
  ".kyyyyykkyyyyyk.",
  ".kyyyykggyyyyyk.",
  "..kyykggggyyyk..",
  "..kyyykggyyyyk..",
  "..kyyyyyyyyyyk..",
  "...kyyyyyyyyk...",
  "....kkkkkkkk....",
  "................",
];
function UltraBall(props) { return <PixelArt grid={ULTRA_BALL} {...props} />; }

const MASTER_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kggmmbbggk...",
  "..kgmmbbggmmpk..",
  "..kgmbbggmmppk..",
  ".kgmbbggmmppyyk.",
  ".kmbbggmmppyypk.",
  ".kkkkkkkkkkkkkk.",
  ".kbbggmmppyybbk.",
  ".kbggmmppyybmgk.",
  "..kggmmppyybmk..",
  "..kgmmppyybmgk..",
  "..kmmppyybmgmk..",
  "...kppyybmgmk...",
  "....kkkkkkkk....",
  "................",
];
function MasterBall(props) { return <PixelArt grid={MASTER_BALL} {...props} />; }

const QUICK_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kyyyyyyyyk...",
  "..kyyeeyyyyyyk..",
  "..kyeeyyyyyyyk..",
  ".kyyyyyyyyyyyyk.",
  ".kyyyyyyyyyyyyk.",
  ".kwkwkwkwkwkwkk.",
  ".kbbbbbbbbbbbbk.",
  ".kblbbbbbmmbbbk.",
  "..kbbbbbmymbbk..",
  "..kbbbbbbmmbbk..",
  "..kbbbbbbbbbbk..",
  "...kbbbbbbbbk...",
  "....kkkkkkkk....",
  "................",
];
function QuickBall(props) { return <PixelArt grid={QUICK_BALL} {...props} />; }

const PREMIER_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kqqqqqqqqk...",
  "..kqqwwqqqqqqk..",
  "..kqwwwwqqqqqk..",
  ".kqqqqqqqqqqqqk.",
  ".kqqqqqqqqqqqqk.",
  ".kyyyyyyyyyyyyk.",
  ".kwwwwwwwwwwwwk.",
  ".kwwwwwppwwwwwk.",
  "..kwwwppppwwwk..",
  "..kwwwppppwwwk..",
  "..kwwwwppwwwwk..",
  "...kwwwwwwwwk...",
  "....kkkkkkkk....",
  "................",
];
function PremierBall(props) { return <PixelArt grid={PREMIER_BALL} {...props} />; }

const NET_BALL = [
  "................",
  "....kkkkkkkk....",
  "...kghgmgmgmk...",
  "..kghmgmgmgmgk..",
  "..kgmgmgmgmgmk..",
  ".kgmgmgmgmgmgmk.",
  ".kgmgmgmgmgmgmk.",
  ".kkkkkkkkkkkkkk.",
  ".kKlKlKlKlKlKlk.",
  ".kKlKlKlKlKlKlk.",
  "..kKlKlmmlKlKk..",
  "..kKlKlKlmmlKk..",
  "..kKlKlKlKlKKk..",
  "...kKlKlKlKlk...",
  "....kkkkkkkk....",
  "................",
];
function NetBall(props) { return <PixelArt grid={NET_BALL} {...props} />; }

const DREAM_BALL = [
  "................",
  "....kkkkkkkk....",
  "...khqqhqqhqk...",
  "..khhqLqhqLqhk..",
  "..khqLqhqLqhqk..",
  ".khLqhqLqhqLqhk.",
  ".kqhqLqhqLqhqLk.",
  ".kkkkkkkkkkkkkk.",
  ".kLqhqLqhqLqhqk.",
  ".khqLqhqLyyhqLk.",
  "..khqLqLyyqLqk..",
  "..khqLqhqLqhqk..",
  "..kLqhqLqhqLqk..",
  "...khqLqhqLqk...",
  "....kkkkkkkk....",
  "................",
];
function DreamBall(props) { return <PixelArt grid={DREAM_BALL} {...props} />; }

// ─── The Gate ───────────────────────────────────────────────────────────────
// 24×20 — chunky double-leaf gate with mint keyhole-star center
function GateSVG({ state = "sealed", width = 360, height = 300 }) {
  // state: open | sealing | sealed | reopening
  const runesOn = state === "sealed" || state === "reopening";
  const runeOpacity = state === "sealing" ? 0.6 : runesOn ? 1 : 0.25;
  const leafAngle = state === "open" ? 70 : state === "sealing" ? 30 : state === "reopening" ? 40 : 0;
  const sigilVisible = state === "sealed" || state === "reopening";
  return (
    <svg viewBox="0 0 360 300" width={width} height={height} xmlns="http://www.w3.org/2000/svg" style={{ filter: state === 'sealed' ? 'drop-shadow(0 0 30px rgba(193,71,255,.35))' : 'none' }}>
      {/* warm glow from beyond (visible when open/reopening/sealing) */}
      {state !== "sealed" && (
        <defs>
          <radialGradient id="warmGlow" cx="50%" cy="55%" r="40%">
            <stop offset="0%" stopColor="#FFD960" stopOpacity="0.95" />
            <stop offset="60%" stopColor="#FF6B6B" stopOpacity="0.4" />
            <stop offset="100%" stopColor="#FFD960" stopOpacity="0" />
          </radialGradient>
        </defs>
      )}
      {/* doorway dark space */}
      <rect x="68" y="60" width="224" height="210" fill="#06010f" />
      {/* warm glow shining through the opening when leaves are apart */}
      {state !== "sealed" && (
        <ellipse cx="180" cy="170" rx={state === "reopening" ? 110 : state === "open" ? 95 : 35} ry={state === "reopening" ? 130 : state === "open" ? 110 : 90} fill="url(#warmGlow)" />
      )}

      {/* left leaf */}
      <g transform={`rotate(${-leafAngle} 78 165)`}>
        <rect x="68" y="60" width="112" height="210" fill="#1a1230" stroke="#06010f" strokeWidth="3" />
        {/* leaf trim */}
        <rect x="68" y="60" width="6" height="210" fill="#C147FF" opacity={runeOpacity} />
        <rect x="68" y="60" width="112" height="6" fill="#C147FF" opacity={runeOpacity} />
        <rect x="68" y="264" width="112" height="6" fill="#C147FF" opacity={runeOpacity} />
        {/* rune dots */}
        {[80, 100, 120, 140, 160, 180, 200, 220, 240].map((y, i) => (
          <rect key={i} x="74" y={y} width="4" height="4" fill="#FF6B6B" opacity={runeOpacity} />
        ))}
      </g>
      {/* right leaf */}
      <g transform={`rotate(${leafAngle} 282 165)`}>
        <rect x="180" y="60" width="112" height="210" fill="#1a1230" stroke="#06010f" strokeWidth="3" />
        <rect x="286" y="60" width="6" height="210" fill="#C147FF" opacity={runeOpacity} />
        <rect x="180" y="60" width="112" height="6" fill="#C147FF" opacity={runeOpacity} />
        <rect x="180" y="264" width="112" height="6" fill="#C147FF" opacity={runeOpacity} />
        {[80, 100, 120, 140, 160, 180, 200, 220, 240].map((y, i) => (
          <rect key={i} x="282" y={y} width="4" height="4" fill="#FF6B6B" opacity={runeOpacity} />
        ))}
      </g>

      {/* central pillars */}
      <rect x="50" y="40" width="22" height="240" fill="#2a1a4a" stroke="#06010f" strokeWidth="3" />
      <rect x="288" y="40" width="22" height="240" fill="#2a1a4a" stroke="#06010f" strokeWidth="3" />
      {/* pillar caps */}
      <rect x="42" y="32" width="38" height="14" fill="#3a2a5a" stroke="#06010f" strokeWidth="3" />
      <rect x="280" y="32" width="38" height="14" fill="#3a2a5a" stroke="#06010f" strokeWidth="3" />
      {/* pillar rune lines */}
      <rect x="54" y="56" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />
      <rect x="54" y="78" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />
      <rect x="54" y="100" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />
      <rect x="292" y="56" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />
      <rect x="292" y="78" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />
      <rect x="292" y="100" width="14" height="3" fill="#C147FF" opacity={runeOpacity} />

      {/* ground path */}
      <rect x="80" y="280" width="200" height="6" fill="#1a1230" stroke="#06010f" strokeWidth="2" />

      {/* center sigil (when sealed/reopening) */}
      {sigilVisible && <g transform="translate(180 165)" style={{ filter: 'drop-shadow(0 0 16px rgba(46,230,160,.7))' }}>
        <Sigil tier={4} size={70} />
      </g>}
    </svg>
  );
}

// ─── Sigils (4 tiers) ───────────────────────────────────────────────────────
function Sigil({ tier = 1, size = 64 }) {
  // tier: 1 Sprout, 2 Bloom, 3 Zen, 4 Inferno
  const cx = 32, cy = 32;
  const star = "M32,12 L36,26 L50,26 L39,34 L43,48 L32,40 L21,48 L25,34 L14,26 L28,26 Z";
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} xmlns="http://www.w3.org/2000/svg" shapeRendering="geometricPrecision">
      {/* outer flame petals (tier 4) */}
      {tier >= 4 && [...Array(12)].map((_, i) => {
        const a = (i / 12) * Math.PI * 2;
        const x = cx + Math.cos(a) * 30;
        const y = cy + Math.sin(a) * 30;
        return <circle key={i} cx={x} cy={y} r="1.5" fill="#FFD960" />;
      })}
      {/* outer blue dot ring (tier 3+) */}
      {tier >= 3 && [...Array(8)].map((_, i) => {
        const a = (i / 8) * Math.PI * 2;
        const x = cx + Math.cos(a) * 26;
        const y = cy + Math.sin(a) * 26;
        return <circle key={`b${i}`} cx={x} cy={y} r="1.5" fill="#47A0FF" />;
      })}
      {/* yellow corner petals (tier 2+) */}
      {tier >= 2 && [...Array(4)].map((_, i) => {
        const a = (i / 4) * Math.PI * 2 + Math.PI / 4;
        const x = cx + Math.cos(a) * 22;
        const y = cy + Math.sin(a) * 22;
        return <circle key={`y${i}`} cx={x} cy={y} r="1.8" fill="#FFD960" />;
      })}
      {/* magenta hexagon (tier 2+) */}
      {tier >= 2 && (
        <polygon
          points={[...Array(6)].map((_, i) => {
            const a = (i / 6) * Math.PI * 2 - Math.PI / 2;
            return `${cx + Math.cos(a) * 20},${cy + Math.sin(a) * 20}`;
          }).join(' ')}
          fill="none" stroke="#C147FF" strokeWidth="2"
        />
      )}
      {/* pink ring */}
      <circle cx={cx} cy={cy} r="16" fill="none" stroke="#FF6B6B" strokeWidth="2" />
      {/* mint star */}
      <path d={star} fill="#2EE6A0" stroke="#06010f" strokeWidth="1" />
      {/* center dot */}
      <circle cx={cx} cy={cy} r="2" fill="#FFD960" />
    </svg>
  );
}

// ─── Streak Flame (4 tiers) ─────────────────────────────────────────────────
const FLAME_SPARK = [
  "........",
  "...y....",
  "..ymy...",
  "..yyy...",
  "...y....",
  "........",
];
const FLAME_7 = [
  "........",
  "...y....",
  "..yyy...",
  "..ypy...",
  "..yyy...",
  "...y....",
  "........",
];
const FLAME_30 = [
  "........",
  "...y....",
  "..yyy...",
  ".yyypy..",
  ".ypgpy..",
  ".yppy...",
  "..yyy...",
  "........",
];
const FLAME_365 = [
  "..y..y..",
  ".yyyyy..",
  ".ypppy..",
  ".ypgpy..",
  "yppgppy.",
  "ypgmgpy.",
  ".ypppy..",
  ".yyyyy..",
];
function StreakFlame({ tier = 1, scale = 4 }) {
  const grids = [FLAME_SPARK, FLAME_7, FLAME_30, FLAME_365];
  return <PixelArt grid={grids[Math.min(tier, 4) - 1]} scale={scale} />;
}

// ─── Type Badge (hexagon, 15 types) ─────────────────────────────────────────
const TYPE_DEF = {
  Code:     { c1: '#2EE6A0', c2: '#159a6a', sym: 'code' },
  Art:      { c1: '#C147FF', c2: '#FF6B6B', sym: 'art' },
  Doc:      { c1: '#FFE890', c2: '#FFD960', sym: 'doc' },
  Sound:    { c1: '#47A0FF', c2: '#C147FF', sym: 'sound' },
  Sun:      { c1: '#FFD960', c2: '#FF6B6B', sym: 'sun' },
  Moon:     { c1: '#06010f', c2: '#C147FF', sym: 'moon' },
  Dream:    { c1: '#e4a6ff', c2: '#9af2ce', sym: 'dream' },
  Spark:    { c1: '#FFD960', c2: '#2EE6A0', sym: 'spark' },
  Zen:      { c1: '#2EE6A0', c2: '#47A0FF', sym: 'zen' },
  Caffeine: { c1: '#fff7df', c2: '#7a4a2a', sym: 'cup' },
  Storm:    { c1: '#47A0FF', c2: '#C147FF', sym: 'storm' },
  Glitch:   { c1: '#C147FF', c2: '#47A0FF', sym: 'glitch' },
  Spirit:   { c1: '#C147FF', c2: '#2EE6A0', sym: 'spirit' },
  Pixel:    { c1: '#47A0FF', c2: '#2EE6A0', sym: 'pixel' },
  Time:     { c1: '#FFD960', c2: '#C147FF', sym: 'time' },
  Pixel2:   { c1: '#47A0FF', c2: '#2EE6A0', sym: 'pixel' },
};

function TypeSymbol({ sym }) {
  const s = { fill: '#fff', stroke: '#06010f', strokeWidth: 0.5 };
  switch (sym) {
    case 'code': return <text x="16" y="22" textAnchor="middle" fontSize="14" fontFamily="JetBrains Mono, monospace" fontWeight="700" fill="#fff">{'{}'}</text>;
    case 'art': return <g><circle cx="16" cy="17" r="6" fill="none" stroke="#fff" strokeWidth="1.5"/><circle cx="13" cy="15" r="1" fill="#FF6B6B"/><circle cx="18" cy="14" r="1" fill="#FFD960"/><circle cx="19" cy="19" r="1" fill="#2EE6A0"/></g>;
    case 'doc': return <g><rect x="11" y="10" width="10" height="13" fill="#fff" stroke="#06010f" strokeWidth=".5"/><polygon points="18,10 21,10 21,13" fill="#FFD960"/><line x1="13" y1="14" x2="18" y2="14" stroke="#2EE6A0" strokeWidth="1"/><line x1="13" y1="17" x2="18" y2="17" stroke="#2EE6A0" strokeWidth="1"/><line x1="13" y1="20" x2="17" y2="20" stroke="#2EE6A0" strokeWidth="1"/></g>;
    case 'sound': return <g><rect x="11" y="14" width="2" height="6" fill="#fff"/><rect x="14" y="11" width="2" height="12" fill="#fff"/><rect x="17" y="13" width="2" height="8" fill="#fff"/><rect x="20" y="15" width="2" height="4" fill="#fff"/></g>;
    case 'sun': return <g><circle cx="16" cy="16" r="5" fill="#fff"/>{[...Array(8)].map((_,i)=>{const a=i/8*Math.PI*2;return <line key={i} x1={16+Math.cos(a)*7} y1={16+Math.sin(a)*7} x2={16+Math.cos(a)*10} y2={16+Math.sin(a)*10} stroke="#fff" strokeWidth="1.4"/>})}</g>;
    case 'moon': return <g><path d="M11,16 a5,5 0 1,0 8,-4 a4,4 0 1,1 -8,4" fill="#fff"/><circle cx="22" cy="11" r="1" fill="#fff"/></g>;
    case 'dream': return <g><ellipse cx="16" cy="18" rx="6" ry="4" fill="#fff"/><text x="20" y="13" fontSize="6" fill="#fff" fontFamily="ui-rounded, sans-serif" fontWeight="800">z</text></g>;
    case 'spark': return <polygon points="14,10 19,15 16,15 19,22 14,17 17,17" fill="#fff"/>;
    case 'zen': return <g><circle cx="16" cy="16" r="6" fill="none" stroke="#fff" strokeWidth="1.5" strokeDasharray="35,4"/></g>;
    case 'cup': return <g><rect x="11" y="13" width="9" height="9" fill="#fff" stroke="#06010f" strokeWidth=".5"/><path d="M20 15 q3 0 3 3 q0 3 -3 3" fill="none" stroke="#fff" strokeWidth="1.5"/><line x1="13" y1="10" x2="13" y2="12" stroke="#fff" strokeWidth="1"/><line x1="16" y1="9" x2="16" y2="11" stroke="#fff" strokeWidth="1"/></g>;
    case 'storm': return <g><ellipse cx="15" cy="14" rx="6" ry="3" fill="#fff"/><polygon points="14,17 18,17 15,21 17,21 13,25 14,21 12,21" fill="#FFD960"/></g>;
    case 'glitch': return <g><rect x="11" y="11" width="10" height="10" fill="#fff"/><rect x="11" y="11" width="10" height="3" fill="#FF6B6B" opacity=".8"/><rect x="11" y="17" width="10" height="2" fill="#2EE6A0" opacity=".8"/><text x="16" y="20" fontSize="8" fill="#06010f" textAnchor="middle" fontWeight="900">?</text></g>;
    case 'spirit': return <g><path d="M11,21 q0,-8 5,-8 q5,0 5,8 q-1.5,-2 -2.5,0 q-1,-2 -2.5,0 q-1,-2 -2.5,0 q-1,-2 -2.5,0Z" fill="#fff" opacity=".9"/><circle cx="14" cy="16" r="1" fill="#06010f"/><circle cx="18" cy="16" r="1" fill="#06010f"/></g>;
    case 'pixel': return <g><rect x="13" y="12" width="2" height="2" fill="#fff"/><rect x="17" y="12" width="2" height="2" fill="#fff"/><rect x="11" y="18" width="2" height="2" fill="#fff"/><rect x="13" y="20" width="6" height="2" fill="#fff"/><rect x="19" y="18" width="2" height="2" fill="#fff"/></g>;
    case 'time': return <g><circle cx="16" cy="16" r="5" fill="none" stroke="#fff" strokeWidth="1.5"/><line x1="16" y1="16" x2="16" y2="12" stroke="#fff" strokeWidth="1.4"/><line x1="16" y1="16" x2="19" y2="17" stroke="#fff" strokeWidth="1.4"/></g>;
    default: return null;
  }
}

function TypeBadge({ type, size = 32 }) {
  const def = TYPE_DEF[type] || TYPE_DEF.Pixel;
  const hex = "16,2 28,8 28,24 16,30 4,24 4,8";
  return (
    <svg className="type-badge" viewBox="0 0 32 32" width={size} height={size} xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id={`tg-${type}`} x1="0" x2="0" y1="0" y2="1">
          <stop offset="0%" stopColor={def.c1} />
          <stop offset="100%" stopColor={def.c2} />
        </linearGradient>
      </defs>
      <polygon className="badge-bg" points={hex} fill={`url(#tg-${type})`} stroke="#06010f" strokeWidth="1.5" />
      <polygon points={hex} fill="none" stroke="rgba(255,255,255,.35)" strokeWidth=".6" transform="translate(0 -0.5)" />
      <TypeSymbol sym={def.sym} />
    </svg>
  );
}

// ─── Type pill (with text label) ────────────────────────────────────────────
function TypePill({ type }) {
  const def = TYPE_DEF[type] || TYPE_DEF.Pixel;
  return (
    <span style={{
      display:'inline-flex',alignItems:'center',gap:6,
      padding:'3px 10px 3px 4px',
      borderRadius:999,
      background:`linear-gradient(90deg, ${def.c1}, ${def.c2})`,
      color:'#06010f',fontWeight:800,fontSize:11,letterSpacing:'.04em',
      border:'1px solid #06010f',boxShadow:'inset 0 1px 0 rgba(255,255,255,.3)',
    }}>
      <TypeBadge type={type} size={20} />
      <span>{type.toUpperCase()}</span>
    </span>
  );
}

// ─── FocusDex logo (wordmark) ───────────────────────────────────────────────
function FocusDexLogo({ size = 1 }) {
  return (
    <svg viewBox="0 0 480 100" width={480*size} height={100*size} xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="lg" x1="0" x2="1" y1="0" y2="0">
          <stop offset="0%" stopColor="#2EE6A0"/>
          <stop offset="35%" stopColor="#47A0FF"/>
          <stop offset="70%" stopColor="#C147FF"/>
          <stop offset="100%" stopColor="#FF6B6B"/>
        </linearGradient>
      </defs>
      <text x="240" y="74" textAnchor="middle" fontFamily="Nunito, sans-serif" fontWeight="900" fontSize="76"
            fill="url(#lg)" stroke="#06010f" strokeWidth="3" paintOrder="stroke">FocusDex</text>
      {/* sparkle on i */}
      <g transform="translate(280 16)"><polygon points="0,0 2,5 7,7 2,9 0,14 -2,9 -7,7 -2,5" fill="#FFD960"/></g>
    </svg>
  );
}

// Make every helper globally available
Object.assign(window, {
  PAL, PixelArt,
  Notchy, NotchyWave, NotchyAlert,
  Codesprite, Codecrawler, Codetitan,
  Inkling, Inkwarden, Inkdragoon,
  Pixibrush, Brushwing, Maestrix,
  Bracketling, Stickynote, Wavelet, Tickbug, Sproutmit,
  FocusBall, GreatBall, UltraBall, MasterBall, QuickBall, PremierBall, NetBall, DreamBall,
  GateSVG, Sigil, StreakFlame, TypeBadge, TypePill, FocusDexLogo, TYPE_DEF,
});
