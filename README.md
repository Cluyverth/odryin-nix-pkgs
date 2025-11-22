# ❄️ Cluyverth's NUR Packages

![NixOS](https://img.shields.io/badge/NixOS-25.05+-5277C3.svg?style=for-the-badge&logo=nixos&logoColor=white)
![Build Status](https://img.shields.io/github/actions/workflow/status/cluyverth/nur-packages/build.yml?style=for-the-badge&label=Build&logo=github)
[![License](https://img.shields.io/github/license/cluyverth/nur-packages?style=for-the-badge)](LICENSE)
[![NUR Status](https://img.shields.io/website?down_message=Not%20Indexed&down_color=red&label=NUR&up_message=Indexed&up_color=green&url=https%3A%2F%2Fnur.nix-community.org%2Frepos%2Fcluyverth%2F&style=for-the-badge&logo=nixos&logoColor=white)](https://nur.nix-community.org/repos/cluyverth/)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)

**Custom Nix packages, derivations, and overlays maintained by [@cluyverth](https://github.com/cluyverth).**

This repository functions as a **NUR (Nix User Repository)** channel. It provides high-quality packages that are either not yet available in the official `nixpkgs` or are custom-tailored versions for specific needs.

## 📦 Available Packages

| Package | Version | Description | Architectures |
| :--- | :--- | :--- | :--- |
| **[helium](./pkgs/helium)** | `0.6.7.1` | Helium Browser: Internet without interruptions. A floating browser window. | `x86_64` `aarch64` |
| *(More coming)* | ... | ... | ... |

## 🚀 Installation

You can install packages from this repository using **Nix Flakes**, **NUR**, or **Legacy Channels**.

### Option A: Using Nix Flakes (Recommended)

Add this repository to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Add cluyverth's NUR
    cluyverth-nur.url = "github:cluyverth/nur-packages";
  };

  outputs = { self, nixpkgs, cluyverth-nur, ... }: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            cluyverth-nur.packages.${pkgs.system}.helium
          ];
        })
      ];
    };
  };
}
```

### Option B: Using the NUR Overlay

If you use the main [NUR repository](https://github.com/nix-community/NUR), my packages are available under the `cluyverth` namespace.

```nix
# In your configuration.nix
{ config, pkgs, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in
{
  imports = [
    # ...
  ];

  environment.systemPackages = [
    # Access packages via nur.repos.cluyverth
    nur-no-pkgs.repos.cluyverth.helium
  ];
}
```

### Option C: Legacy / Direct Import

Useful for testing or if you don't use Flakes/NUR directly.

```nix
let
  cluyverthPkgs = import (builtins.fetchTarball "https://github.com/cluyverth/nur-packages/archive/main.tar.gz") {
    pkgs = pkgs;
  };
in
{
  environment.systemPackages = [
    cluyverthPkgs.helium
  ];
}
```

## 🛠️ Development & CI

This repository is automatically tested and built using GitHub Actions to ensure package integrity across supported architectures.

To build a package locally:

```bash
# Build Helium
nix-build -A helium
```

## 🤝 Contributing

Contributions are highly encouraged! If you have a package request or a fix:

1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feat/new-package`).
3.  Commit your changes.
4.  Open a Pull Request.
