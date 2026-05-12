// screens.jsx — every FocusDex screen, exported on window for app.jsx to wire up.

// ═══ TITLE / SPLASH ════════════════════════════════════════════════════════
function TitleScreen({ go }) {
  return (
    <div className="screen-fade" style={{ position:'absolute', inset:0, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'40px 30px', overflow:'hidden' }}>
      <div style={{position:'absolute',inset:0,background:'linear-gradient(180deg, #06010f 0%, #2a0b4a 35%, #6b1f7a 65%, #FF6B6B 100%)'}}/>
      <div className="stars-bg" style={{position:'absolute',inset:0,opacity:.5}}/>
      {/* sun */}
      <div style={{position:'absolute',bottom:'-8%',left:'50%',transform:'translateX(-50%)',width:300,height:300,borderRadius:'50%',background:'radial-gradient(circle, #FFD960, #FF6B6B 70%, transparent)',opacity:.75,filter:'blur(8px)'}}/>
      {/* distant terminal mountains */}
      <div style={{position:'absolute',bottom:'18%',left:0,right:0,height:90,opacity:.55,
        background:'linear-gradient(180deg, transparent, rgba(6,1,15,.9))',
        clipPath:'polygon(0 100%, 0 60%, 10% 30%, 18% 70%, 26% 20%, 38% 65%, 50% 25%, 62% 60%, 72% 30%, 82% 70%, 92% 35%, 100% 60%, 100% 100%)'}}/>

      <div style={{position:'relative',zIndex:2,display:'flex',flexDirection:'column',alignItems:'center',gap:14, marginTop:30}}>
        <div className="bob"><FocusDexLogo size={0.85}/></div>
        <div style={{fontSize:14,color:'#FFD960',fontWeight:700,letterSpacing:'.06em',textShadow:'0 2px 0 rgba(0,0,0,.4)'}}>Catch your year of work.</div>
      </div>

      {/* Notchy holding a focus ball */}
      <div style={{position:'relative',zIndex:2,display:'flex',alignItems:'center',gap:18,marginTop:24}}>
        <div className="bob"><NotchyWave scale={3}/></div>
        <div style={{transform:'translateY(8px)'}}><FocusBall scale={3.5}/></div>
      </div>

      <div style={{position:'relative',zIndex:2,display:'flex',flexDirection:'column',gap:10,marginTop:30,minWidth:220}}>
        <button className="btn" onClick={() => go('onb-1')}>Start</button>
        <button className="btn magenta" onClick={() => go('desktop')}>Continue</button>
        <button className="btn ghost" onClick={() => go('trainer')}>Trade ID</button>
      </div>

      <div style={{position:'absolute',bottom:14,left:0,right:0,textAlign:'center',fontSize:10,color:'rgba(255,255,255,.45)',letterSpacing:'.08em'}}>v0.1 · MADE IN THE NOTCHYVERSE</div>
    </div>
  );
}

// ═══ ONBOARDING ═════════════════════════════════════════════════════════════
function OnbFrame({ children, dotIdx }) {
  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,overflow:'hidden'}}>
      <div style={{position:'absolute',inset:0,background:'linear-gradient(180deg, #06010f 0%, #2a0b4a 50%, #6b1f7a 100%)'}}/>
      <div className="stars-bg" style={{position:'absolute',inset:0,opacity:.5}}/>
      <div style={{position:'relative',zIndex:1,height:'100%',display:'flex',flexDirection:'column'}}>
        {children}
        <div style={{position:'absolute',bottom:18,left:0,right:0,display:'flex',justifyContent:'center',gap:8}}>
          {[1,2,3,4,5].map(i => (
            <div key={i} style={{width: i===dotIdx?22:6, height:6, borderRadius:999, background: i===dotIdx?'#2EE6A0':'rgba(255,255,255,.25)', transition:'width .2s'}}/>
          ))}
        </div>
      </div>
    </div>
  );
}

function Onb1({ go }) {
  return (
    <OnbFrame dotIdx={1}>
      <div style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',padding:'60px 30px 40px',gap:18}}>
        <div className="bob"><NotchyWave scale={3.5}/></div>
        <h1 style={{margin:0,fontSize:38,fontWeight:900,letterSpacing:'-.02em',textAlign:'center',color:'#fff',textShadow:'0 2px 0 rgba(0,0,0,.4)'}}>Welcome to FocusDex</h1>
        <p style={{margin:0,fontSize:15,fontWeight:600,color:'#2EE6A0',textAlign:'center',maxWidth:380}}>
          I'm Professor Notchy. I live in the notch. Let's catch your year.
        </p>
        <button className="btn" style={{marginTop:14}} onClick={() => go('onb-2')}>Next</button>
      </div>
    </OnbFrame>
  );
}

function Onb2({ go, starter, setStarter }) {
  const opts = [
    { id:'Codesprite', sprite:Codesprite, type:'Code', glow:'#2EE6A0', tagline:'For coders.' },
    { id:'Inkling', sprite:Inkling, type:'Doc', glow:'#C147FF', tagline:'For writers.' },
    { id:'Pixibrush', sprite:Pixibrush, type:'Art', glow:'#FF6B6B', tagline:'For designers.' },
  ];
  return (
    <OnbFrame dotIdx={2}>
      <div style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',padding:'50px 30px 50px'}}>
        <h2 style={{margin:'0 0 6px',fontSize:30,fontWeight:900,textAlign:'center',color:'#fff'}}>Choose your starter</h2>
        <div style={{fontSize:13,color:'#2EE6A0',fontWeight:600,marginBottom:24}}>Your first companion.</div>
        <div style={{display:'flex',gap:14, alignItems:'stretch'}}>
          {opts.map(o => {
            const Sp = o.sprite;
            const selected = starter === o.id;
            return (
              <button key={o.id} onClick={() => setStarter(o.id)} style={{
                appearance:'none',cursor:'pointer',
                width:170,padding:'18px 12px',
                borderRadius:18,
                background: selected ? `radial-gradient(circle at 50% 30%, ${o.glow}22, transparent 70%), rgba(255,255,255,.06)` : 'rgba(255,255,255,.04)',
                border: selected ? `2px solid ${o.glow}` : '1px solid rgba(255,255,255,.08)',
                boxShadow: selected ? `0 0 24px ${o.glow}55` : 'none',
                display:'flex',flexDirection:'column',alignItems:'center',gap:10,
                transition:'all .15s ease',
              }}>
                <div style={{height:90,display:'flex',alignItems:'center',justifyContent:'center', filter: selected?`drop-shadow(0 0 12px ${o.glow})`:''}}>
                  <Sp scale={4}/>
                </div>
                <TypeBadge type={o.type} size={28}/>
                <div style={{fontSize:13,fontWeight:900,color:'#fff'}}>{o.id}</div>
                <div style={{fontSize:11,color:'rgba(255,255,255,.55)'}}>{o.tagline}</div>
              </button>
            );
          })}
        </div>
        <div style={{display:'flex',gap:10,marginTop:'auto',paddingTop:28}}>
          <button className="btn ghost" onClick={() => go('onb-1')}>Back</button>
          <button className="btn magenta" onClick={() => go('onb-3')} disabled={!starter}>Confirm</button>
        </div>
      </div>
    </OnbFrame>
  );
}

