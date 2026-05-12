// components.jsx — shared FocusDex UI components and the creature data model.

// ─── Creature data (subset — full 147 in docs; we feature 24 with details) ──
const CREATURES = [
  { num: 1,  name: 'Codesprite',   types: ['Code','Spirit'], rarity: 'Starter', sprite: 'Codesprite',  stats: {HP:50,FP:70,STA:55,SPD:65}, move: 'Compile Strike', moveDesc: 'Hurls a packet of clean syntax. 25% chance to convert opponent bugs into features.', lore: ["Born the moment a programmer compiles their first working Hello World. Codesprites cling to active editors and feed on successful builds.","During a session, they perch on the corner of your screen and silently count your keystrokes.","Old programmers swear there is a single ur-Codesprite alive since BASIC. Sightings only on full moons."], spawn: 'Code editor, 9am–5pm', evo: [1,2,3] },
  { num: 2,  name: 'Codecrawler',  types: ['Code','Spirit'], rarity: 'Uncommon', sprite: 'Codecrawler', stats: {HP:75,FP:95,STA:75,SPD:75}, move: 'Stack Trace Lash', moveDesc: 'Whips a glowing call stack. Damage scales with opponent turns on field.', lore:[], evo:[1,2,3] },
  { num: 3,  name: 'Codetitan',    types: ['Code','Spirit'], rarity: 'Rare', sprite: 'Codetitan', stats: {HP:95,FP:115,STA:100,SPD:90}, move: 'Kernel Prayer', moveDesc: 'Reboots the battle. Removes all status effects, restores user FP to max.', lore:[], evo:[1,2,3] },
  { num: 4,  name: 'Inkling',      types: ['Doc','Art'],    rarity: 'Starter', sprite: 'Inkling', stats: {HP:60,FP:60,STA:60,SPD:60}, move: 'Margin Note', moveDesc: 'Always crits if user hasn\'t been damaged this battle.', lore: ["Inklings hatch from puddles of ink that pool beneath unfinished drafts.","Bonded Inklings follow your sentences and leave tiny ink-paw prints in the margins.","An Inkling never tastes its own ink — the day it does, a true masterpiece is born."], spawn: 'Writing app, rainy day', evo:[4,5,6] },
  { num: 5,  name: 'Inkwarden',    types: ['Doc','Art'],    rarity: 'Uncommon', sprite: 'Inkwarden', stats: {HP:80,FP:85,STA:85,SPD:70}, move: 'Inkflood', moveDesc: 'Lowers opponent SPD for 3 turns and reveals one hidden ability.', lore:[], evo:[4,5,6] },
  { num: 6,  name: 'Inkdragoon',   types: ['Doc','Art'],    rarity: 'Rare', sprite: 'Inkdragoon', stats: {HP:100,FP:110,STA:100,SPD:90}, move: 'Final Draft', moveDesc: 'Locks opponent out of any move it has used this battle.', lore:[], evo:[4,5,6] },
  { num: 7,  name: 'Pixibrush',    types: ['Art','Pixel'],  rarity: 'Starter', sprite: 'Pixibrush', stats: {HP:55,FP:65,STA:50,SPD:70}, move: 'Palette Swap', moveDesc: 'Randomly steals one of opponent\'s type affinities for 2 turns.', lore: ["Born when a designer commits to a brand color for the first time.","Bonded Pixibrushes hum in the hex code of the color you most recently picked.","Every Pixibrush carries one secret color no monitor can render."], spawn: 'Design app, golden hour', evo:[7,8,9] },
  { num: 8,  name: 'Brushwing',    types: ['Art','Pixel'],  rarity: 'Uncommon', sprite: 'Brushwing', stats: {HP:75,FP:90,STA:70,SPD:90}, move: 'Gradient Dash', moveDesc: 'Hits up to 3 times; each hit raises user SPD.', lore:[], evo:[7,8,9] },
  { num: 9,  name: 'Maestrix',     types: ['Art','Pixel'],  rarity: 'Rare', sprite: 'Maestrix', stats: {HP:90,FP:110,STA:95,SPD:105}, move: 'Magnum Opus', moveDesc: 'Heals fully, then deals damage equal to HP restored. Once per battle.', lore:[], evo:[7,8,9] },
  { num: 25, name: 'Bracketling',  types: ['Code','Pixel'], rarity: 'Common', sprite: 'Bracketling', stats: {HP:55,FP:65,STA:60,SPD:60}, move: 'Scope Snap', moveDesc: 'Double damage vs opponents with Untested/Unsaved/Unread status.', lore: ["Bracketlings hatch from unclosed scope errors.","They love hanging out in indented code blocks, perfectly nested inside a for-loop.","Old engineers claim Bracketlings can taste tabs vs. spaces."], spawn: 'Xcode/VS Code, after 3 saves' },
  { num: 29, name: 'Stickynote',   types: ['Doc','Pixel'],  rarity: 'Common', sprite: 'Stickynote', stats: {HP:55,FP:60,STA:65,SPD:60}, move: 'Reminder Stick', moveDesc: 'Pastes a sticky onto opponent. They must skip their next move.', lore: ["Spawn in clusters and arrange into to-do lists across your desktop.","Finishing a task makes its Stickynote dance for ten seconds.","A trainer once caught one saying \"buy milk\". They never wrote those words."], spawn: 'Notion/Docs, new bullet list' },
  { num: 31, name: 'Wavelet',      types: ['Sound','Pixel'],rarity: 'Common', sprite: 'Wavelet', stats: {HP:55,FP:65,STA:55,SPD:70}, move: 'Loop Trap', moveDesc: 'Opponent\'s last move auto-replays on their next turn.', lore: ["Born when a producer first nods their head to their own beat.","Live inside loop regions and pulse to whatever\'s playing.","Audio engineers swear they migrate toward unmastered tracks."], spawn: 'Logic/Ableton, 5+ loop plays' },
  { num: 39, name: 'Tickbug',      types: ['Code','Spark'], rarity: 'Common', sprite: 'Tickbug', stats: {HP:55,FP:70,STA:55,SPD:80}, move: 'Green Pass', moveDesc: 'Heals self and guarantees next move hits. Stacks on consecutive use.', lore: ["Only emerge when a test suite goes green five-in-a-row.","Catching one feels weirdly emotional — many trainers report tearing up.","Two on the same screen click antennae together and double their pace."], spawn: 'Test suite, 5 passes in a row' },
  { num: 41, name: 'Sproutmit',    types: ['Doc','Zen'],    rarity: 'Common', sprite: 'Sproutmit', stats: {HP:60,FP:60,STA:70,SPD:55}, move: 'Commit Sapling', moveDesc: 'Plants a tree on the field. Each turn it stays, user gains +10 FP.', lore: ["Born when a real commit message is written — none of that \"asdf\" nonsense.","Feel safer in repos with at least one branch besides main.","A Sproutmit remembers every commit you\'ve ever made."], spawn: 'Git commit, message >20 chars' },
];

