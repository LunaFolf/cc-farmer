# CC Farmer Bot

A ComputerCraft (1.18.2) Program for a farming turtle, that can be used to farm a **square** field of crops.

## Usage
- Place the turtle at the bottom left corner of outside the field, so that the first crop is diagonal to the turtle. (See image below)
- [Optional] Place a chest (single/double/modded) on any side (except bottom/top) of the turtle.
- Add some fuel to the turtle, any slot will do.
- Run `index.lua` on the turtle.

## Configuration
On first run, a config file will be generated in `.lunaOS/farmbot/config`, containing the following settings:

<table>
<tr>
<th>Setting</th>
<th>Description</th>
<th>Default</th>
</tr>
<tr>
<td>

`harvestInterval`
</td>
<td>
The interval in seconds between harvests cycles.
</td>
<td>

`300`
</td>
</tr>
<tr>
<td>

`harvestableTags`
</td>
<td>
A list of tags that the turtle will consider as harvestable.
</td>
<td>

```lua
{
  "minecraft:crops",
  "computercraft:turtle_hoe_harvestable"
}
```
</td>
</tr>
<tr>
<td>

`waterSouceIdentifierTags`
</td>
<td>
A list of tags that the turtle will consider as "markers" for water sources.

_(Turtle can only see one block down, and water is usually 2 blocks, so cheep fix is to have a marker block above the water source)_
</td>
<td>

```lua
{
  "minecraft:slabs",
  "minecraft:walls"
}
```
</td>
</tr>
<tr>
<td>

`seedMap`
</td>
<td>
A keyed list of seeds, where the key is the name of the picked crop (block), and the value is the seed item name.
</td>
<td>

```lua
seedMap = {
  ["minecraft:wheat"] = "minecraft:wheat_seeds",
  ["minecraft:carrots"] = "minecraft:carrot",
  ["minecraft:potatoes"] = "minecraft:potato",
  ["minecraft:beetroots"] = "minecraft:beetroot_seeds",
  ["minecraft:nether_wart"] = "minecraft:nether_wart",
  ["minecraft:sugar_cane"] = "minecraft:sugar_cane"
}
```
</td>
</tr>
<tr>
<td>

`cropMaxAge`
</td>
<td>
A keyed list of crop max ages, where the key is the name of the picked crop (block), and the value is the max age of the crop.
</td>
<td>

```lua
cropMaxAge = {
  ["minecraft:wheat"] = 7,
  ["minecraft:carrots"] = 7,
  ["minecraft:potatoes"] = 7,
  ["minecraft:beetroots"] = 3,
  ["minecraft:nether_wart"] = 3,
  ["minecraft:sugar_cane"] = 1
}
```
</td>
</tr>
</table>

## Known Issues
- [ ] Before each move, the turtle is meant to check if it has enough fuel. However, sometimes this check is not done, in addition to this, the check should also see if it has enough fuel to make the next move **AND** return to it's starting point.
- [ ] If the bot is restarted for any reason, i.e. a server restart or chunk unload, the bot will turn back on without it's program running. If the program is started again, it will no longer know where it is, and presumes it is at the starting point.
- [ ] When offloading it's inventory, the bot maps which slots are fuel and which are not. Despite this, it will scan the entire inventory when attempting to move items, including the fuel slots and empty slots. This is a waste of time, and should be fixed.

## Planned Features
- [ ] Replace the current ROM/BIOS with a custom one (part of LunaOS), that will allow the bot to be started on boot and prevents the turtle from being used for non-intended purposes.