function Onb3({ go }) {
  return (
    <OnbFrame dotIdx={3}>
      <div style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',padding:'50px 30px',gap:18}}>
        <h2 style={{margin:0,fontSize:30,fontWeight:900,color:'#fff',textAlign:'center'}}>How focus earns balls</h2>
        <div style={{fontSize:13,color:'#2EE6A0',fontWeight:600}}>Real work → real loot.</div>

        <div style={{display:'flex',alignItems:'center',gap:14,marginTop:24}}>
          {/* Step 1 */}
          <div className="card" style={{padding:'16px 14px',width:140,textAlign:'center'}}>
            <div style={{width:60,height:60,margin:'0 auto 8px',borderRadius:14,background:'linear-gradient(180deg,#47A0FF,#2a64a8)',display:'flex',alignItems:'center',justifyContent:'center',fontSize:28}}>💻</div>
            <div style={{fontSize:11,fontWeight:900,letterSpacing:'.06em',color:'rgba(255,255,255,.55)',marginBottom:4}}>STEP 1</div>
            <div style={{fontSize:13,fontWeight:800,color:'#fff'}}>Focus in a real app</div>
          </div>
          <svg width="24" height="14" viewBox="0 0 24 14"><polygon points="0,5 18,5 18,1 24,7 18,13 18,9 0,9" fill="#2EE6A0" stroke="#06010f" strokeWidth="1"/></svg>
          {/* Step 2 */}
          <div className="card" style={{padding:'16px 14px',width:140,textAlign:'center'}}>
            <div style={{width:60,height:60,margin:'0 auto 8px',borderRadius:'50%',background:'conic-gradient(#2EE6A0 0% 70%, rgba(255,255,255,.1) 70% 100%)',display:'flex',alignItems:'center',justifyContent:'center'}}>
              <div style={{width:46,height:46,borderRadius:'50%',background:'#06010f',display:'flex',alignItems:'center',justifyContent:'center',color:'#2EE6A0',fontWeight:900,fontSize:14,fontFamily:'JetBrains Mono, monospace'}}>70%</div>
            </div>
            <div style={{fontSize:11,fontWeight:900,letterSpacing:'.06em',color:'rgba(255,255,255,.55)',marginBottom:4}}>STEP 2</div>
            <div style={{fontSize:13,fontWeight:800,color:'#fff'}}>Build Focus Energy</div>
          </div>
          <svg width="24" height="14" viewBox="0 0 24 14"><polygon points="0,5 18,5 18,1 24,7 18,13 18,9 0,9" fill="#2EE6A0" stroke="#06010f" strokeWidth="1"/></svg>
          {/* Step 3 */}
          <div className="card" style={{padding:'16px 14px',width:140,textAlign:'center'}}>
            <div style={{width:60,height:60,margin:'0 auto 8px',display:'flex',alignItems:'center',justifyContent:'center'}}><FocusBall scale={3.2}/></div>
            <div style={{fontSize:11,fontWeight:900,letterSpacing:'.06em',color:'rgba(255,255,255,.55)',marginBottom:4}}>STEP 3</div>
            <div style={{fontSize:13,fontWeight:800,color:'#fff'}}>Earn Pokeballs</div>
          </div>
        </div>

        <div className="card" style={{marginTop:14,padding:'10px 14px',fontSize:12,color:'rgba(255,255,255,.7)',display:'flex',alignItems:'center',gap:8}}>
          <div style={{width:6,height:6,borderRadius:'50%',background:'#2EE6A0',boxShadow:'0 0 6px #2EE6A0'}}/>
          5 min = 1 Focus · 25 min = 1 Great · 90 min = 1 Ultra · 8 hr = 1 Master
        </div>

        <div style={{display:'flex',gap:10,marginTop:'auto',paddingTop:14}}>
          <button className="btn ghost" onClick={() => go('onb-2')}>Back</button>
          <button className="btn" onClick={() => go('onb-4')}>Got it</button>
        </div>
      </div>
    </OnbFrame>
  );
}

function Onb4({ go }) {
  return (
    <OnbFrame dotIdx={4}>
      <div style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',padding:'40px 30px 50px'}}>
        <h2 style={{margin:0,fontSize:30,fontWeight:900,color:'#fff',textAlign:'center'}}>Catch on your breaks</h2>
        <div style={{fontSize:13,color:'#2EE6A0',fontWeight:600,marginBottom:24}}>Spend Pokeballs between sessions.</div>

        <div style={{display:'flex',gap:16,alignItems:'flex-start',width:'100%',maxWidth:640}}>
          {/* Safari preview */}
          <div className="card" style={{flex:1,height:260,position:'relative',overflow:'hidden',borderRadius:16}}>
            <MeadowBG/>
            <div style={{position:'absolute',top:'34%',left:'50%',transform:'translateX(-50%)'}}>
              <div className="bob"><Codesprite scale={4}/></div>
            </div>
            {/* dotted throw arc */}
            <svg style={{position:'absolute',inset:0,pointerEvents:'none'}} viewBox="0 0 400 260">
              <path d="M340,240 Q220,80 180,140" stroke="#fff" strokeWidth="2" strokeDasharray="4 4" fill="none"/>
            </svg>
            <div style={{position:'absolute',bottom:18,right:24,filter:'drop-shadow(0 4px 8px rgba(0,0,0,.4))'}}>
              <FocusBall scale={3}/>
            </div>
          </div>

          {/* inventory */}
          <div style={{display:'flex',flexDirection:'column',gap:6,minWidth:160}}>
            <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:2}}>INVENTORY</div>
            <BallSlot Ball={FocusBall} count={3} label="Focus"/>
            <BallSlot Ball={QuickBall} count={1} label="Quick"/>
            <BallSlot Ball={PremierBall} count={1} label="Premier"/>
            <BallSlot Ball={NetBall} count={0} label="Net"/>
          </div>
        </div>

        <div style={{display:'flex',gap:10,marginTop:'auto',paddingTop:22}}>
          <button className="btn ghost" onClick={() => go('onb-3')}>Back</button>
          <button className="btn" onClick={() => go('onb-5')}>Got it</button>
        </div>
      </div>
    </OnbFrame>
  );
}

