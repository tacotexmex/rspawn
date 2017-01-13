# r-Spawn for Minetest

A spawn command for Minetest without needing a fixed point

If no `static_spawnpoint` is defined in `minetest.conf`, each player is given a spawn location somewhere near 0,0,0.

If static spawn point is defined, that point is used as origin instead.

Players will not spawn in spaces that are protected by any other player than the Server Admin.

Players can request a new spawn point by typing `/newspawn` if they have the `newspawn` privilege.

Player will respawn at ths spawnpoint if they die.

TODO - integrate with beds API to allow bed to override the spawn.

## License

(C) 2017 Tai "DuCake" Kedzierski
based originally on the mod uploaded by everamzah

Provided under the terms of the LGPL v3.0
