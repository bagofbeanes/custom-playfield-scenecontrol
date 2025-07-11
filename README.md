# Custom Playfield scenecontrol

Scenecontrol to provide more extensive control over the ArcCreate playfield.

## > How to use

1. If there isn't one already, create a "Scenecontrol" (case-sensitive) folder within your chart folder
2. [Download the latest .zip](https://github.com/bagofbeanes/custom-playfield-scenecontrol/archive/refs/heads/main.zip)
3. Extract the .zip contents into the "Scenecontrol" folder
4. If necessary, merge the `init.lua` with that of other scenecontrols.

## > Features

- Skinning of all playfield elements (track, extra track (a.k.a 6k track) and sky input)
- Setting the lane count for both types of tracks
- Creating and controlling more than one playfield

## > Documentation

> [!IMPORTANT]
> This scenecontrol is not configurable in the editor and expects a basic understanding of the Lua language and the ArcCreate scenecontrol API.

<hr>

### > Playfield creation and manipulation

- This scenecontrol removes the original playfield and allows you to create multiple custom ones instead.
- To create a new playfield, use `Playfield:new()`.<br/>
  This method has 2 parameters: `skin` and `max_lane_count`.

  - `skin`: You can select a skin from the provided `skin_list` module. By default these are ArcCreate's preexisting track skins, but you can create your own as well (more on that in a later section).
  - `max_lane_count`: Determines the maximum amount of lanes a playfield can hold. This will be the cap for both the regular and the extra track.

- Use the playfield's fields to transform and manipulate it. The key elements are:
  - `playfieldController`: Controls the entire playfield
  - `trackController`: Controls just the regular track and its elements
  - `trackExtraController`: Controls the extra (6k) track and its elements, deactivated on creation
  - `skyInputController`: Controls the sky input elements
- There are other elements besides these that control the more inner parts of the playfield, such as `trackBody` that controls just the regular track body and none of its elements.

<hr>

### > Playfield element parenting

- Playfield elements behave like normal Controllers for the most part. One of the exceptions is parenting.
- If you want to parent a playfield element to a Controller or parent a Controller to it, you'll need to use `ControllerObject.setParentC()`.<br/>
  This method has 2 parameters: `child` and `parent`.
  
  - `child`: The Controller or playfield element (`ControllerObject`) to be parented
  - `parent`: The parent Controller or playfield element (`ControllerObject`)

<hr>

### > Track lane count

- Another unique feature of this scenecontrol besides the ability to add playfields is being able to set the number of lanes a track has. This works for both the regular and the extra track.
- To set the lane count of the regular track, use `<playfield_name>:setLaneCount()`.<br/>
  To set it on the extra track, use `<playfield_name>:setExtraLaneCount()`.<br/>
  Both have 4 parameters: `lane_count`, `start_timing`, `end_timing` and `easing`.

  - `lane_count`: The number of lanes to display
  - `start_timing`: The start timing of the lane animation (in ms)
  - `end_timing`: The end timing of the lane animation (in ms). Optional; if omitted, `start_timing` will be used as the end timing.
  - `easing`: The easing type to use for the lane animation. Optional; if omitted, a linear easing type will be used.

- It's important to mention here that you can use `Context.laneFrom` and `Context.laneTo` to modify the range of the floor input indicator.
- An additional field `Context.skyInputHeight` has been added; use it to move the maximum height of the sky input indicator.

<hr>

### > Playfield skinning

- As previously mentioned, this scenecontrol also allows the skinning of each playfield element. There are built-in skins which use ArcCreate's playfield assets, accessible via the `skin_list` module.
- If you wish to add to this list, go to `custom_playfield/skinlist.lua`, where you can create your own skin using the format provided below.
  
```lua
skin_list.myskin = PlayfieldSkin:new(

    'builtin/light', -- track
    'editor', -- critical line
    'builtin/light', -- track edge
    'editor', -- lane divider
    'builtin/light', -- extra track
    'editor', -- extra critical line
    'builtin/light', -- extra track edge
    'editor', -- extra track lane divider
    'editor', -- sky input line
    'editor' -- sky input label

)
```

- To change this from being a basic light side skin, you can change the IDs to other built-in ones, or add your own skin elements.
  
- Skin elements are stored in the folder `custom_playfield/sprites/skins/`. From here, the folder names specify the skin IDs.
  - As an example, the built-in skins are located under `builtin`, which stores each skin in its own folder, such as `conflict` and `light`. Therefore the full skin ID is `builtin/conflict` and `builtin/light` respectively.
  
- `editor` is a special skin ID used when you want the skin element to be taken from the skin set in the editor.