function Onb5({ go }) {
  const [dur, setDur] = React.useState(25);
  return (
    <OnbFrame dotIdx={5}>
      <div style={{flex:1,display:'flex',flexDirection:'column',alignItems:'center',padding:'40px 30px 50px'}}>
        <h2 style={{margin:0,fontSize:30,fontWeight:900,color:'#fff',textAlign:'center'}}>Ready for your first session?</h2>
        <div style={{fontSize:13,color:'#2EE6A0',fontWeight:600,marginBottom:14}}>Pick a duration. I'll watch your progress.</div>

        {/* Timer dial */}
        <div className="card" style={{padding:24,display:'flex',flexDirection:'column',alignItems:'center',gap:14,minWidth:340}}>
          <div className="timer-ring" style={{width:200,height:200,position:'relative'}}>
            <svg viewBox="0 0 100 100" width="200" height="200">
              <circle cx="50" cy="50" r="45" fill="none" stroke="rgba(255,255,255,.08)" strokeWidth="6"/>
              <circle cx="50" cy="50" r="45" fill="none" stroke="#2EE6A0" strokeWidth="6" strokeDasharray="282.7" strokeDashoffset={282.7*(1 - dur/120)} transform="rotate(-90 50 50)" strokeLinecap="round" style={{filter:'drop-shadow(0 0 6px #2EE6A0)'}}/>
              {[...Array(60)].map((_,i)=>{const a=(i/60)*Math.PI*2;return <line key={i} x1={50+Math.cos(a)*38} y1={50+Math.sin(a)*38} x2={50+Math.cos(a)*42} y2={50+Math.sin(a)*42} stroke="rgba(255,255,255,.18)" strokeWidth={i%5===0?1:.4}/>})}
            </svg>
            <div style={{position:'absolute',inset:0,display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center'}}>
              <div style={{fontSize:44,fontWeight:900,fontFamily:'JetBrains Mono, monospace',color:'#fff'}}>{String(dur).padStart(2,'0')}:00</div>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.12em',color:'#2EE6A0'}}>FOCUS</div>
            </div>
          </div>
          <div style={{display:'flex',gap:8}}>
            {[15,25,50,90].map(m => (
              <button key={m} onClick={()=>setDur(m)} style={{
                appearance:'none',border:0,cursor:'pointer',
                padding:'8px 14px',borderRadius:999,fontWeight:900,fontSize:12,
                background: dur===m?'linear-gradient(180deg,#dc7bff,#C147FF)':'rgba(255,255,255,.06)',
                color: dur===m?'#fff':'rgba(255,255,255,.7)',
                boxShadow: dur===m?'0 0 0 1px #06010f, 0 2px 0 #6a1aa0':'inset 0 0 0 1px rgba(255,255,255,.1)',
              }}>{m} min</button>
            ))}
          </div>
          <div style={{display:'flex',alignItems:'center',gap:8,padding:'6px 10px',background:'rgba(255,255,255,.04)',border:'1px solid rgba(255,255,255,.08)',borderRadius:10}}>
            <div style={{width:22,height:22,borderRadius:5,background:'linear-gradient(135deg,#47A0FF,#C147FF)',display:'flex',alignItems:'center',justifyContent:'center',fontSize:12}}>⌘</div>
            <div style={{fontSize:12,fontWeight:700}}>Focus in: <span style={{color:'#2EE6A0'}}>Xcode</span></div>
            <svg width="10" height="10" viewBox="0 0 10 10"><path d="M1,3 L5,7 L9,3" fill="none" stroke="rgba(255,255,255,.5)" strokeWidth="1.5"/></svg>
          </div>
        </div>

        <div style={{display:'flex',gap:10,marginTop:'auto',paddingTop:14}}>
          <button className="btn ghost" onClick={() => go('onb-4')}>Back</button>
          <button className="btn" onClick={() => go('lockin')}>Start Focusing</button>
        </div>
      </div>
    </OnbFrame>
  );
}

// ═══ LOCK-IN ════════════════════════════════════════════════════════════════
function LockInScreen({ go, openPopup, sigilTier = 3, remaining = 2568 }) {
  const mm = String(Math.floor(remaining/60)).padStart(2,'0');
  const ss = String(remaining%60).padStart(2,'0');
  const total = 45*60;
  const pct = (1 - remaining/total) * 100;
  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,overflow:'hidden'}}>
      <div style={{position:'absolute',inset:0,background:'radial-gradient(800px 600px at 50% 35%, rgba(193,71,255,.25), transparent 70%), linear-gradient(180deg, #06010f 0%, #15082a 100%)'}}/>
      <div className="stars-bg" style={{position:'absolute',inset:0,opacity:.4}}/>

      <div style={{position:'relative',height:'100%',display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',padding:'40px 30px',gap:18}}>
        <div style={{fontSize:11,fontWeight:900,letterSpacing:'.2em',color:'#C147FF'}}>THE GATE HOLDS</div>

        <div style={{display:'flex',alignItems:'center',gap:30}}>
          {/* Notchy at gate base */}
          <div style={{display:'flex',flexDirection:'column',alignItems:'center',gap:6}}>
            <Notchy scale={2.6}/>
            <div className="pill" style={{background:'rgba(46,230,160,.15)',borderColor:'#2EE6A0',color:'#2EE6A0'}}>ON WATCH</div>
          </div>

          {/* Gate */}
          <div style={{position:'relative'}}>
            <GateSVG state="sealed" width={300} height={250}/>
          </div>

          {/* Side panel */}
          <div style={{display:'flex',flexDirection:'column',gap:10,minWidth:170}}>
            <div className="pill" style={{background:'rgba(255,217,96,.12)',borderColor:'rgba(255,217,96,.4)',color:'#FFD960'}}>
              <Sigil tier={sigilTier} size={14}/> ZEN SIGIL · 45 MIN
            </div>
            <div className="card" style={{padding:'10px 12px'}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:4}}>BLOCKED</div>
              <div style={{display:'flex',gap:6,flexWrap:'wrap'}}>
                {['🐦','📺','💬','🎮','📰'].map((e,i)=>(
                  <div key={i} style={{width:28,height:28,borderRadius:7,background:'rgba(255,255,255,.06)',display:'flex',alignItems:'center',justifyContent:'center',fontSize:16,position:'relative'}}>
                    {e}
                    <div style={{position:'absolute',inset:0,borderRadius:7,background:'rgba(193,71,255,.18)',border:'1px solid #C147FF'}}/>
                  </div>
                ))}
              </div>
            </div>
            <div className="card" style={{padding:'10px 12px'}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:4}}>SPAWNING</div>
              <div style={{display:'flex',gap:4,alignItems:'center'}}>
                <div style={{filter:'brightness(0)',opacity:.4}}><Codesprite scale={1.5}/></div>
                <div style={{filter:'brightness(0)',opacity:.4}}><Bracketling scale={1.5}/></div>
                <div style={{filter:'brightness(0)',opacity:.4}}><Tickbug scale={1.5}/></div>
                <div style={{filter:'brightness(0)',opacity:.4}}><Sproutmit scale={1.5}/></div>
                <div style={{fontSize:11,color:'rgba(255,255,255,.5)',marginLeft:4,fontWeight:700}}>+ 3</div>
              </div>
            </div>
          </div>
        </div>

        {/* Big timer */}
        <div style={{display:'flex',flexDirection:'column',alignItems:'center',gap:6}}>
          <div style={{fontSize:64,fontWeight:900,fontFamily:'JetBrains Mono, monospace',color:'#fff',letterSpacing:'-.02em',textShadow:'0 0 30px rgba(46,230,160,.4)'}}>{mm}:{ss}</div>
          <div style={{width:360,height:4,background:'rgba(255,255,255,.08)',borderRadius:2,overflow:'hidden'}}>
            <div style={{width:`${pct}%`,height:'100%',background:'linear-gradient(90deg,#C147FF,#2EE6A0)',boxShadow:'0 0 8px #2EE6A0'}}/>
          </div>
          <div style={{fontSize:11,fontWeight:700,color:'rgba(255,255,255,.55)',marginTop:2}}>focusing in <span style={{color:'#2EE6A0'}}>Xcode · FocusDex.xcodeproj</span></div>
        </div>

        <div style={{display:'flex',gap:10,marginTop:4}}>
          <button className="btn ghost" onClick={openPopup}>Simulate distraction</button>
          <button className="btn magenta" onClick={() => go('catch')}>Skip to end →</button>
        </div>
      </div>
    </div>
  );
}

