# /home/rijan/my-nixos-config/flake.nix
{
  # A description for your flake, shown in commands like `nix flake show`
  description = "Rijan's NixOS Configuration Flake (Single File)";

  # --- INPUTS ---
  # Inputs are the external dependencies of your flake, like nixpkgs or other flakes.
  inputs = {

    # The Nix Packages collection (nixpkgs). This is the core repository
    # containing almost all packages and the NixOS module system.
    # We pin it to a specific branch (`nixos-24.11`) for reproducibility.
    # This should ideally match the `system.stateVersion` in your configuration.nix.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    lemFlake = {
        url = "github:lem-project/lem"; 
        inputs.nixpkgs.follows = "nixpkgs"; # Optional: ensure consistent nixpkgs
    };
    # The Home Manager flake. Home Manager is used to manage user-specific
    # configurations (dotfiles, packages, services).
    # We pin it to a branch compatible with our nixpkgs version (`release-24.11`).
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # This line is crucial: it tells home-manager to use the *same* version
      # of nixpkgs that we defined above. This prevents conflicts.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # If you had other external dependencies (like NUR or custom flakes),
    # you would add them here following a similar pattern.
    # Example: my-custom-flake.url = "github:yourusername/yourflake";
  };

  # --- OUTPUTS ---
  # Outputs define what your flake *provides*. This function takes 'self'
  # (a reference to this flake's own outputs) and all the defined 'inputs'.
  # The '@inputs' pattern conveniently makes all inputs available by name.
  outputs = { self, nixpkgs, home-manager, lemFlake, ... }@inputs:
    let
      # Define the system architecture you are building for.
      # Common values: "x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin".
      system = "x86_64-linux"; # Change this if your architecture is different!
      # This line might be needed for lemFlake
      specialArgs = { inherit inputs; }; # Pass inputs if needed in modules

      # Create a pkgs instance for the specified system.
      # We do this here so we can apply system-wide configurations if needed.
      pkgs = import nixpkgs {
        inherit system; # Use the architecture defined above.

        # Configuration overlays applied to nixpkgs for this flake.
        config = {
          # Allow packages marked as 'unfree' (e.g., proprietary drivers/software).
          # This setting was found in your original home-manager config,
          # but it's often better applied system-wide here.
          allowUnfree = true;

          # Allow specific insecure packages if absolutely necessary.
          # Also moved from your home-manager config for system-wide clarity.
          permittedInsecurePackages = [
            "electron-27.3.11"
          ];
        };

        # If you had overlays (custom packages or modifications), you'd add them here:
        # overlays = [ /* your overlays */ ];
      };

    in { # The actual outputs provided by the flake:

      # NixOS System Configurations.
      # This is where you define one or more complete NixOS system configurations.
      nixosConfigurations = {

        # Define a configuration for a specific host.
        # !!! IMPORTANT !!!
        # Replace 'nixos' below with the actual hostname of your machine.
        # This MUST match the value of `networking.hostName` in your
        # configuration.nix file.
        "nixos" = nixpkgs.lib.nixosSystem {
          inherit system; # Use the architecture defined above.

          # Special arguments passed down into modules. This allows modules
          # (like configuration.nix or home-manager) to access flake inputs.
          specialArgs = { inherit inputs pkgs; }; # Pass inputs and our configured pkgs

          # The list of modules to include in this system configuration.
          # NixOS builds the final system by combining these modules.
          # The order can sometimes matter, but hardware-config first is standard.
          modules = [
            # 1. Hardware Configuration: Contains hardware-specific settings detected
            #    during installation (drivers, filesystems, etc.).
            ./hardware-configuration.nix

            # 2. Main Configuration: Your primary configuration file where you define
            #    packages, services, users, etc.
            #    We are using your *existing*, single configuration.nix here.
            ./configuration.nix

            # 3. Home Manager NixOS Module: This module integrates Home Manager
            #    into your NixOS system configuration. It reads the
            #    `home-manager.users.<username>` settings from your configuration.nix.
            home-manager.nixosModules.home-manager
          ];
        };

        # You could define other hosts here, e.g.:
        # "my-laptop" = nixpkgs.lib.nixosSystem { ... };
      };

      # You can also expose other things from your flake, like packages, apps,
      # or developer shells, but we are focusing on the NixOS configuration for now.
      # Example:
      # packages.${system}.hello = pkgs.hello;
    };
}
