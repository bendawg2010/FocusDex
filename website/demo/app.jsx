// app.jsx — top-level App: route between screens, expose Tweaks, manage Notch.

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "direction": "notchyverse",
  "starter": "Codesprite",
  "streak": 14,
  "sigilTier": 3
}/*EDITMODE-END*/;

// Route categorization
const WINDOWED_ROUTES = new Set(['dex','trainer']);
const isWindowedRoute = (r) => WINDOWED_ROUTES.has(r) || r.startsWith('creature-');
const FULLSCREEN_OVERLAY = new Set(['title','onb-1','onb-2','onb-3','onb-4','onb-5','lockin','catch','catch-reveal','battle']);

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const [route, setRoute] = React.useState('title');
  const [notchOpen, setNotchOpen] = React.useState(false);
  const [showPopup, setShowPopup] = React.useState(false);

  // session simulation (active only while route === 'lockin')
  const [sessionSec, setSessionSec] = React.useState(45*60 - 132);
  React.useEffect(() => {
    if (route !== 'lockin') return;
    const id = setInterval(() => setSessionSec(s => Math.max(0, s - 1)), 1000);
    return () => clearInterval(id);
  }, [route]);
  const mm = String(Math.floor(sessionSec/60)).padStart(2,'0');
  const ss = String(sessionSec%60).padStart(2,'0');
  const sessionActive = route === 'lockin';
  const sessionLabel = sessionActive ? `${mm}:${ss}` : '';

  const go = (r) => {
    setRoute(r);
    setNotchOpen(false);
    setShowPopup(false);
  };

  // ── Window meta per route ─────────────────────────────────────────────────
  const windowMeta = (r) => {
    if (r === 'dex')         return { title:'Pokédex — The Notchyverse', icon:'📖' };
    if (r === 'trainer')     return { title:'Trainer Card · NV-7104', icon:'🎟' };
    if (r === 'battle')      return { title:'Battle Arena · vs Wild Inkling', icon:'⚔' };
    if (r.startsWith('creature-')) {
      const id = parseInt(r.split('-')[1], 10);
      const c = CREATURES.find(x => x.num === id);
      return { title: `Pokédex · #${String(id).padStart(3,'0')} ${c?.name||''}`, icon:'📖' };
    }
    return { title: 'FocusDex', icon:'📖' };
  };
  const winSize = (r) => {
    if (r === 'trainer') return { width: 620, height: '100%' };
    if (r === 'battle')  return { width: 'min(900px, 96%)', height: '100%' };
    return { width: 'min(820px, 94%)', height: '100%' };
  };

  // ── route → screen content ────────────────────────────────────────────────
  const screenFor = (r) => {
    if (r === 'title')        return <TitleScreen go={go}/>;
    if (r === 'onb-1')        return <Onb1 go={go}/>;
    if (r === 'onb-2')        return <Onb2 go={go} starter={t.starter} setStarter={(s)=>setTweak('starter', s)}/>;
    if (r === 'onb-3')        return <Onb3 go={go}/>;
    if (r === 'onb-4')        return <Onb4 go={go}/>;
    if (r === 'onb-5')        return <Onb5 go={go}/>;
    if (r === 'lockin')       return <LockInScreen go={go} openPopup={()=>setShowPopup(true)} sigilTier={t.sigilTier} remaining={sessionSec}/>;
    if (r === 'catch')        return <CatchScreen go={go}/>;
    if (r === 'catch-reveal') return <CatchRevealScreen go={go}/>;
    if (r === 'dex')          return <DexScreen go={go}/>;
    if (r === 'trainer')      return <TrainerCardScreen go={go}/>;
    if (r === 'battle')       return <BattleScreen go={go}/>;
    if (r.startsWith('creature-')) return <CreatureScreen go={go} creatureId={parseInt(r.split('-')[1],10)}/>;
    return <DesktopScreen/>;
  };

  // ── Render ────────────────────────────────────────────────────────────────
  const showTopBar = !['title','catch','catch-reveal'].includes(route);
  const isDesktop = route === 'desktop';
  const isWindowed = isWindowedRoute(route);
  const isOverlay = FULLSCREEN_OVERLAY.has(route);
  // show the dock on desktop and when a single window is open
  const showDock = isDesktop || isWindowed;

  // notch dropdown menu content
  const notchMenu = (
    <NotchMenu
      sessionActive={sessionActive}
      mm={mm} ss={ss} sessionSec={sessionSec}
      streak={t.streak}
      go={go}
      openDistraction={()=>setShowPopup(true)}
    />
  );

  const winM = windowMeta(route);
  const winS = winSize(route);

  return (
    <div className={`app ${t.direction === 'gameboy' ? 'gb' : ''}`} style={{position:'absolute',inset:0,overflow:'hidden'}}>
      {/* Desktop background ALWAYS visible except for fullscreen overlays that draw their own */}
      {!isOverlay && <DesktopBG/>}

      {/* The macOS top status bar */}
      {showTopBar && <TopBar session={sessionLabel} theme={t.direction === 'gameboy' ? 'gb' : ''}/>}

      {/* Current screen */}
      {isOverlay && screenFor(route)}

      {isDesktop && (
        <DesktopScreen onOpen={go}/>
      )}

      {isWindowed && (
        <div style={{position:'absolute',top:32,left:0,right:0,bottom:78,display:'flex',alignItems:'center',justifyContent:'center',padding:'8px 14px',zIndex:5}}>
          <AppWindow title={winM.title} icon={winM.icon} onClose={()=>go('desktop')} width={winS.width} height={winS.height}>
            {screenFor(route)}
          </AppWindow>
        </div>
      )}

      {/* Dock — shown on desktop + window routes */}
      {showDock && <Dock onOpen={go} route={route}/>}

      {/* The notch (always present, expanded on click) */}
      <Notch
        active={sessionActive}
        time={`${mm}:${ss}`}
        onClick={() => setNotchOpen(o => !o)}
        expanded={notchOpen}
      >
        {notchMenu}
      </Notch>

      {/* Distraction popup */}
      {showPopup && <DistractionPopup onClose={()=>setShowPopup(false)}/>}

      {/* Tweaks panel */}
      <TweaksPanel title="Tweaks">
        <TweakSection label="Visual direction"/>
        <TweakRadio label="" value={t.direction} options={['notchyverse','gameboy']}
                    onChange={(v) => setTweak('direction', v)}/>
        <div style={{fontSize:10,color:'rgba(0,0,0,.55)',lineHeight:1.35,marginTop:-4}}>
          Notchyverse: glossy candy UI on the brand palette. Gameboy: 4-color Gen-1 LCD, the way Notchy meant it.
        </div>

        <TweakSection label="Quick jump"/>
        <div style={{display:'grid',gridTemplateColumns:'1fr 1fr',gap:4}}>
          {[
            ['title','Title'],
            ['onb-1','Onboarding'],
            ['desktop','Desktop'],
            ['lockin','Lock-In'],
            ['catch','Catch'],
            ['catch-reveal','Reveal'],
            ['dex','Pokédex'],
            ['creature-1','Creature'],
            ['trainer','Trainer Card'],
            ['battle','Battle'],
          ].map(([r, label]) => (
            <button key={r} onClick={()=>go(r)} style={{
              appearance:'none',border:0,cursor:'pointer',
              padding:'5px 6px',borderRadius:6,
              background: route===r ? '#29261b' : 'rgba(0,0,0,.06)',
              color: route===r ? '#fff' : '#29261b',
              fontWeight:600,fontSize:10.5,fontFamily:'inherit',
            }}>{label}</button>
          ))}
        </div>

        <TweakSection label="World state"/>
        <TweakRadio label="Sigil tier" value={t.sigilTier}
                    options={[1,2,3,4]}
                    onChange={(v) => setTweak('sigilTier', v)}/>
        <TweakSlider label="Streak (days)" value={t.streak} min={0} max={365} unit="d"
                     onChange={(v) => setTweak('streak', v)}/>
        <TweakButton label="Trigger distraction" onClick={()=>setShowPopup(true)}/>
        <TweakButton label="Toggle Notchy menu" onClick={()=>setNotchOpen(o=>!o)}/>
      </TweaksPanel>
    </div>
  );
}