// distraction popup overlay
function DistractionPopup({ onClose }) {
  return (
    <div className="screen-fade" style={{position:'absolute',top:42,left:'50%',transform:'translateX(-50%)',zIndex:100,width:480}}>
      <div style={{
        background:'rgba(6,1,15,.92)',
        border:'1.5px solid #C147FF',
        borderRadius:18,
        padding:'14px 16px',
        display:'flex',gap:14,alignItems:'center',
        boxShadow:'0 0 40px rgba(193,71,255,.5), 0 20px 60px rgba(0,0,0,.6)',
        backdropFilter:'blur(20px)',
      }}>
        <div style={{flexShrink:0}}><NotchyAlert scale={2.4}/></div>
        <div style={{flex:1}}>
          <div style={{fontSize:18,fontWeight:900,color:'#2EE6A0',marginBottom:2}}>You're locked in.</div>
          <div style={{fontSize:12,color:'#FFD960',fontWeight:700,marginBottom:8}}>The gate holds.</div>
          <div style={{height:6,background:'rgba(193,71,255,.2)',borderRadius:3,overflow:'hidden'}}>
            <div style={{width:'42%',height:'100%',background:'#2EE6A0',boxShadow:'0 0 6px #2EE6A0'}}/>
          </div>
          <div style={{fontSize:10,color:'rgba(255,255,255,.55)',marginTop:4,display:'flex',justifyContent:'space-between'}}>
            <span>Twitter blocked</span><span style={{fontFamily:'JetBrains Mono, monospace'}}>26:14 remaining</span>
          </div>
        </div>
        <div style={{display:'flex',flexDirection:'column',alignItems:'center',gap:4}}>
          <Sigil tier={3} size={36}/>
          <button onClick={onClose} style={{appearance:'none',border:0,background:'transparent',color:'rgba(255,255,255,.4)',fontSize:11,fontWeight:700,cursor:'pointer'}}>dismiss</button>
        </div>
      </div>
    </div>
  );
}

// ═══ CATCH / SAFARI ═════════════════════════════════════════════════════════
function CatchScreen({ go, onCatch }) {
  const [phase, setPhase] = React.useState('idle'); // idle | throwing | flash | wobble1 | wobble2 | wobble3 | caught
  const [selectedBall, setSelectedBall] = React.useState('focus');
  const Balls = { focus: FocusBall, quick: QuickBall, premier: PremierBall, net: NetBall };
  const Ball = Balls[selectedBall];

  const throwBall = () => {
    if (phase !== 'idle') return;
    setPhase('throwing');
    setTimeout(() => setPhase('flash'), 700);
    setTimeout(() => setPhase('wobble1'), 950);
    setTimeout(() => setPhase('wobble2'), 1500);
    setTimeout(() => setPhase('wobble3'), 2050);
    setTimeout(() => { setPhase('caught'); onCatch?.(); }, 2700);
  };

  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,overflow:'hidden'}}>
      <MeadowBG/>

      {/* HUD top */}
      <div style={{position:'absolute',top:42,left:18,right:18,display:'flex',justifyContent:'space-between',alignItems:'flex-start',zIndex:5}}>
        <div className="card" style={{padding:'8px 12px',display:'flex',alignItems:'center',gap:8,background:'rgba(6,1,15,.6)'}}>
          <div style={{width:8,height:8,borderRadius:'50%',background:'#2EE6A0',boxShadow:'0 0 6px #2EE6A0'}}/>
          <span style={{fontSize:11,fontWeight:900,letterSpacing:'.06em'}}>SAFARI MODE</span>
          <span style={{color:'rgba(255,255,255,.5)',fontSize:11}}>· Notchyverse Meadow</span>
        </div>
        <button className="btn ghost" style={{padding:'6px 12px',fontSize:11}} onClick={()=>go('desktop')}>Leave Safari</button>
      </div>

      {/* wild creature */}
      {phase !== 'caught' && (
        <div style={{position:'absolute',top:'30%',left:'50%',transform:'translateX(-50%)',zIndex:3}}>
          <div className={phase==='idle'?'bob':''} style={{filter: phase==='flash'?'brightness(0) invert(1) drop-shadow(0 0 30px #fff)':'none', transition:'filter .15s', opacity: phase==='flash'||phase==='wobble1'||phase==='wobble2'||phase==='wobble3'?0.0:1}}>
            <Codesprite scale={5}/>
          </div>
          {/* HP bar above wild */}
          {phase==='idle' && (
            <div style={{position:'absolute',top:-44,left:'50%',transform:'translateX(-50%)'}}>
              <div style={{background:'rgba(6,1,15,.7)',border:'1px solid rgba(255,255,255,.1)',borderRadius:10,padding:'6px 10px',minWidth:180}}>
                <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:4}}>
                  <span style={{fontSize:12,fontWeight:900,color:'#fff'}}>Wild Codesprite</span>
                  <TypeBadge type="Code" size={18}/>
                </div>
                <HPBar current={42} max={50} width={170}/>
              </div>
            </div>
          )}
        </div>
      )}

      {/* thrown ball */}
      {(phase==='throwing'||phase==='wobble1'||phase==='wobble2'||phase==='wobble3'||phase==='caught') && (
        <div style={{
          position:'absolute',
          left: phase==='throwing' ? '50%' : '50%',
          top: phase==='throwing' ? '36%' : '38%',
          transform:`translateX(-50%) ${
            phase==='wobble1'?'rotate(-15deg)':
            phase==='wobble2'?'rotate(18deg)':
            phase==='wobble3'?'rotate(-10deg)':''
          }`,
          transition: phase==='throwing'?'top .7s cubic-bezier(.3,1.4,.6,1), left .7s ease':'transform .25s ease',
          zIndex:4,
          filter: phase==='caught' ? 'drop-shadow(0 0 14px #2EE6A0)' : ''
        }}>
          <Ball scale={4}/>
        </div>
      )}

      {/* throw trail */}
      {phase==='throwing' && (
        <svg style={{position:'absolute',inset:0,pointerEvents:'none',zIndex:2}} viewBox="0 0 800 500">
          <path d="M620,420 Q400,150 400,200" stroke="#FF6B6B" strokeWidth="3" strokeDasharray="4 6" fill="none" opacity=".6"/>
        </svg>
      )}

      {/* flash effect */}
      {phase==='flash' && (
        <div style={{position:'absolute',inset:0,background:'radial-gradient(circle at 50% 36%, #fff 0%, transparent 30%)',zIndex:6,pointerEvents:'none'}}/>
      )}

      {/* caught burst */}
      {phase==='caught' && (
        <div style={{position:'absolute',top:'30%',left:'50%',transform:'translateX(-50%)',zIndex:5}}>
          {[...Array(6)].map((_,i)=>{
            const a=(i/6)*Math.PI*2;
            return <div key={i} className="sparkle" style={{position:'absolute',left:Math.cos(a)*60,top:Math.sin(a)*60,width:8,height:8,background:'#FFD960',clipPath:'polygon(50% 0,60% 40%,100% 50%,60% 60%,50% 100%,40% 60%,0 50%,40% 40%)',animationDelay:`${i*0.1}s`}}/>;
          })}
        </div>
      )}

      {/* Caught banner */}
      {phase==='caught' && (
        <div style={{position:'absolute',top:'30%',left:'50%',transform:'translateX(-50%) translateY(-90px)',zIndex:7}}>
          <div style={{
            padding:'10px 22px',background:'linear-gradient(180deg,#2EE6A0,#159a6a)',
            border:'2px solid #06010f',borderRadius:14,
            fontWeight:900,letterSpacing:'.08em',fontSize:18,color:'#06010f',
            boxShadow:'0 6px 0 #0a8a5a, 0 12px 30px rgba(46,230,160,.5)',
            display:'flex',alignItems:'center',gap:8
          }}>CAUGHT! ✨</div>
        </div>
      )}

      {/* Bottom control bar */}
      <div style={{position:'absolute',bottom:18,left:18,right:18,zIndex:5,display:'flex',gap:10,alignItems:'flex-end'}}>
        {/* ball select */}
        <div className="card" style={{padding:10,display:'flex',gap:6,background:'rgba(6,1,15,.7)'}}>
          {[
            ['focus','Focus',FocusBall,3],
            ['quick','Quick',QuickBall,1],
            ['premier','Premier',PremierBall,1],
            ['net','Net',NetBall,2],
          ].map(([id,lbl,B,n]) => (
            <button key={id} onClick={()=>setSelectedBall(id)} style={{
              appearance:'none',border:0,cursor:'pointer',
              padding:8,borderRadius:10,
              background: selectedBall===id?'rgba(46,230,160,.18)':'transparent',
              boxShadow: selectedBall===id?'inset 0 0 0 1.5px #2EE6A0':'inset 0 0 0 1px rgba(255,255,255,.08)',
              display:'flex',flexDirection:'column',alignItems:'center',gap:2,
            }}>
              <B scale={2}/>
              <span style={{fontSize:9,fontWeight:900,color: selectedBall===id?'#2EE6A0':'rgba(255,255,255,.5)'}}>{lbl} ·{n}</span>
            </button>
          ))}
        </div>
        {/* big throw button */}
        <button className="btn pink" onClick={throwBall} disabled={phase!=='idle'} style={{flex:1,padding:'14px',fontSize:15}}>
          {phase==='idle' ? '▶  Throw '+Ball.name : phase==='caught' ? '✓  Continue' : 'Wobbling…'}
        </button>
        {phase==='caught' && (
          <button className="btn" onClick={()=>go('catch-reveal')} style={{padding:'14px'}}>See card →</button>
        )}
      </div>
    </div>
  );
}

