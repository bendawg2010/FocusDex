/* FocusDex — promo site interactions
   Download gate (3-second hold) · smooth scroll · scroll reveals ·
   count-up numbers · 3D card tilt · orb parallax · Notchy easter egg */
(function () {
  'use strict';

  // ─── Download gate (3-second hold + Open Anyway warning) ─────────────
  const gate = document.getElementById('dlGate');
  const gateClose = document.getElementById('dlGateClose');
  const gateConfirm = document.getElementById('dlGateConfirm');
  const gateText = gateConfirm && gateConfirm.querySelector('.dl-gate-btn-text');
  let gateTimer = null;
  let gateHref = '';

  function openGate(href) {
    if (!gate) return;
    gateHref = href || '#';
    gate.removeAttribute('hidden');
    gateConfirm.setAttribute('data-locked', 'true');
    gateConfirm.setAttribute('href', '#');
    let remaining = 3;
    gateText.textContent = 'Read above (' + remaining + 's)…';
    clearInterval(gateTimer);
    gateTimer = setInterval(function () {
      remaining--;
      if (remaining > 0) {
        gateText.textContent = 'Read above (' + remaining + 's)…';
      } else {
        clearInterval(gateTimer);
        gateConfirm.removeAttribute('data-locked');
        gateConfirm.setAttribute('href', gateHref);
        gateText.textContent = '↓ Download FocusDex.dmg';
      }
    }, 1000);
  }

  function closeGate() {
    if (!gate) return;
    gate.setAttribute('hidden', '');
    clearInterval(gateTimer);
    gateConfirm.setAttribute('data-locked', 'true');
    gateConfirm.setAttribute('href', '#');
    gateText.textContent = 'Read above (3s)…';
  }

  document.querySelectorAll('[data-download-trigger]').forEach(function (link) {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      openGate(link.getAttribute('href'));
    });
  });

  if (gateConfirm) {
    gateConfirm.addEventListener('click', function (e) {
      if (gateConfirm.getAttribute('data-locked') === 'true') {
        e.preventDefault();
        return;
      }
      // Let the <a> navigate the href, then auto-close the modal.
      setTimeout(closeGate, 600);
    });
  }
  if (gateClose) gateClose.addEventListener('click', closeGate);
  if (gate) {
    gate.addEventListener('click', function (e) {
      if (e.target === gate) closeGate();
    });
  }
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && gate && !gate.hasAttribute('hidden')) closeGate();
  });

  // ─── Smooth scroll for #anchor links ────────────────────────────────
  document.querySelectorAll('a[href^="#"]').forEach(function (a) {
    a.addEventListener('click', function (e) {
      const id = a.getAttribute('href');
      if (id && id.length > 1 && id !== '#') {
        const target = document.querySelector(id);
        if (target) {
          e.preventDefault();
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }
    });
  });

  // ─── Scroll-triggered reveals ────────────────────────────────────────
  const reveals = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && reveals.length) {
    const io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });
    reveals.forEach(function (el) { io.observe(el); });
  } else {
    reveals.forEach(function (el) { el.classList.add('is-visible'); });
  }

  // ─── Count-up animation on .stat-num ─────────────────────────────────
  function easeOut(t) { return 1 - Math.pow(1 - t, 3); }
  function countUp(el) {
    const text = el.getAttribute('data-count') || el.textContent;
    const match = (text || '').match(/(\d+)/);
    if (!match) return;
    const target = parseInt(match[1], 10);
    const suffix = (text || '').replace(/^\d+/, '');
    const duration = 1400;
    const start = performance.now();
    function frame(now) {
      const t = Math.min(1, (now - start) / duration);
      el.textContent = Math.round(easeOut(t) * target) + suffix;
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }
  const statNums = document.querySelectorAll('.stat-num');
  if ('IntersectionObserver' in window && statNums.length) {
    statNums.forEach(function (el) {
      if (!el.getAttribute('data-count')) {
        el.setAttribute('data-count', el.textContent.trim());
        el.textContent = '0';
      }
    });
    const io2 = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          countUp(entry.target);
          io2.unobserve(entry.target);
        }
      });
    }, { threshold: 0.3 });
    statNums.forEach(function (el) { io2.observe(el); });
  }

  // ─── 3D tilt on starter cards ────────────────────────────────────────
  document.querySelectorAll('.starter-card').forEach(function (card) {
    card.addEventListener('mousemove', function (e) {
      const rect = card.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width - 0.5;
      const y = (e.clientY - rect.top) / rect.height - 0.5;
      card.style.transform = 'translateY(-6px) rotateX(' + (-y * 6) + 'deg) rotateY(' + (x * 6) + 'deg)';
    });
    card.addEventListener('mouseleave', function () {
      card.style.transform = '';
    });
  });

  // ─── Orb cursor parallax ─────────────────────────────────────────────
  let raf = null;
  document.addEventListener('mousemove', function (e) {
    if (raf) return;
    raf = requestAnimationFrame(function () {
      const x = (e.clientX / window.innerWidth - 0.5) * 14;
      const y = (e.clientY / window.innerHeight - 0.5) * 14;
      document.body.style.setProperty('--orb-x', x + 'px');
      document.body.style.setProperty('--orb-y', y + 'px');
      raf = null;
    });
  });

  // ─── Easter egg: tap Notchy in the notch mock ───────────────────────
  const notchy = document.querySelector('.notchy-emoji');
  if (notchy) {
    let taps = 0;
    notchy.addEventListener('click', function () {
      taps++;
      notchy.style.transition = 'transform 200ms';
      notchy.style.transform = 'scale(' + (1 + taps * 0.1) + ') rotate(' + (taps * 30) + 'deg)';
      if (taps >= 5) {
        notchy.textContent = '✨';
        setTimeout(function () { notchy.textContent = '●︎'; notchy.style.transform = ''; taps = 0; }, 1500);
      }
    });
  }
})();