// ─── Desktop screen — just the wallpaper, with a hint that Notchy lives up there
function DesktopScreen({ onOpen }) {
  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,display:'flex',alignItems:'center',justifyContent:'center',zIndex:1}}>
      {/* Pulsing hint arrow pointing up to the notch */}
      <div style={{textAlign:'center',color:'rgba(255,255,255,.55)',pointerEvents:'none',transform:'translateY(-40px)'}}>
        <div style={{fontSize:11,fontWeight:900,letterSpacing:'.16em',marginBottom:6,color:'#FFD960'}}>↑ NOTCHY LIVES HERE ↑</div>
        <div style={{fontSize:13,fontWeight:700,color:'rgba(255,255,255,.6)',marginBottom:14}}>tap the notch for your session menu</div>
        <div style={{fontSize:11,color:'rgba(255,255,255,.4)'}}>or pick an app from the dock below</div>
      </div>
    </div>
  );
}

// ─── Notchy menubar dropdown ────────────────────────────────────────────────
function NotchMenu({ sessionActive, mm, ss, sessionSec, streak, go, openDistraction }) {
  return (
    <div style={{padding:'14px 16px 12px 16px',width:'100%',color:'#fff',fontFamily:'var(--ui)'}}>
      <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:12}}>
        <div style={{position:'relative'}}>
          {sessionActive ? <NotchyAlert scale={1.7} style={{transform:'translateY(-2px)'}}/> : <Notchy scale={1.7}/>}
          {sessionActive && <div className="pulse" style={{position:'absolute',top:-2,right:-2,width:8,height:8,borderRadius:'50%',background:'#2EE6A0',boxShadow:'0 0 6px #2EE6A0'}}/>}
        </div>
        <div style={{flex:1}}>
          <div style={{fontWeight:900,fontSize:14}}>Professor Notchy</div>
          <div style={{fontSize:10,color: sessionActive ? '#2EE6A0' : '#FFD960',fontWeight:800,letterSpacing:'.04em'}}>{sessionActive ? `ON WATCH · ${mm}:${ss} LEFT` : 'IDLE · READY TO FOCUS'}</div>
        </div>
      </div>

      {sessionActive ? (
        <>
          <div style={{height:5,background:'rgba(255,255,255,.1)',borderRadius:3,overflow:'hidden',marginBottom:8}}>
            <div style={{width:`${(1 - sessionSec/(45*60))*100}%`,height:'100%',background:'linear-gradient(90deg,#C147FF,#2EE6A0)',boxShadow:'0 0 6px #2EE6A0'}}/>
          </div>
          <div style={{display:'flex',justifyContent:'space-between',fontSize:10,fontWeight:700,marginBottom:10}}>
            <span style={{color:'rgba(255,255,255,.55)'}}>focused in</span>
            <span style={{color:'#2EE6A0',fontWeight:800}}>Xcode · FocusDex.xcodeproj</span>
          </div>
          <div style={{display:'flex',gap:6,marginBottom:10}}>
            <button onClick={openDistraction} style={{flex:1,appearance:'none',border:0,cursor:'pointer',padding:'8px',borderRadius:8,background:'rgba(255,107,107,.15)',color:'#FF6B6B',fontWeight:800,fontSize:11}}>Test distraction</button>
            <button onClick={()=>go('catch')} style={{flex:1,appearance:'none',border:0,cursor:'pointer',padding:'8px',borderRadius:8,background:'#2EE6A0',color:'#06010f',fontWeight:900,fontSize:11}}>End early</button>
          </div>
        </>
      ) : (
        <>
          <button onClick={()=>go('lockin')} style={{
            width:'100%',appearance:'none',border:0,cursor:'pointer',padding:'10px',borderRadius:10,
            background:'linear-gradient(180deg,#5cffc1,#2EE6A0)',color:'#06010f',fontWeight:900,fontSize:13,
            boxShadow:'0 0 0 1px #06010f, 0 3px 0 #0a8a5a, inset 0 1px 0 rgba(255,255,255,.6)',marginBottom:10,
            display:'flex',alignItems:'center',justifyContent:'center',gap:6,
          }}>
            <Sigil tier={2} size={16}/> Lock in · 45 min
          </button>
          <div style={{display:'flex',gap:4,marginBottom:10}}>
            {[15,25,50,90].map(m => (
              <button key={m} onClick={()=>go('lockin')} style={{flex:1,appearance:'none',border:0,cursor:'pointer',padding:'6px 4px',borderRadius:6,background:'rgba(255,255,255,.06)',color:'rgba(255,255,255,.7)',fontWeight:800,fontSize:10}}>{m}m</button>
            ))}
          </div>
        </>
      )}

      {/* Ball inventory strip */}
      <div style={{display:'flex',gap:4,marginBottom:10,paddingTop:8,borderTop:'1px solid rgba(255,255,255,.06)'}}>
        {[
          [FocusBall, 4, '#2EE6A0'],
          [GreatBall, 1, '#47A0FF'],
          [UltraBall, 0, '#FFD960'],
          [QuickBall, 1, '#FFD960'],
          [PremierBall, 1, '#FF6B6B'],
        ].map(([B, n, c], i) => (
          <div key={i} style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',gap:2,padding:'4px 2px',background:'rgba(255,255,255,.03)',borderRadius:6}}>
            <B scale={1.5}/>
            <div style={{fontFamily:'JetBrains Mono, monospace',fontWeight:900,fontSize:10,color: n>0 ? c : 'rgba(255,255,255,.3)'}}>×{n}</div>
          </div>
        ))}
      </div>

      {/* Streak + dex completion mini-stats */}
      <div style={{display:'flex',gap:6,marginBottom:10}}>
        <div style={{flex:1,display:'flex',alignItems:'center',gap:4,padding:'5px 8px',background:'rgba(255,107,107,.08)',borderRadius:7}}>
          <StreakFlame tier={2} scale={1.8}/>
          <div>
            <div style={{fontSize:9,fontWeight:800,color:'rgba(255,255,255,.5)',letterSpacing:'.04em'}}>STREAK</div>
            <div style={{fontFamily:'JetBrains Mono, monospace',fontWeight:900,fontSize:12,color:'#FF6B6B'}}>{streak}d</div>
          </div>
        </div>
        <div style={{flex:1,padding:'5px 8px',background:'rgba(46,230,160,.08)',borderRadius:7}}>
          <div style={{fontSize:9,fontWeight:800,color:'rgba(255,255,255,.5)',letterSpacing:'.04em'}}>DEX</div>
          <div style={{fontFamily:'JetBrains Mono, monospace',fontWeight:900,fontSize:12,color:'#2EE6A0'}}>69<span style={{color:'rgba(255,255,255,.4)',fontSize:10}}>/147</span></div>
        </div>
      </div>

      {/* Quick app launchers */}
      <div style={{display:'grid',gridTemplateColumns:'1fr 1fr 1fr',gap:4}}>
        {[
          ['dex','Pokédex','📖'],
          ['trainer','Card','🎟'],
          ['battle','Battle','⚔'],
        ].map(([r,lbl,e]) => (
          <button key={r} onClick={()=>go(r)} style={{appearance:'none',border:0,cursor:'pointer',padding:'7px 4px',borderRadius:7,background:'rgba(255,255,255,.05)',color:'#fff',fontWeight:700,fontSize:10,display:'flex',flexDirection:'column',alignItems:'center',gap:2}}>
            <span style={{fontSize:14}}>{e}</span>{lbl}
          </button>
        ))}
      </div>
    </div>
  );
}

// Mount
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App/>);
