# erlang-shell

Reproducibilan Nix dev shell za Erlang/OTP razvoj, baziran na `beam28Packages` (OTP 28) iz nixpkgs-a.

## Sadržaj

Ovaj flake pruža jedan `devShell` sa sljedećim alatima:

| Paket | Opis |
|---|---|
| `beam28Packages.erlang` | Erlang/OTP 28 runtime (`erl`, `erlc`, `escript`) |
| `beam28Packages.rebar3` | Build alat i package manager za Erlang |
| `elp` | [Erlang Language Platform](https://github.com/WhatsApp/erlang-language-platform) — LSP server i CLI (WhatsApp), pinano na release `2026-06-10` |
| `vips` | libvips — obrada slika |
| `glibc` | GNU C biblioteka |
| `file` | Alat za prepoznavanje tipova datoteka |

## Preduvjeti

- [Nix](https://nixos.org/download) s omogućenim flakes i nix-command:

  ```bash
  # ~/.config/nix/nix.conf ili /etc/nix/nix.conf
  experimental-features = nix-command flakes
  ```

## Korištenje

### Opcija 1 — direktno iz repoa

```bash
git clone <url-ovog-repoa> erlang-shell
cd erlang-shell
nix develop
```

### Opcija 2 — iz bilo kojeg drugog projekt-direktorija

```bash
cd ~/projects/moj-erlang-projekt
nix develop /putanja/do/erlang-shell
# ili, ako je repo na GitHubu:
nix develop github:<user>/erlang-shell
```

### Opcija 3 — automatska aktivacija preko direnv

Instaliraj [direnv](https://direnv.net/) i [nix-direnv](https://github.com/nix-community/nix-direnv), zatim u root projekta dodaj `.envrc`:

```bash
use flake "github:<user>/erlang-shell"
```

Pa jednom odobri:

```bash
direnv allow
```

Nakon toga, `cd` u taj direktorij automatski aktivira shell (i deaktivira ga pri izlasku), bez ručnog pozivanja `nix develop`.

## Verzioniranje

- Erlang/OTP verzija i sve ostale verzije paketa određene su `flake.lock` datotekom (pinana na točan `nixpkgs` commit).
- Za update na noviju verziju Erlanga/rebar3/itd.:

  ```bash
  nix flake update
  ```

  Ovo povlači najnoviji `nixos-unstable` commit i regenerira `flake.lock`. Commitaj promijenjeni `flake.lock` da svi u timu dobiju istu novu verziju.

- Za update samo ELP-a, uredi `version` i `hash` u `elp_latest.nix` prema [najnovijem release-u](https://github.com/WhatsApp/erlang-language-platform/releases).

## Sistemski alati (LSP-ovi, editor pomagala, itd.)

Ovaj shell namjerno sadrži **samo** alate nužne za build/compile projekta, kako bi build environment bio identičan za sve članove tima. Shell hook dodatno doda tvoje postojeće sistemske pakete (`/run/current-system/sw/bin` na NixOS-u, `$HOME/.nix-profile/bin` za home-manager) na kraj `PATH`-a, tako da svatko slobodno koristi svoj vlastiti markdown LSP, git config, editor alate i sl. bez utjecaja na build reproducibilnost.

## Struktura repoa

```
.
├── flake.nix          # definicija dev shella
├── flake.lock         # pinane verzije (commitati u git)
├── elp_latest.nix      # derivacija za Erlang Language Platform
└── README.md
```

## Provjera instalacije

```bash
nix develop
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
rebar3 --version
elp --version
```

## Poznati problemi

- **Observer (`:observer.start()` / `observer:start().`)** — GUI monitoring alat zahtijeva Erlang izgrađen s wx podrškom. Ako ti `observer` modul nije dostupan (`module :observer is not available`), provjeri je li tvoj `nixpkgs` pin dovoljno svjež (`nixos-unstable`/`master`) — starije stabilne grane ponekad ne uključuju wx-enabled build po defaultu.