// ═══ POST-CATCH REVEAL ══════════════════════════════════════════════════════
function CatchRevealScreen({ go }) {
  const c = CREATURES[0];
  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,overflow:'hidden'}}>
      <MeadowBG/>
      <div style={{position:'absolute',inset:0,background:'radial-gradient(circle at 50% 50%, rgba(0,0,0,.4), rgba(0,0,0,.8))'}}/>

      <div style={{position:'relative',height:'100%',display:'flex',alignItems:'center',justifyContent:'center',padding:30}}>
        <div className="card" style={{padding:0,width:540,overflow:'hidden',animation:'slideUp .5s cubic-bezier(.3,1.4,.6,1)'}}>
          {/* Sprite window */}
          <div style={{height:200,background:'radial-gradient(circle, rgba(46,230,160,.25), transparent 65%), linear-gradient(180deg,#1a0a3a,#06010f)',display:'flex',alignItems:'center',justifyContent:'center',position:'relative',borderBottom:'1px solid rgba(255,255,255,.06)'}}>
            <div className="bob" style={{filter:'drop-shadow(0 0 20px rgba(46,230,160,.5))'}}><Codesprite scale={7}/></div>
            {/* corner sparkles */}
            {[[12,12],[12,'auto'],['auto',12],['auto','auto']].map((p,i)=>(
              <div key={i} className="sparkle" style={{
                position:'absolute',
                left: p[0]==='auto'?'auto':p[0], right: p[0]==='auto'?12:'auto',
                top:  p[1]==='auto'?'auto':p[1], bottom: p[1]==='auto'?12:'auto',
                width:12,height:12,background:'#FFD960',clipPath:'polygon(50% 0,60% 40%,100% 50%,60% 60%,50% 100%,40% 60%,0 50%,40% 40%)',
                animationDelay:`${i*0.15}s`}}/>
            ))}
          </div>
          {/* Info */}
          <div style={{padding:'20px 24px'}}>
            <div style={{fontFamily:'JetBrains Mono, monospace',fontSize:13,color:'#FF6B6B',fontWeight:800,marginBottom:4}}>#{String(c.num).padStart(3,'0')}</div>
            <h2 style={{margin:'0 0 10px',fontSize:34,fontWeight:900,color:'#2EE6A0',letterSpacing:'-.02em'}}>{c.name}</h2>
            <div style={{display:'flex',gap:6,marginBottom:14}}>
              {c.types.map(t => <TypePill key={t} type={t}/>)}
            </div>
            <div style={{fontSize:12,color:'#FFD960',marginBottom:14}}>
              Caught Wed 11:54 · while focusing on <span style={{fontWeight:800}}>FocusDex.xcodeproj</span>
            </div>
            <div style={{display:'grid',gridTemplateColumns:'1fr 1fr',gap:8,marginBottom:16}}>
              {[['HP',c.stats.HP,'#FF6B6B'],['FP',c.stats.FP,'#C147FF'],['STA',c.stats.STA,'#47A0FF'],['SPD',c.stats.SPD,'#2EE6A0']].map(([l,v,c2]) => (
                <div key={l} style={{display:'flex',alignItems:'center',gap:6,padding:'4px 8px',background:'rgba(255,255,255,.04)',borderRadius:8}}>
                  <span style={{fontSize:10,fontWeight:900,letterSpacing:'.06em',color:'rgba(255,255,255,.55)'}}>{l}</span>
                  <div style={{flex:1,height:5,background:'rgba(255,255,255,.06)',borderRadius:3,overflow:'hidden'}}>
                    <div style={{width:`${v/120*100}%`,height:'100%',background:c2}}/>
                  </div>
                  <span style={{fontFamily:'JetBrains Mono, monospace',fontSize:11,fontWeight:800,minWidth:18,textAlign:'right'}}>{v}</span>
                </div>
              ))}
            </div>
            <div style={{display:'flex',gap:10}}>
              <button className="btn" style={{flex:1}} onClick={()=>go('creature-1')}>View Dex entry</button>
              <button className="btn ghost" onClick={()=>go('desktop')}>Continue</button>
            </div>
          </div>
        </div>
      </div>
      <style>{`@keyframes slideUp{from{transform:translateY(40px);opacity:0}to{transform:none;opacity:1}}`}</style>
    </div>
  );
}

