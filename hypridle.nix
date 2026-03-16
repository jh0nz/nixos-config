{ config, pkgs, ... }:

{
  services.hypridle = {
    enable = true;

    settings = {

      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [

        # 5 min → lock screen
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        # 10 min → turn monitor off
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume  = "hyprctl dispatch dpms on";
        }

        # 20 min → suspend
        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
        }

      ];
    };
  };
}