// silhouettes for the dex grid for not-yet-caught
const ALL_DEX_NUMS = Array.from({length: 60}, (_, i) => i + 1);

// ─── HP / Stat bars ─────────────────────────────────────────────────────────
function HPBar({ current, max, width = 220 }) {
  const pct = Math.max(0, Math.min(100, (current / max) * 100));
  return (
    <div style={{ width, display:'flex', flexDirection:'column', gap:4 }}>
      <div style={{ display:'flex', justifyContent:'space-between', fontSize:11, fontWeight:800, color:'rgba(255,255,255,.85)' }}>
        <span>HP</span><span style={{fontFamily:'JetBrains Mono, monospace'}}>{current}/{max}</span>
      </div>
      <div className="hp"><i style={{ width: `${pct}%` }} /></div>
    </div>
  );
}

function StatRow({ label, value, color = '#2EE6A0', max = 120 }) {
  const pct = Math.min(100, (value / max) * 100);
  return (
    <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:8}}>
      <div style={{width:36,fontSize:11,fontWeight:800,color:'rgba(255,255,255,.7)',letterSpacing:'.04em'}}>{label}</div>
      <div className="stat-bar" style={{flex:1}}>
        <i style={{width:`${pct}%`, background: color, boxShadow:`0 0 8px ${color}66`}}/>
      </div>
      <div style={{width:32,textAlign:'right',fontFamily:'JetBrains Mono, monospace',fontSize:12,fontWeight:700,color:'#fff'}}>{value}</div>
    </div>
  );
}