// ═══ POKÉDEX ════════════════════════════════════════════════════════════════
function DexScreen({ go }) {
  const [filter, setFilter] = React.useState('all');
  const Sprites = {
    1: Codesprite, 2: Codecrawler, 3: Codetitan, 4: Inkling, 5: Inkwarden, 6: Inkdragoon,
    7: Pixibrush, 8: Brushwing, 9: Maestrix,
    25: Bracketling, 29: Stickynote, 31: Wavelet, 39: Tickbug, 41: Sproutmit,
  };
  const caughtIds = new Set([1,4,7,25,29,31,39,41,8]);

  const cells = ALL_DEX_NUMS.slice(0, 50).map(n => {
    const c = CREATURES.find(c => c.num === n);
    const caught = caughtIds.has(n);
    const Sp = Sprites[n];
    return { n, c, caught, Sp };
  });

  const totalCaught = 69;   // narrative-consistent with trainer card 47%
  const totalDex = 147;
  const pct = 47;

  return (
    <div style={{width:'100%',height:'100%',display:'flex',flexDirection:'column'}}>
      {/* Header */}
      <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',padding:'12px 20px 8px',flexShrink:0}}>
        <div>
          <div style={{fontSize:10,fontWeight:900,letterSpacing:'.12em',color:'rgba(255,255,255,.5)'}}>YOUR POKÉDEX</div>
          <h1 style={{margin:'2px 0',fontSize:26,fontWeight:900,letterSpacing:'-.02em'}}>The Notchyverse</h1>
        </div>
        <div style={{display:'flex',alignItems:'center',gap:14}}>
          <div style={{display:'flex',flexDirection:'column',alignItems:'flex-end',gap:2}}>
            <div style={{fontSize:10,color:'rgba(255,255,255,.55)',fontWeight:700}}>caught</div>
            <div style={{fontFamily:'JetBrains Mono, monospace',fontWeight:900,fontSize:22,color:'#2EE6A0'}}>{totalCaught}<span style={{color:'rgba(255,255,255,.3)',fontSize:14}}> / {totalDex}</span></div>
          </div>
          <div style={{position:'relative',width:54,height:54}}>
            <svg viewBox="0 0 36 36" width="54" height="54">
              <circle cx="18" cy="18" r="15" fill="none" stroke="rgba(255,255,255,.08)" strokeWidth="3"/>
              <circle cx="18" cy="18" r="15" fill="none" stroke="#2EE6A0" strokeWidth="3" strokeDasharray="94.2" strokeDashoffset={94.2*(1-pct/100)} transform="rotate(-90 18 18)" strokeLinecap="round"/>
            </svg>
            <div style={{position:'absolute',inset:0,display:'flex',alignItems:'center',justifyContent:'center',fontSize:11,fontWeight:900,fontFamily:'JetBrains Mono, monospace'}}>{pct}%</div>
          </div>
        </div>
      </div>

      {/* Filter chips */}
      <div style={{display:'flex',gap:6,padding:'4px 20px 10px',overflowX:'auto',flexShrink:0}}>
        {['all','Code','Art','Doc','Sound','Spark','Spirit','Pixel','Zen','Glitch'].map(f => (
          <button key={f} onClick={()=>setFilter(f)} style={{
            appearance:'none',border:0,cursor:'pointer',
            padding:'5px 10px',borderRadius:999,fontWeight:800,fontSize:10,letterSpacing:'.04em',
            background: filter===f?'rgba(46,230,160,.18)':'rgba(255,255,255,.04)',
            color: filter===f?'#2EE6A0':'rgba(255,255,255,.6)',
            boxShadow: filter===f?'inset 0 0 0 1px #2EE6A0':'inset 0 0 0 1px rgba(255,255,255,.06)',
            display:'flex',alignItems:'center',gap:5,whiteSpace:'nowrap',
          }}>
            {f!=='all' && <TypeBadge type={f} size={14}/>}
            {f==='all' ? 'ALL' : f.toUpperCase()}
          </button>
        ))}
      </div>

      {/* Grid */}
      <div style={{flex:1,overflowY:'auto',padding:'4px 20px 18px',minHeight:0}}>
        <div className="dex-grid">
          {cells.map(({n,c,caught,Sp}) => (
            <div key={n} className={`dex-cell ${caught?'caught':'locked'}`}
              onClick={() => caught && c && go(`creature-${c.num}`)}>
              <span className="dex-num">#{String(n).padStart(3,'0')}</span>
              <div className="silhouette" style={{filter: caught?'':'brightness(0)', opacity: caught?1:.5}}>
                {Sp ? <Sp scale={3}/> : (
                  <div style={{width:48,height:48,borderRadius:'50%',background:'rgba(255,255,255,.15)'}}/>
                )}
              </div>
              {caught && c && <span className="dex-name">{c.name}</span>}
              {!caught && <span className="dex-name" style={{color:'rgba(255,255,255,.3)'}}>???</span>}
              {caught && c && (
                <div style={{position:'absolute',top:6,right:6,display:'flex',gap:2}}>
                  {c.types.slice(0,1).map(t => <TypeBadge key={t} type={t} size={14}/>)}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ═══ CREATURE DETAIL ════════════════════════════════════════════════════════
function CreatureScreen({ go, creatureId }) {
  const c = CREATURES.find(c => c.num === creatureId) || CREATURES[0];
  const Sprites = { 1: Codesprite, 2: Codecrawler, 3: Codetitan, 4: Inkling, 5: Inkwarden, 6: Inkdragoon, 7: Pixibrush, 8: Brushwing, 9: Maestrix, 25: Bracketling, 29: Stickynote, 31: Wavelet, 39: Tickbug, 41: Sproutmit };
  const Sp = Sprites[c.num] || Codesprite;
  return (
    <div style={{width:'100%',height:'100%',display:'flex',flexDirection:'column'}}>
      {/* Header */}
      <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',padding:'10px 18px 4px',flexShrink:0}}>
        <button onClick={() => go('dex')} style={{appearance:'none',border:0,background:'rgba(255,255,255,.06)',color:'#fff',borderRadius:8,padding:'5px 9px',cursor:'pointer',display:'flex',alignItems:'center',gap:5,fontSize:11,fontWeight:700}}>
          <span style={{fontSize:13}}>←</span> Pokédex
        </button>
        <div style={{display:'flex',alignItems:'center',gap:8}}>
          <span style={{fontFamily:'JetBrains Mono, monospace',color:'#FF6B6B',fontWeight:900,fontSize:16}}>#{String(c.num).padStart(3,'0')}</span>
          <h1 style={{margin:0,fontSize:22,fontWeight:900,color:'#fff'}}>{c.name}</h1>
          <div style={{display:'flex',gap:4,marginLeft:6}}>
            {c.types.map(t => <TypeBadge key={t} type={t} size={20}/>)}
          </div>
        </div>
        <div style={{width:80}}/>
      </div>

      <div style={{flex:1,padding:'6px 18px 18px',display:'grid',gridTemplateColumns:'1fr 1.05fr',gap:12,minHeight:0,overflow:'hidden'}}>
        {/* Left col — sprite + evolution */}
        <div style={{display:'flex',flexDirection:'column',gap:10,minHeight:0}}>
          <div className="card" style={{flex:1,display:'flex',alignItems:'center',justifyContent:'center',padding:14,background:'radial-gradient(circle at 50% 40%, rgba(46,230,160,.18), transparent 60%), rgba(14,8,32,.7)',minHeight:140}}>
            <div className="bob" style={{filter:'drop-shadow(0 0 22px rgba(46,230,160,.5))'}}><Sp scale={6}/></div>
          </div>
          <div className="card" style={{padding:'10px 14px',flexShrink:0}}>
            <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:8}}>EVOLUTION</div>
            {c.evo ? <EvolutionChain ids={c.evo} currentId={c.num}/> : <div style={{textAlign:'center',color:'rgba(255,255,255,.4)',fontSize:12,padding:'8px 0'}}>Does not evolve.</div>}
          </div>
        </div>

        {/* Right col — stats / move / lore (scrollable) */}
        <div style={{display:'flex',flexDirection:'column',gap:10,overflowY:'auto',paddingRight:4,minHeight:0}}>
          <div className="card" style={{padding:'12px 14px'}}>
            <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:8}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)'}}>BATTLE STATS</div>
              <div className="pill">{c.rarity?.toUpperCase()}</div>
            </div>
            <StatRow label="HP"  value={c.stats.HP} color="#FF6B6B"/>
            <StatRow label="FP"  value={c.stats.FP} color="#C147FF"/>
            <StatRow label="STA" value={c.stats.STA} color="#47A0FF"/>
            <StatRow label="SPD" value={c.stats.SPD} color="#2EE6A0"/>
          </div>
          <div className="card" style={{padding:'12px 14px'}}>
            <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:6}}>SIGNATURE MOVE</div>
            <div style={{fontSize:15,fontWeight:900,color:'#FFD960',marginBottom:4}}>{c.move}</div>
            <div style={{fontSize:11,color:'rgba(255,255,255,.7)',lineHeight:1.45}}>{c.moveDesc}</div>
          </div>
          {c.lore && c.lore.length > 0 && (
            <div className="card" style={{padding:'12px 14px'}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:6}}>LORE · NOTCHY'S NOTES</div>
              {c.lore.map((p,i) => (
                <p key={i} style={{margin:'0 0 6px',fontSize:11,color:'rgba(255,255,255,.78)',lineHeight:1.45,fontStyle:'italic'}}>"{p}"</p>
              ))}
            </div>
          )}
          {c.spawn && (
            <div className="card" style={{padding:'8px 12px',display:'flex',alignItems:'center',gap:8}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)'}}>SPAWN</div>
              <div style={{fontSize:11,color:'#2EE6A0',fontWeight:700}}>{c.spawn}</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ═══ TRAINER CARD ═══════════════════════════════════════════════════════════
function TrainerCardScreen({ go }) {
  return (
    <div style={{width:'100%',height:'100%',display:'flex',alignItems:'flex-start',justifyContent:'center',padding:'16px 20px 28px',overflow:'auto'}}>
        <div style={{
          width:560,
          background:'linear-gradient(135deg, rgba(14,8,32,.95), rgba(26,15,46,.95))',
          border:'2px solid #2EE6A0',
          borderRadius:18,
          padding:'18px 22px',
          boxShadow:'0 0 0 4px rgba(46,230,160,.08), 0 30px 80px rgba(0,0,0,.6), inset 0 1px 0 rgba(255,255,255,.1)',
          position:'relative',overflow:'hidden',
        }}>
          {/* holo sheen */}
          <div style={{position:'absolute',inset:0,background:'linear-gradient(135deg, transparent 30%, rgba(255,255,255,.06) 50%, transparent 70%)',pointerEvents:'none'}}/>

          {/* top row */}
          <div style={{display:'flex',alignItems:'flex-start',gap:16,marginBottom:18,position:'relative'}}>
            {/* avatar */}
            <div style={{width:80,height:80,borderRadius:14,background:'linear-gradient(135deg,#FFD960,#FF6B6B)',border:'2px solid #06010f',display:'flex',alignItems:'center',justifyContent:'center',fontSize:42,boxShadow:'0 4px 0 #06010f'}}>🧑‍💻</div>
            <div style={{flex:1}}>
              <div style={{fontSize:11,fontWeight:900,letterSpacing:'.12em',color:'rgba(255,255,255,.45)'}}>TRAINER ID · NV-7104</div>
              <h2 style={{margin:'2px 0 6px',fontSize:32,fontWeight:900,letterSpacing:'-.02em'}}>Ben</h2>
              <div style={{fontSize:12,color:'#2EE6A0',fontWeight:700}}>Cupertino, CA</div>
            </div>
            <div style={{display:'flex',alignItems:'center',gap:6,padding:'4px 10px',background:'linear-gradient(180deg,#FFD960,#a88f33)',borderRadius:999,border:'1.5px solid #06010f',fontWeight:900,color:'#06010f',fontSize:13,boxShadow:'0 3px 0 #06010f'}}>
              LV.24
            </div>
            <div style={{position:'absolute',top:-4,right:-4,filter:'drop-shadow(0 2px 6px rgba(0,0,0,.4))'}}>
              <Notchy scale={1.6}/>
            </div>
          </div>

          {/* starter row */}
          <div style={{display:'flex',gap:12,alignItems:'center',padding:'10px 14px',background:'rgba(46,230,160,.06)',border:'1px solid rgba(46,230,160,.25)',borderRadius:12,marginBottom:14,position:'relative'}}>
            <div style={{filter:'drop-shadow(0 0 12px rgba(46,230,160,.4))'}}><Codesprite scale={3}/></div>
            <div style={{flex:1}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)'}}>STARTER</div>
              <div style={{fontSize:18,fontWeight:900,color:'#2EE6A0'}}>Codesprite</div>
              <div style={{display:'flex',gap:4,marginTop:2}}><TypePill type="Code"/><TypePill type="Spirit"/></div>
            </div>
            <div style={{display:'flex',flexDirection:'column',alignItems:'flex-end',gap:2}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.45)'}}>BOND</div>
              <div style={{fontFamily:'JetBrains Mono, monospace',fontSize:16,fontWeight:900,color:'#FFD960'}}>312 hrs</div>
            </div>
          </div>

          {/* gym badges */}
          <div style={{marginBottom:14}}>
            <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:6}}>GYM BADGES</div>
            <div style={{display:'flex',gap:6}}>
              {['Code','Art','Doc','Sound','Spark','Zen','Spirit','Time'].map((t,i) => (
                <div key={t} style={{opacity: i<3?1:.18, filter: i<3?'drop-shadow(0 0 8px rgba(46,230,160,.4))':'grayscale(1)'}}>
                  <TypeBadge type={t} size={32}/>
                </div>
              ))}
            </div>
          </div>

          {/* stats grid */}
          <div style={{display:'grid',gridTemplateColumns:'1fr 1fr 1fr',gap:10,marginBottom:14}}>
            <div style={{padding:'10px 12px',background:'rgba(255,255,255,.04)',borderRadius:10}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:4}}>DEX COMPLETION</div>
              <div style={{fontSize:22,fontWeight:900,fontFamily:'JetBrains Mono, monospace',color:'#2EE6A0'}}>47%</div>
              <div style={{height:4,background:'rgba(255,255,255,.08)',borderRadius:2,marginTop:6,overflow:'hidden'}}><div style={{width:'47%',height:'100%',background:'#2EE6A0'}}/></div>
            </div>
            <div style={{padding:'10px 12px',background:'rgba(255,255,255,.04)',borderRadius:10}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:4}}>FOCUS HOURS</div>
              <div style={{fontSize:22,fontWeight:900,fontFamily:'JetBrains Mono, monospace',color:'#FFD960'}}>312</div>
              <div style={{fontSize:10,color:'rgba(255,255,255,.45)',marginTop:6}}>this year</div>
            </div>
            <div style={{padding:'10px 12px',background:'rgba(255,255,255,.04)',borderRadius:10,position:'relative'}}>
              <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:4}}>STREAK</div>
              <div style={{display:'flex',alignItems:'center',gap:6}}>
                <StreakFlame tier={2} scale={3}/>
                <div style={{fontSize:22,fontWeight:900,fontFamily:'JetBrains Mono, monospace',color:'#FF6B6B'}}>14d</div>
              </div>
            </div>
          </div>

          {/* QR + footer */}
          <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',gap:10}}>
            <div style={{fontSize:10,color:'rgba(255,255,255,.4)',fontFamily:'JetBrains Mono, monospace'}}>JOINED 2026-01-14 · NV-7104-AKLP</div>
            <div style={{width:54,height:54,background:'#fff',borderRadius:6,padding:4,display:'grid',gridTemplateColumns:'repeat(8,1fr)',gap:0}}>
              {[...Array(64)].map((_,i)=>{
                const on=((i*7+i*i)%5)<2;
                return <div key={i} style={{background:on?'#06010f':'transparent'}}/>;
              })}
            </div>
          </div>
        </div>
    </div>
  );
}

