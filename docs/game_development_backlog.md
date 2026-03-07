# Game Development Backlog

## Phase 1: first playable loop

- [x] Project shell with Discover and Rooms
- [x] Game registry and room lounge skeleton
- [x] Android build path repaired
- [x] Signal Deck local playable prototype
- [ ] Reusable game session layout
- [x] Game result panel and replay loop
- [ ] Module detail page for every listed game

## Phase 2: room and multiplayer foundation

- [ ] Create room flow
- [ ] Join room by code
- [ ] Room seat model and ready status
- [ ] Shared room event protocol
- [ ] In-room chat and voice placeholders
- [ ] Reconnect and resume state model

## Phase 3: gameplay scale-out

- [ ] Midnight Vote prototype
- [ ] Chaos Mixer minigame pack
- [ ] Orbit Merchant prototype
- [ ] Common turn timer and action validator
- [ ] Shared reward and progression model

## Phase 4: production hardening

- [ ] Analytics for room creation, start, finish, replay
- [ ] Crash reporting hooks
- [ ] Offline snapshot and restore
- [ ] A/B config entry points
- [ ] Golden/widget tests for major flows
- [ ] CI split for analyze, test, build-web, build-android

## Immediate implementation order

1. Extract reusable game session scaffolding from Signal Deck.
2. Connect room model to game launch metadata and create room flow.
3. Add turn timer and action validator shared by all future card games.
4. Add the second game only after the first one has a stable session shell.
