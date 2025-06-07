# Nixos Config

>## Main Packages
>> **Browser** `vivaldi`
>>
>> **File Manager** `dolphin`
>>
>> **Login screen** `ly`
>>
>> **Status bar** `waybar`
>>
>> **Text editor** `neovim`
>>
>> **DE** `khyprland and some hyprland utils`
>>
>> **E-mail** `thunderbird`
>>
>> **Keyboard** `qmk-air40`

# Tips
> ## General Tips
>>home-manager is standalone installation <br>
>>git is not configured, always manual <br>
>>neovim config is not tracked here <br>
>
>### software configs update
>>home-manager switch --flake . 
>
>### OS config update
>>sudo nixos-rebuild switch --flake .
>
>### generations delete
>> #### NixOs
>>> (sudo) nix-env --list-generations 
>>>
>>> (sudo) nix-collect-garbage -d
>>>
>>> nix-env --delete-generations old
>> #### HomeManager
>>> home-manager generations
>### Flake update
>> nix flake update
>>>change versions in flake.nix
>> manually update the standalone home-manager