// ─── Pokeball arsenal (inventory display) ───────────────────────────────────
function BallSlot({ Ball, count, label }) {
  return (
    <div style={{display:'flex',alignItems:'center',gap:8,background:'rgba(255,255,255,.04)',border:'1px solid rgba(255,255,255,.06)',borderRadius:10,padding:'6px 10px'}}>
      <Ball scale={2} />
      <div style={{display:'flex',flexDirection:'column',gap:0}}>
        <div style={{fontSize:10,fontWeight:700,letterSpacing:'.04em',color:'rgba(255,255,255,.5)',textTransform:'uppercase'}}>{label}</div>
        <div style={{fontSize:14,fontWeight:800,fontFamily:'JetBrains Mono, monospace'}}>×{count}</div>
      </div>
    </div>
  );
}

// ─── Tall grass row (for safari background) ─────────────────────────────────
function TallGrass({ count = 26 }) {
  return (
    <div style={{display:'flex',gap:2,alignItems:'flex-end'}}>
      {Array.from({ length: count }).map((_, i) => {
        const h = 14 + (i * 7 % 14);
        const c = i % 3 === 0 ? '#159a6a' : '#2EE6A0';
        return <div key={i} style={{width:6,height:h,background:c,borderTop:'2px solid #06010f',transformOrigin:'bottom',transform:`rotate(${(i%2?-1:1)*(3 + i%5)}deg)`}}/>;
      })}
    </div>
  );
}

// ─── Notchyverse Meadow background (parallax-ish) ───────────────────────────
function MeadowBG() {
  return (
    <div style={{position:'absolute',inset:0,overflow:'hidden'}}>
      {/* sky */}
      <div style={{position:'absolute',inset:0,background:'linear-gradient(180deg, #6b1f7a 0%, #C147FF 40%, #FF6B6B 75%, #FFD960 100%)'}}/>
      <div className="stars-bg" style={{height:'60%'}}/>
      {/* twin moons */}
      <div style={{position:'absolute',top:'14%',right:'22%',width:64,height:64,borderRadius:'50%',background:'#FFD960',boxShadow:'0 0 30px rgba(255,217,96,.5)',border:'2px solid #06010f'}}/>
      <div style={{position:'absolute',top:'18%',right:'16%',width:36,height:36,borderRadius:'50%',background:'#06010f',boxShadow:'4px -2px 0 #FFD960'}}/>
      {/* distant hills */}
      <div style={{position:'absolute',bottom:'34%',left:0,right:0,height:'24%',background:'linear-gradient(180deg, rgba(71,160,255,.45) 0%, rgba(71,160,255,.85) 100%)',clipPath:'polygon(0 60%, 8% 30%, 20% 55%, 32% 20%, 50% 45%, 65% 25%, 80% 50%, 100% 30%, 100% 100%, 0 100%)'}}/>
      {/* meadow path */}
      <div style={{position:'absolute',bottom:0,left:0,right:0,height:'40%',background:'linear-gradient(180deg, #2a6a3a 0%, #1a4a2a 100%)'}}/>
      {/* tall grass front row */}
      <div style={{position:'absolute',bottom:8,left:0,right:0,display:'flex',justifyContent:'center'}}>
        <TallGrass count={48}/>
      </div>
      {/* fireflies */}
      {[...Array(10)].map((_,i)=>(
        <div key={i} className="sparkle" style={{position:'absolute',left:`${5+i*9}%`,top:`${40+(i%4)*8}%`,width:4,height:4,borderRadius:'50%',background:'#2EE6A0',boxShadow:'0 0 8px #2EE6A0',animationDelay:`${i*0.2}s`}}/>
      ))}
    </div>
  );
}