// ═══ BATTLE ═════════════════════════════════════════════════════════════════
function BattleScreen({ go }) {
  const [myHP, setMyHP] = React.useState(42);
  const [opHP, setOpHP] = React.useState(58);
  const [log, setLog] = React.useState(["A wild Inkling appeared!", "Go, Codesprite!"]);
  const [busy, setBusy] = React.useState(false);

  const attack = (name, dmg) => {
    if (busy) return;
    setBusy(true);
    setLog(l => [...l, `Codesprite used ${name}!`]);
    setTimeout(() => setOpHP(h => Math.max(0, h - dmg)), 400);
    setTimeout(() => {
      const counterDmg = 6 + Math.floor(Math.random()*6);
      setLog(l => [...l, `Wild Inkling used Margin Note!`]);
      setMyHP(h => Math.max(0, h - counterDmg));
      setBusy(false);
    }, 1200);
  };

  return (
    <div className="screen-fade" style={{position:'absolute',inset:0,overflow:'hidden'}}>
      {/* arena */}
      <div style={{position:'absolute',inset:0,background:'linear-gradient(180deg, #1a0a3a 0%, #6b1f7a 60%, #FF6B6B 100%)'}}/>
      <div className="stars-bg" style={{position:'absolute',top:0,left:0,right:0,height:'60%',opacity:.4}}/>
      {/* hex floor */}
      <svg style={{position:'absolute',bottom:0,left:0,right:0,height:'45%',width:'100%'}} viewBox="0 0 800 200" preserveAspectRatio="none">
        <defs>
          <linearGradient id="floor" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0%" stopColor="#2EE6A0" stopOpacity=".25"/>
            <stop offset="100%" stopColor="#2EE6A0" stopOpacity=".05"/>
          </linearGradient>
        </defs>
        <rect width="800" height="200" fill="url(#floor)"/>
        {[...Array(20)].map((_,i)=>(
          <line key={`v${i}`} x1={400+(i-10)*60} y1="0" x2={400+(i-10)*180} y2="200" stroke="rgba(46,230,160,.2)" strokeWidth="1"/>
        ))}
        {[...Array(6)].map((_,i)=>(
          <line key={`h${i}`} x1="0" y1={i*40} x2="800" y2={i*40} stroke="rgba(46,230,160,.2)" strokeWidth="1"/>
        ))}
      </svg>

      {/* HUD panels */}
      <div style={{position:'absolute',top:46,left:26,zIndex:5}}>
        <div className="card" style={{padding:'10px 14px',minWidth:240,background:'rgba(6,1,15,.78)'}}>
          <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:6}}>
            <div style={{fontSize:14,fontWeight:900,color:'#fff'}}>Codesprite</div>
            <div style={{display:'flex',gap:3}}><TypeBadge type="Code" size={16}/><TypeBadge type="Spirit" size={16}/></div>
          </div>
          <HPBar current={myHP} max={50} width={220}/>
          <div style={{fontSize:10,fontWeight:700,color:'rgba(255,255,255,.5)',marginTop:4}}>Lv.24 · Bond ⛓ 312h</div>
        </div>
      </div>

      <div style={{position:'absolute',top:46,right:26,zIndex:5}}>
        <div className="card" style={{padding:'10px 14px',minWidth:240,background:'rgba(6,1,15,.78)'}}>
          <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:6}}>
            <div style={{fontSize:14,fontWeight:900,color:'#fff'}}>Wild Inkling</div>
            <div style={{display:'flex',gap:3}}><TypeBadge type="Doc" size={16}/><TypeBadge type="Art" size={16}/></div>
          </div>
          <HPBar current={opHP} max={60} width={220}/>
          <div style={{fontSize:10,fontWeight:700,color:'rgba(255,255,255,.5)',marginTop:4}}>Lv.18 · "She's spry."</div>
        </div>
      </div>

      {/* creatures */}
      <div style={{position:'absolute',bottom:'30%',left:'18%',zIndex:4,filter:'drop-shadow(0 8px 0 rgba(0,0,0,.5))'}}>
        <div className={busy?'':'bob'}><Codesprite scale={7}/></div>
        <div style={{width:140,height:14,background:'radial-gradient(ellipse, rgba(0,0,0,.5), transparent 70%)',marginTop:-6,marginLeft:-10}}/>
      </div>
      <div style={{position:'absolute',top:'24%',right:'14%',zIndex:4,filter:'drop-shadow(0 6px 0 rgba(0,0,0,.5))'}}>
        <div className={busy?'':'bob'} style={{animationDelay:'.4s'}}><Inkling scale={6}/></div>
        <div style={{width:120,height:12,background:'radial-gradient(ellipse, rgba(0,0,0,.4), transparent 70%)',marginTop:-4,marginLeft:0}}/>
      </div>

      {/* bottom panel — move grid + log */}
      <div style={{position:'absolute',bottom:14,left:16,right:16,zIndex:6,display:'flex',gap:10,alignItems:'stretch'}}>
        <div style={{display:'grid',gridTemplateColumns:'1fr 1fr',gap:8,flex:1,maxWidth:520}}>
          {[
            { name:'Compile Strike', type:'Code', pp:'15/15', dmg:18 },
            { name:'Margin Pulse',   type:'Spirit', pp:'10/10', dmg:14 },
            { name:'Espresso Burst', type:'Caffeine', pp:'5/5', dmg:24 },
            { name:'Zen Pulse',      type:'Zen', pp:'8/8', dmg:10 },
          ].map(m => (
            <button key={m.name} onClick={() => attack(m.name, m.dmg)} disabled={busy} style={{
              appearance:'none',border:0,cursor:busy?'default':'pointer',
              padding:'10px 12px',borderRadius:12,
              background: `linear-gradient(180deg, ${TYPE_DEF[m.type]?.c1||'#888'}, ${TYPE_DEF[m.type]?.c2||'#444'})`,
              boxShadow:'0 0 0 1.5px #06010f, 0 3px 0 rgba(0,0,0,.5), inset 0 1px 0 rgba(255,255,255,.3)',
              textAlign:'left',color:'#06010f',
              opacity: busy?.6:1, transition:'opacity .15s',
            }}>
              <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
                <div style={{fontSize:13,fontWeight:900}}>{m.name}</div>
                <TypeBadge type={m.type} size={18}/>
              </div>
              <div style={{display:'flex',justifyContent:'space-between',marginTop:3,fontSize:10,fontWeight:800,opacity:.75}}>
                <span>PP {m.pp}</span><span>POW {m.dmg}</span>
              </div>
            </button>
          ))}
        </div>
        <div className="card" style={{flex:1,padding:'10px 14px',background:'rgba(6,1,15,.85)',display:'flex',flexDirection:'column'}}>
          <div style={{fontSize:10,fontWeight:900,letterSpacing:'.08em',color:'rgba(255,255,255,.5)',marginBottom:5}}>BATTLE LOG</div>
          <div style={{fontFamily:'JetBrains Mono, monospace',fontSize:11,color:'rgba(255,255,255,.85)',lineHeight:1.5,flex:1,overflowY:'auto'}}>
            {log.slice(-4).map((line,i) => <div key={i}>› {line}</div>)}
          </div>
        </div>
        <button onClick={()=>go('desktop')} title="leave" style={{
          appearance:'none',border:0,cursor:'pointer',
          width:56,height:56,borderRadius:14,
          background:'rgba(6,1,15,.85)',
          boxShadow:'0 0 0 1px rgba(255,255,255,.1)',
          display:'flex',alignItems:'center',justifyContent:'center',alignSelf:'center',
        }}>
          <Notchy scale={1.4}/>
        </button>
      </div>
    </div>
  );
}

Object.assign(window, {
  TitleScreen,
  Onb1, Onb2, Onb3, Onb4, Onb5,
  LockInScreen, DistractionPopup,
  CatchScreen, CatchRevealScreen,
  DexScreen, CreatureScreen,
  TrainerCardScreen, BattleScreen,
});
