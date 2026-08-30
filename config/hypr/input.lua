-- Delorean overlay — CapsLock is Caps Lock again.
-- Stock Omarchy is compose:caps,shift:both_capslock_cancel (CapsLock starts
-- XCompose sequences; both Shifts toggle Caps). Swap those roles: CapsLock
-- locks, both Shifts together emit Multi_key for ~/.XCompose.
--
-- Replaces the whole kb_options string. Add extra XKB options here
-- (e.g. grp:alts_toggle) if you need them.
-- Custom option is defined in ~/.config/xkb (this overlay).

hl.config({
  input = {
    kb_options = "delorean:compose_shifts",
  },
})