// ─── Top status bar (live like a macOS menubar) ─────────────────────────────
function TopBar({ session, theme }) {
  return (
    <div style={{
      position:'absolute',top:0,left:0,right:0,height:30,
      display:'flex',alignItems:'center',justifyContent:'space-between',
      padding:'0 18px',color:theme==='gb'?'#0f380f':'rgba(255,255,255,.85)',
      fontSize:12,fontWeight:600,zIndex:40,
      background:theme==='gb' ? '#9bbc0f' : 'rgba(0,0,0,.35)',
      backdropFilter:'blur(10px)',
      borderBottom: theme==='gb' ? '2px solid #0f380f' : '1px solid rgba(255,255,255,.06)',
    }}>
      <div style={{display:'flex',alignItems:'center',gap:14}}>
        <span style={{fontWeight:800}}> </span>
        <span>FocusDex</span>
        <span style={{opacity:.55}}>File</span>
        <span style={{opacity:.55}}>Edit</span>
        <span style={{opacity:.55}}>Dex</span>
        <span style={{opacity:.55}}>Help</span>
      </div>
      <div style={{display:'flex',alignItems:'center',gap:14}}>
        {session && (
          <span style={{display:'flex',alignItems:'center',gap:6,color: theme==='gb' ? '#0f380f' : '#2EE6A0'}}>
            <span style={{width:6,height:6,borderRadius:'50%',background:'currentColor',boxShadow:'0 0 6px currentColor'}}/>
            {session}
          </span>
        )}
        <span>Wed 11:42</span>
      </div>
    </div>
  );
}

// ─── The notch (always-visible chrome) ──────────────────────────────────────
function Notch({ active, time, onClick, expanded, children }) {
  return (
    <div className={`notch ${expanded ? 'expanded' : ''}`} onClick={onClick} style={{
      width: expanded ? 380 : 230,
      transition:'width .2s ease, height .2s ease',
      boxShadow: active ? '0 0 0 1px #2EE6A0, 0 0 20px rgba(46,230,160,.4)' : 'none',
    }}>
      <div className="camera"/>
      {!expanded && (
        <div style={{display:'flex',alignItems:'center',gap:8,color:'#fff',fontSize:11,fontWeight:700}}>
          {active && (
            <>
              <div style={{ filter: 'drop-shadow(0 0 6px rgba(46,230,160,.7))'}}>
                <PixelArt grid={[
                  "............",
                  "....mmmm....",
                  "...mLLmmm...",
                  "..mwwmmwwm..",
                  "..mwwmmwwm..",
                  "..mmmmmmmm..",
                  "..mmmmmmmm..",
                  "...mmmmmm...",
                  "....mmmm....",
                  ".....mm.....",
                  "............",
                  "............",
                ]} scale={1.6} />
              </div>
              <span style={{fontFamily:'JetBrains Mono, monospace',color:'#2EE6A0',fontWeight:800}}>{time}</span>
              <div style={{width:2,height:14,background:'rgba(255,255,255,.15)'}}/>
              <span style={{color:'rgba(255,255,255,.7)',fontSize:10}}>locked in</span>
            </>
          )}
          {!active && (
            <>
              <div className="bob">
                <PixelArt grid={[
                  "............",
                  "...KKKKKK...",
                  "..KKKKKKKK..",
                  ".KKwwKKwwK..",
                  ".KKwwKKwwK..",
                  ".KKKKKKKKK..",
                  ".KqqKKKKqq..",
                  "..KKKKKKKK..",
                  "...KKKKKK...",
                  "............",
                  "............",
                  "............",
                ]} scale={1.5} />
              </div>
              <span style={{color:'rgba(255,255,255,.85)',fontSize:10,fontWeight:700,letterSpacing:'.04em'}}>NOTCHY</span>
            </>
          )}
        </div>
      )}
      {expanded && children}
    </div>
  );
}

