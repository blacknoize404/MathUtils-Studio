# MathUtils Studio

> **A desktop app for step-by-step math**: derivatives, limits and integrals explained rule by rule, with the
> expression tree of every step, and panels for matrices, complex numbers, statistics and differential equations.
> It runs on Windows and Linux.

> **Documentación en español**: [README.es.md](README.es.md)

<p align="center">
  <img src="docs/images/studio-integral-light.png" alt="MathUtils Studio solving an improper integral, with the formula typeset in the field, the steps and the animator" width="49%">
  <img src="docs/images/studio-hessian-dark.png" alt="MathUtils Studio computing a Hessian in dark mode" width="49%">
</p>

## What it does

- **Calculator** with exact and decimal results, variables, your own functions and a history.
- **Derivatives, limits and integrals, step by step.** Every step names the rule, shows its formula with the values of the
  problem and the partial result. Integrals cover substitution, parts, partial fractions, trigonometric and radical forms,
  special functions (`erf`, `Si`, `Ci`, `Ei`, `li`), and definite and improper integrals. Results are verified, and when the
  engine does not know how to solve something it says so instead of guessing.
- **Several variables:** mixed partial derivatives, gradient, Hessian, Jacobian, divergence, Laplacian, iterated integrals
  and limits at a point (it proves that a limit does not exist, or proves its value, and otherwise only offers a candidate).
- **Live preview** of what you type, in proper mathematical notation, and a **symbol palette** for what the keyboard does not
  have (`π`, `√`, `x²`, `∞`, Greek letters).
- **Animator** in a collapsible side panel: it walks through the steps and draws the expression tree before and after each
  one. The steps come in three levels of detail (summary, main, full).
- **Expression tree** and **order of operations**, animated.
- **Panels** for matrices (inverse, LU, linear systems), complex numbers (Argand plane, roots), statistics (summary, histogram,
  distributions) and differential equations (Euler, Heun, RK4, Dormand-Prince, with a graph).
- Spanish and English, light and dark themes.

## Download

Get the installer for Windows (`MathUtilsStudio-*-windows-x64-setup.exe`) or the package for your Linux from the
[releases](https://github.com/blacknoize404/MathUtils-Studio/releases):

| Distribution | Package |
|---|---|
| Debian, Ubuntu and derivatives | `.deb` (`sudo apt install ./mathutilsstudio_*.deb`) |
| Fedora, openSUSE | `.rpm` (`sudo dnf install ./mathutilsstudio-*.rpm`) |
| Arch Linux and derivatives | `mathutils-studio-*.pkg.tar.zst` (`sudo pacman -U`), or build the [PKGBUILD](packaging/arch/PKGBUILD) |
| NixOS and Nix | the flake, see [below](#nixos-and-nix) |
| Any other | `.tar.gz`, with an `install.sh` that installs it for your user without administrator rights |

Every package brings its own Java runtime.

## NixOS and Nix

The repository is a flake that packages the Linux release (the app brings its own Java runtime):

```bash
nix run github:blacknoize404/MathUtils-Studio
```

To install it on NixOS, add the flake as an input and the overlay to your configuration:

```nix
{
  inputs.mathutils-studio.url = "github:blacknoize404/MathUtils-Studio";

  # in your configuration
  nixpkgs.overlays = [ inputs.mathutils-studio.overlays.default ];
  environment.systemPackages = [ pkgs.mathutils-studio ];
}
```

The package is not free software, so Nix asks you to allow it. `nix run` already does it for this package; on NixOS add
`nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "mathutils-studio";` next to the overlay. The package
(`nix/package.nix`) points at the latest published release.

## Acknowledgements

To my Continuous Mathematics professor at the University of Holguín, Alberto, and to my tutor, Yisel Clavel Quintero, for their unconditional support.

## Credits and license

Created by [barnesinside](https://barnesinside.is-a.dev). The engine is the [BI.MathUtils](https://github.com/blacknoize404/BI.MathUtils) library, by the same author. Typefaces Geist and
Geist Mono (SIL Open Font License) and Lucide icons (ISC license). The app is free to use under the [license agreement](LICENSE); its source code is private. See [NOTICE.md](NOTICE.md) for what covers what.
