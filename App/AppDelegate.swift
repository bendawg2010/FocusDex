import AppKit
import SwiftUI
import Combine

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    let focus = FocusManager()
    let dex = DexStore()
    private var subs = Set<AnyCancellable>()
    private var menu: NSMenu!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let symbol = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "FocusDex")
            symbol?.isTemplate = true
            button.image = symbol
            button.imagePosition = .imageLeft
            button.toolTip = "FocusDex"
            button.target = self
            button.action = #selector(handleStatusClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.font = .menuBarFont(ofSize: 13)
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: 380, height: 560)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: ContentView()
                .environmentObject(focus)
                .environmentObject(dex)
        )

        buildContextMenu()
        observeFocusForMenubar()
        observePhaseForAutoOpen()
    }

    // MARK: - Click handling

    @objc private func handleStatusClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { togglePopover(); return }
        if event.type == .rightMouseUp || event.modifierFlags.contains(.control) {
            showContextMenu()
        } else {
            togglePopover()
        }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    private func showContextMenu() {
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }

    private func buildContextMenu() {
        let m = NSMenu()
        m.addItem(NSMenuItem(title: "Start 25-min Focus", action: #selector(quickStart25), keyEquivalent: "n"))
        m.addItem(NSMenuItem(title: "Start 45-min Focus", action: #selector(quickStart45), keyEquivalent: ""))
        m.addItem(NSMenuItem(title: "Start 90-min Focus", action: #selector(quickStart90), keyEquivalent: ""))
        m.addItem(.separator())
        m.addItem(NSMenuItem(title: "Stop Current Session", action: #selector(quickStop), keyEquivalent: "."))
        m.addItem(NSMenuItem(title: "Open Dex", action: #selector(openDex), keyEquivalent: "d"))
        m.addItem(.separator())
        let aboutItem = NSMenuItem(title: "About FocusDex", action: #selector(openRepo), keyEquivalent: "")
        m.addItem(aboutItem)
        m.addItem(NSMenuItem(title: "Tip Jar (Cash App)", action: #selector(openTip), keyEquivalent: ""))
        m.addItem(.separator())
        m.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        for item in m.items { item.target = self }
        self.menu = m
    }

    @objc private func quickStart25() { focus.plannedDuration = 25 * 60; focus.start(); togglePopoverIfHidden() }
    @objc private func quickStart45() { focus.plannedDuration = 45 * 60; focus.start(); togglePopoverIfHidden() }
    @objc private func quickStart90() { focus.plannedDuration = 90 * 60; focus.start(); togglePopoverIfHidden() }
    @objc private func quickStop()    { focus.stopEarly() }
    @objc private func openDex()      { togglePopoverIfHidden() }
    @objc private func openRepo()     { NSWorkspace.shared.open(URL(string: "https://github.com/bendawg2010/FocusDex")!) }
    @objc private func openTip()      { NSWorkspace.shared.open(URL(string: "https://cash.app/$Dryeetsolutions")!) }

    private func togglePopoverIfHidden() {
        if !popover.isShown { togglePopover() }
    }

    // MARK: - Menubar live countdown

    private func observeFocusForMenubar() {
        focus.$phase.combineLatest(focus.$timeRemaining)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] phase, remaining in
                self?.updateStatusBarTitle(phase: phase, remaining: remaining)
            }
            .store(in: &subs)
    }

    private func updateStatusBarTitle(phase: FocusManager.Phase, remaining: TimeInterval) {
        guard let button = statusItem.button else { return }
        switch phase {
        case .focusing:
            let t = Int(remaining.rounded())
            button.title = " " + String(format: "%d:%02d", t / 60, t % 60)
        case .celebration:
            button.title = " ✓"
        case .safari:
            button.title = " 🎯"
        case .idle:
            button.title = ""
        }
    }

    // MARK: - Auto-open popover on session end

    private func observePhaseForAutoOpen() {
        focus.$phase
            .removeDuplicates()
            .sink { [weak self] phase in
                guard let self else { return }
                if phase == .celebration || phase == .safari {
                    if !self.popover.isShown { self.togglePopover() }
                }
            }
            .store(in: &subs)
    }
}