// ─── Evolution chain row ────────────────────────────────────────────────────
function EvolutionChain({ ids, currentId, theme }) {
  const Sprites = { 1: Codesprite, 2: Codecrawler, 3: Codetitan, 4: Inkling, 5: Inkwarden, 6: Inkdragoon, 7: Pixibrush, 8: Brushwing, 9: Maestrix };
  return (
    <div style={{display:'flex',alignItems:'center',gap:10,justifyContent:'center'}}>
      {ids.map((id, i) => {
        const Sp = Sprites[id];
        const isCur = id === currentId;
        return (
          <React.Fragment key={id}>
            <div style={{
              width:84,height:84,
              background: isCur ? 'radial-gradient(circle, rgba(46,230,160,.18), transparent 70%)' : 'rgba(255,255,255,.04)',
              border: isCur ? '2px solid #2EE6A0' : '1px dashed rgba(255,255,255,.15)',
              borderRadius:12,
              display:'flex',alignItems:'center',justifyContent:'center',
              filter: isCur ? 'none' : 'brightness(0)',
              opacity: isCur ? 1 : .55,
            }}>
              {Sp ? <Sp scale={4}/> : null}
            </div>
            {i < ids.length - 1 && (
              <svg width="22" height="22" viewBox="0 0 22 22"><polygon points="2,8 14,8 14,4 20,11 14,18 14,14 2,14" fill="#C147FF" stroke="#06010f" strokeWidth="1.5"/></svg>
            )}
          </React.Fragment>
        );
      })}
    </div>
  );
}

Object.assign(window, {
  CREATURES, ALL_DEX_NUMS,
  HPBar, StatRow, BallSlot, TallGrass, MeadowBG, TopBar, Notch, EvolutionChain,
  AppWindow, DesktopBG, Dock,
});

// ─── AppWindow (dark macOS window chrome) ───────────────────────────────────
function AppWindow({ title, icon, children, onClose, accent = '#2EE6A0', width, height, style }) {
  return (
    <div className="appwindow screen-fade" style={{
      width: width || 'min(880px, 92%)',
      height: height || '100%',
      maxHeight:'100%',
      background:'rgba(14,8,32,.86)',
      backdropFilter:'blur(28px) saturate(160%)',
      WebkitBackdropFilter:'blur(28px) saturate(160%)',
      borderRadius:14,
      border:'1px solid rgba(255,255,255,.08)',
      boxShadow:'0 1px 0 rgba(255,255,255,.06) inset, 0 30px 60px rgba(0,0,0,.55), 0 8px 30px rgba(0,0,0,.4)',
      display:'flex',flexDirection:'column',overflow:'hidden',
      ...style,
    }}>
      {/* Title bar */}
      <div style={{
        height:38,flexShrink:0,
        display:'flex',alignItems:'center',gap:10,
        padding:'0 14px',
        background:'linear-gradient(180deg, rgba(255,255,255,.04), transparent)',
        borderBottom:'1px solid rgba(255,255,255,.06)',
      }}>
        <div style={{display:'flex',gap:7,alignItems:'center'}}>
          <button onClick={onClose} style={{appearance:'none',border:'.5px solid rgba(0,0,0,.2)',width:13,height:13,borderRadius:'50%',background:'#ff5f57',cursor:'pointer',padding:0}}/>
          <div style={{width:13,height:13,borderRadius:'50%',background:'#febc2e',border:'.5px solid rgba(0,0,0,.2)'}}/>
          <div style={{width:13,height:13,borderRadius:'50%',background:'#28c840',border:'.5px solid rgba(0,0,0,.2)'}}/>
        </div>
        <div style={{flex:1,textAlign:'center',display:'flex',alignItems:'center',justifyContent:'center',gap:8}}>
          {icon && <span style={{display:'flex',alignItems:'center'}}>{icon}</span>}
          <span style={{fontSize:13,fontWeight:700,color:'rgba(255,255,255,.7)',letterSpacing:'.01em'}}>{title}</span>
        </div>
        <div style={{width:50}}/>
      </div>
      {/* Body */}
      <div style={{flex:1,position:'relative',display:'flex',flexDirection:'column',minHeight:0,overflow:'hidden'}}>
        <div style={{position:'absolute',inset:0,display:'flex',flexDirection:'column',overflow:'auto'}}>
          {children}
        </div>
      </div>
    </div>
  );
}

