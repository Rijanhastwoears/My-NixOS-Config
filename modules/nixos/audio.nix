# modules/nixos/audio.nix
{ config, pkgs, ... }:

{
  # Disable legacy PulseAudio daemon
  hardware.pulseaudio.enable = false;

  # Enable RealtimeKit for low-latency audio scheduling
  security.rtkit.enable = true;

  # Enable Pipewire audio server
  services.pipewire = {
    enable = true;
    alsa.enable = true;       # Enable ALSA compatibility
    alsa.support32Bit = true; # Enable 32-bit ALSA support
    pulse.enable = true;      # Enable PulseAudio compatibility endpoint
    # jack.enable = true;     # Uncomment if you need JACK support
  };

  # Add user to the 'audio' group if needed for specific applications (often handled automatically)
  # users.users.rijan.extraGroups = [ "audio" ];
}