// ─── Desktop background — what the user sees behind windows ────────────────
function DesktopBG() {
  return (
    <div style={{position:'absolute',inset:0,overflow:'hidden'}}>
      {/* deep wallpaper gradient */}
      <div style={{position:'absolute',inset:0,background:
        'radial-gradient(900px 700px at 20% 25%, rgba(193,71,255,.5), transparent 60%), ' +
        'radial-gradient(800px 600px at 80% 75%, rgba(255,107,107,.45), transparent 60%), ' +
        'radial-gradient(600px 500px at 50% 50%, rgba(71,160,255,.35), transparent 60%), ' +
        'linear-gradient(180deg, #1a0830 0%, #2a0b4a 50%, #4a0f5a 100%)' }}/>
      <div className="stars-bg" style={{position:'absolute',inset:0,opacity:.4}}/>
      {/* floating glow blobs */}
      {[
        {x:'15%',y:'70%',c:'#2EE6A0',s:160},
        {x:'85%',y:'30%',c:'#FFD960',s:200},
        {x:'60%',y:'80%',c:'#C147FF',s:180},
      ].map((b,i)=>(
        <div key={i} className="bob" style={{position:'absolute',left:b.x,top:b.y,width:b.s,height:b.s,borderRadius:'50%',background:`radial-gradient(circle, ${b.c}33, transparent 65%)`,animationDelay:`${i*0.7}s`,filter:'blur(8px)'}}/>
      ))}
      {/* pixel hills silhouette at bottom */}
      <div style={{position:'absolute',bottom:0,left:0,right:0,height:80,background:'#0e0820',clipPath:'polygon(0 100%, 0 60%, 8% 30%, 14% 55%, 22% 20%, 30% 50%, 40% 25%, 48% 55%, 56% 30%, 64% 60%, 72% 35%, 82% 55%, 92% 30%, 100% 50%, 100% 100%)'}}/>
    </div>
  );
}

// ─── Dock (bottom of desktop) ───────────────────────────────────────────────
function Dock({ onOpen, route }) {
  const items = [
    { id:'dex',     label:'Pokédex',     emoji:'📖', accent:'#2EE6A0' },
    { id:'trainer', label:'Trainer Card',emoji:'🎟', accent:'#FFD960' },
    { id:'battle',  label:'Battle Arena',emoji:'⚔',  accent:'#FF6B6B' },
    { id:'catch',   label:'Safari',      emoji:'🌿', accent:'#C147FF' },
    { id:'lockin',  label:'Lock In',     emoji:'🔒', accent:'#47A0FF' },
  ];
  return (
    <div style={{
      position:'absolute',bottom:14,left:'50%',transform:'translateX(-50%)',
      display:'flex',gap:8,
      padding:'8px 12px',
      background:'rgba(14,8,32,.55)',
      border:'1px solid rgba(255,255,255,.1)',
      borderRadius:18,
      backdropFilter:'blur(20px)',
      zIndex:20,
      boxShadow:'0 12px 40px rgba(0,0,0,.45), inset 0 1px 0 rgba(255,255,255,.08)',
    }}>
      {items.map(it => {
        const active = route === it.id;
        return (
          <div key={it.id} style={{display:'flex',flexDirection:'column',alignItems:'center',gap:4}}>
            <button onClick={() => onOpen(it.id)} title={it.label} style={{
              appearance:'none',border:0,cursor:'pointer',
              width:48,height:48,borderRadius:12,
              background: active ? `linear-gradient(180deg, ${it.accent}, ${it.accent}aa)` : `rgba(255,255,255,.06)`,
              boxShadow: active ? `0 0 0 1.5px ${it.accent}, 0 8px 20px ${it.accent}55, inset 0 1px 0 rgba(255,255,255,.3)` : '0 4px 0 rgba(0,0,0,.3), inset 0 1px 0 rgba(255,255,255,.1)',
              display:'flex',alignItems:'center',justifyContent:'center',fontSize:22,
              transition:'transform .15s ease, box-shadow .15s ease',
            }}
              onMouseEnter={e=>e.currentTarget.style.transform='translateY(-4px) scale(1.08)'}
              onMouseLeave={e=>e.currentTarget.style.transform='none'}>{it.emoji}</button>
            <div style={{width:4,height:4,borderRadius:'50%',background: active ? '#fff' : 'transparent'}}/>
          </div>
        );
      })}
    </div>
  );
}
